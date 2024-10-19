class Animator
{
  /* FIELDS */
  
  // The final keyword makes the variable turn into constant
  
  Competition comp;
  final int track_x_start;
  final int track_y_start;
  final int track_width;
  final int track_length;
  int index; // what round is the animator playing now
  int heat; // what heat of the round is the animator playing now
  Boolean freezing; // record if the program is freezing (drawing but not updating)
  int tracker; // track how many frames has the program freezed
  int max_frames_freeze; // the duration of the freezing
  
  // arrays
  
  ArrayList<Bar> bars;
  ArrayList<Athlete> curr_group; // the array of the current group of athletes racing 
  
  
  /* CONSTRUCTOR */
  
  Animator(Competition c)
  {
    this.comp = c;
    this.track_x_start = 200;
    this.track_y_start = 200;
    this.track_width = 40;
    this.track_length = 600;
    this.index = 1;
    this.heat = 1;
    this.tracker = 0;
    this.max_frames_freeze = 0;
    this.freezing = false;
    this.bars = new ArrayList<Bar>();
    
    for (int i = 0; i < 8; ++i)
    {
      Bar b = new Bar(this.track_length, this.track_x_start, this.track_y_start + i * this.track_width, this.track_width);
      
      this.bars.add(b);
    }
    
    this.set_time();
    
    
  }
  
  
  /* METHODS */
  
  
  
  //  COMPARATORS
  
  
  int compare_lane(Athlete a1, Athlete a2)
  {
    // sort the array in ascending ordery by lane #
    
    int l1 = a1.lanes[this.index-1], l2 = a2.lanes[this.index-1];
    
    if (l1 < l2)
    {
      return -1;
    }
    
    if (l1 > l2)
    {
      return 1;
    }
    
    return 0;
  }
  
  
  // MAINTAINING AND UPDATING METHODS
  
  
  Boolean check_all_finished()
  {
    // this function check if all the bars have reached the finish line, after making them all move
    
    Boolean all_finished = true;
    
    for (Bar b : this.bars)
    {
      b.move();
      
      if (!b.finish)
      {
        all_finished = false;
      }
    }
    
    return all_finished;
  }
  
  
  
  
  void update()
  {
    
    
    if (this.index == 3)
    {
      // if this final it will freeze forever because there is no point of switching to another group
      
      return;
    }
    else
    {
      
      if (this.heat == this.comp.groups.get(this.index-1).size())
      {
        // if all the heats in this round have finished, we switch to another round, and heat #1
        
        this.heat = 1;
        this.index ++;
      }
      else
      {
        // if the heats in this round have not finished we just increment it
        
        this.heat++;
      }
      
      // but whatever, when we finish a heat we going to reset the bars to the time of next group
      
      this.set_time();
      
    }
    
  }

  
  
  
  void set_time()
  {
    
    for(int i = 0; i < this.bars.size(); ++i)
    {
      
      // first reset all the bars
      
      Bar b = this.bars.get(i);
      
      b.reset();
      
      
      if (this.index < 3)
      {
        this.curr_group = this.comp.groups.get(this.index-1).get(this.heat-1); // get the qualifying group array (round1/semis)
        Collections.sort(this.curr_group, this::compare_lane); // sort the array by lane
      }
      else
      {
        this.curr_group = this.comp.athletes.get(this.index-1); // get the final group array
        Collections.sort(this.curr_group, this::compare_lane); // sort the array by lane
      }
      
      Athlete a = this.curr_group.get(i);
      
      float result = a.results[this.index-1]; // get the result
      
      // if the athlete is DQ/DNF, he has no mark with -1 in the results array
      
      Boolean no_mark = false;
      
      if (result < 0)
      {
        no_mark = true;
      }
      
      b.set_time(result, no_mark);
      
    }
  }
  
  
  // DRAWING METHODS
  
  
  
  void draw_bg()
  {
    // Draw background (track and labels)
    
    textAlign(CENTER, TOP);
    
    fill(0, 0, 100); // white
    
    // Draw the event name and venue on top
    
    textSize(35);
    text(this.comp.event_name, width/2, 10);
    
    textSize(25);
    text(this.comp.venue, width/2, 45);
    
    // Draw the tracks
    
    fill(track_col);
    
    int rect_width = 8 * track_width;
    
    stroke(0, 0, 100); //white stroke
    strokeWeight(3);
    
    rect(this.track_x_start, this.track_y_start, this.track_length, rect_width);
    
    fill(0, 0, 100); // fill white
    
    // Label each track with a number
    
    for (int i = this.track_y_start, num = 1; i < this.track_y_start + rect_width; i += this.track_width, num++ )
    {
      if (i > track_y_start)
        line(track_x_start, i, track_x_start + track_length, i);
      
      textSize(25);
      textAlign(CENTER, CENTER);
      text( str(num), track_x_start + track_length - track_width/2, i + track_width/2 );
    }
    
    // draw a vertical line at the near end of the track to make the numbers in a "square"
    
    line(track_x_start + track_length - track_width, track_y_start, track_x_start + track_length - track_width, track_y_start + rect_width);
  }
  
  
  
  
  void display_info()
  {
    String[] arr = {"Round 1", "Semi-final", "Final"};
    
    String race_name = arr[this.index - 1]; // make sure the round title is correct
    
    if (this.index < 3)
    {
      // if it is qualifying group we also need to specify what heat
      
      race_name = race_name + "  Heat " + str(this.heat);
    }
    
    fill(0, 0, 100);
    
    // Display the race name
    
    textAlign(LEFT, TOP);
    
    text(race_name, track_x_start, track_y_start - 100);
    
    // Display the wind info (no other weather information because wind is the only info that appear on TV)
    
    float wind = round_to( this.comp.weathers.get(this.index-1).get(this.heat-1).wind, 1);
    
    text("Wind: ", track_x_start, track_y_start - 50);
    
    if (wind > 2)
    {
      // wind > 2.0 m/s is illegal wind and we need to fill it with red
      
      fill(0, 100, 100);
    }
    
    text(str(wind) + " m/s", track_x_start + textWidth("Wind: "), track_y_start - 50);
    
    // Display all the athletes in this group and their nationalities
    
    ArrayList<Athlete> al = this.curr_group;
    
    textAlign(RIGHT, CENTER);
    textSize(14);
    
    
    for (int i = 0; i < al.size(); ++i)
    {
      fill(0, 0, 100);
      int x = track_x_start - 5;
      int y = track_y_start + track_width/2 + track_width * i;
      String my_text = al.get(i).last_name + "  (" + al.get(i).nationality + ")";
      
      if (al.get(i).defending_champ)
      {
        // If this is defending champion we highlight it with reddish orange
        
        fill(8, 95, 99);
      }
      
      text(my_text, x, y);
    }
    
  }
  
  
  
  
  
  void draw_bars()
  {
    for (int i = 0; i < this.bars.size(); ++i)
    {
      Bar b = this.bars.get(i);
      
      if (b.finish)
      {
        // If the bar is finished, we display the result
        
        textAlign(LEFT, CENTER);
        textSize(18);
        fill(0, 0, 100);
           
        int y = track_y_start + track_width/2 + track_width * i;
        
        String result_str = "";
        
        Athlete a = this.curr_group.get(i);
        
        
        // result can either be DQ, DNF, or actual time
        // If the athlete break some "record" we also display it
        
        if (a.results[this.index-1] < 0)
        {
          if (a.DQ)
          {
            result_str = "DQ";
          }
          else if (a.DNF)
          {
            result_str = "DNF";
          }
        }
        else
        {
          result_str = nf( round_to(a.results[this.index-1], 3), 0, 3 );
        }
        
        if (this.index < 3)
        {
          result_str = custom_tab(result_str, 7) + a.qualifys[this.index-1];
        }
        
        // the logic of this if-statement is that a WR is always a PB (isn't it?) and so on, so we use this order
        
        if (a.break_WR[this.index-1])
        {
          result_str += "  WR";
        } 
        else if (a.break_PB[this.index-1])
        {
          result_str += "  PB";
        }
        else if (a.break_SB[this.index-1])
        {
          result_str += "  SB";
        }
        
        text(result_str, track_x_start + track_length + 5, y);
        
        
        // If this is the final we are giving the players medals!
        
        
        if (index == 3)
        {
          int rank = a.ranks[index-1];
          
          int margin = 70;
          
          if(rank == 1)
          {
            image(gold, width - margin - track_width, y - track_width/2, track_width, track_width);
          }
          else if(rank==2)
          {
            image(silver, width - margin - track_width, y - track_width/2, track_width, track_width);
          }
          else if(rank == 3)
          {
            image(bronze, width - margin - track_width, y - track_width/2, track_width, track_width);
          }
        }
        
      }
      
      // whether the bar is finished or not we are always drawing it
      
      b.draw_self();
      
    }
  }
  
  
  
  
  // ANIMATING METHOD
  
  
  
  void animate()
  {
    
    this.draw_bg();
    
    this.display_info();
    
    this.draw_bars();
    
    Boolean all_finished = check_all_finished(); // check if the bars are all finished every frame
    
    // if all finished we freeze the screen fro 5 seconds to make sure viewers can see the result for some time
    // in the meantime we only draw the things but don't update them so that the bars are static
    
    if (all_finished)
    {
      this.freezing = true;
      this.max_frames_freeze = int(frameRate * 5);
    }
    
    if (this.freezing)
    {
      
      ++tracker;
      
      if (tracker >= max_frames_freeze)
      {
        // upon the reach of the time limit, we don't freeze anymore
        
        freezing = false;
        tracker = 0;
      }
      
    }
    
    if (all_finished && !freezing)
      this.update();
  
  }
  
  
}
