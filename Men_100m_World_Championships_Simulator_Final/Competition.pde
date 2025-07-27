class Competition
{
  /* ***** FIELDS ***** */
  
  final String event_name;
  final String venue;
  
  int index;
  
  
  ArrayList< ArrayList<Athlete> > athletes; // 3 nested inside (56, 24, 8)
  
  ArrayList< ArrayList< ArrayList<Athlete> > > groups; // [ 7 * 8, 3 * 8, 1 * 8]
  
  ArrayList< ArrayList<Weather> > weathers; // 3 nested inside (7, 3, 1)
  
  
  /*  ***** CONSTRUCTOR ***** */
  
  Competition(String en, String v, float altitude, float base_temperature, float base_humidity, float base_barometer )
  {
    // initialize all the fields
    
    this.event_name = en;
    this.venue = v;
    
    
    this.index = 1;
    
    
    // initialize the athletes
    
    
    this.athletes = new ArrayList< ArrayList<Athlete> >();
    
    for (int i = 0; i < 3; ++i)
    {
      this.athletes.add(new ArrayList<Athlete>());
    }
    
    
    this.getAthletes();
    
    
    // initialize the group
    
    this.groups = new ArrayList< ArrayList< ArrayList<Athlete> > >();
    
    
    for (int i = 0; i < 3; ++i)
    {
      this.groups.add(new ArrayList< ArrayList<Athlete> >());
    }
    
    for (int i = 0; i < 7; ++i)
    {
      this.groups.get(0).add(new ArrayList<Athlete>());
    }
    
    for (int i = 0; i < 3; ++i)
    {
      this.groups.get(1).add(new ArrayList<Athlete>());
    }
    
    this.groups.get(2).add(this.athletes.get(2));
    
    
    //  weather array
    
    this.weathers = new ArrayList< ArrayList<Weather> >();
    
    
    
    int[] sizes_temp = {8, 3, 1};
    
    for (int i = 0; i < 3; ++i)
    {
      this.weathers.add(new ArrayList<Weather>());
      
      for (int j = 0; j < sizes_temp[i]; ++j)
      {
        Weather w = new Weather(altitude, base_temperature, base_humidity, base_barometer);
        this.weathers.get(i).add( w );
      }
    }
    
  }
  
  
  
  /* ***** METHODS ***** */
  
  
  
  /* FILE READING METHODS */
  
  
  
  void getAthletes()
  {
    // This function reads the file and get the atheletes objects
    
    String[] allData = loadStrings("Athletes Data.csv");
    
    for (int i = 0; i < allData.length; ++i)
    {
      String this_row = allData[i];
      String[] parts = this_row.split(",");
      
      int wr = int(parts[0]);
      String fn = parts[1];
      String ln = parts[2];
      float pb = float(parts[3]);
      float sb = float(parts[4]);
      String nat = parts[5];
      float ment = float(parts[6]);
      float health = float(parts[7]);
      String def = parts[8];
      
      Athlete a = new Athlete(wr, fn, ln, pb, sb, nat, ment, health, def);
      
      this.athletes.get(0).add( a );
    }
  }
  
  
  
  
  
  
  
  
  /* COMPARATORS */
  
  
  
  
  int compare_result(Athlete a1, Athlete a2) 
  {
    
    // return -1 the element is BEFORE the other
      
    // Check for DQ first (DQ is the worst)
    
    if (a1.DQ && !a2.DQ) 
    {
      return 1;
    } 
    else if (!a1.DQ && a2.DQ) 
    {
      return -1;
    }
    
    // Check for DNF next (DNF is worse than finishing)
    
    if (a1.DNF && !a2.DNF) 
    {
      return 1; 
    } 
    else if (!a1.DNF && a2.DNF) 
    {
      return -1; 
    }
  
    // If neither are DQ or DNF, compare based on results (fastest is better)
    
    if (a1.results[this.index - 1] < a2.results[this.index - 1]) 
    {
      return -1;
    } 
    else if (a1.results[this.index - 1] > a2.results[this.index - 1]) 
    {
      return 1;
    }
  
    // tied
    
    return 0;
  }
  
  
  
  
  
  /* COMPETING-RELATED ARRANGEMENTS & COMPUTATIONS METHODS */
  
  
  
  
  void race(int heat_num)
  {
    
    // this basically uses a loop to apply the weather and get result to every single athlete in the racing group
    
    if (this.index == 3)
      heat_num = 1; // make it to 0 so that it prevents the case we pass a number > 0 and cause error
      
    ArrayList<Athlete> curr_group = this.groups.get(this.index - 1).get(heat_num - 1);
    
    Weather w = this.weathers.get(index - 1).get(heat_num - 1);
    
    float weather_effect = w.get_effect();
    
    int dq_num = int( random(1, 8.99) ); // randomly select an athlete and applying dq drama
    
    
    for ( int i = 0; i < curr_group.size(); ++i )
    {
      Boolean selected = ( dq_num == i + 1) ? true : false; // ternary operator, yeah!
      curr_group.get(i).get_result(this.index, weather_effect, w.wind, selected);
    }
    
    
  }
  
  
  
  
  
  
  void fill_group()
  {
    
    // for qualifying we need to make sure the level for every group is roughly equal
    // we don't want top 5 athletes to be in one group, that's so unfair
    
    
    if (this.index < 3)
    {
      // split into tiers. each guy a tier do not meet in the group
      
      int tier_size = this.athletes.get(this.index - 1).size() / 8;
    
      for (int tier = 0; tier < 8; ++tier)
      {
        // use sublist to get the curreent tier
        
        ArrayList<Athlete> currentTier = new ArrayList<Athlete>( this.athletes.get(index - 1).subList(tier * tier_size, (tier + 1) * tier_size) );
        
        Collections.shuffle(currentTier); // shuffle it to make the distribution even more equal
        
        // each guy in the tier go to unique group
        
        for (int i = 0; i < currentTier.size(); ++i)
        {
          this.groups.get(index - 1).get(i).add(currentTier.get(i));
        }
        
      }
      
      
      // In each heat we are shuffling again to assign random lanes
      
      
      for (ArrayList<Athlete> al : this.groups.get(this.index - 1))
      {
        Collections.shuffle(al);
        
        for (int i = 0; i < al.size(); ++i)
        {
          al.get(i).lanes[this.index - 1] = i + 1;
          al.get(i).heat_nums[this.index - 1] = this.groups.get(this.index - 1).indexOf(al) + 1;
        }
      }
      
    }
    else
    {
      // if this is final we don't worry about tier any more (tier size will be 1)
      // we just random shuffle the array and assign the lanes
    
      Collections.shuffle(this.athletes.get(this.index - 1));
    
      for (Athlete a : this.athletes.get(this.index - 1))
      {
        a.lanes[index - 1] = this.athletes.get(this.index - 1).indexOf(a) + 1;
      }
    
    }

  
  }
  
  
  
  
  void stage_compete()
  {
    
    if (this.index < 3)
    {
      // for qualifying, race each heat and get the qualifiers and put them into the next stage array
      
      for ( int i = 0; i < this.groups.get(this.index - 1).size(); ++i )
      {
        ArrayList<Athlete> al = this.groups.get(this.index - 1).get(i);
        
        int heat_num = i + 1;
        
        this.race(heat_num);
        
        
        Collections.sort(al, this::compare_result); /* Use :: for method reference instead of calling a function to use it as comparator */
        
        
        for (int j = 0; j < al.size(); ++j)
        {
          // assign the rankings and get the automatic qualifiers based on the sorted order
          
          int maxQ = (this.index == 1) ? 3 : 2;
          
          if (j < maxQ)
          {
            al.get(j).qualifys[this.index - 1] = "Q";
            this.athletes.get(this.index).add(al.get(j));
            
          }
          
          al.get(j).ranks[this.index - 1] = j + 1;
          
        }
        
        
      }
      
      // get the secondary qualifiers
      // sort the WHOLE array and get the fastest guys who are not qualified yet
      
      Collections.sort(this.athletes.get(this.index - 1), this::compare_result);
      
      
      int maxq = (this.index == 1) ? 3 : 2;
      
      
      for (int i = 0, count = 0; i < this.athletes.get(this.index - 1).size(); ++i)
      {
        
        if (count >= maxq)
          break; // if we have enough guys we can exit this
        
        
        if ( this.athletes.get(this.index - 1).get(i).qualifys[this.index - 1].equals("out") )
        {
          this.athletes.get(this.index - 1).get(i).qualifys[this.index - 1] = "q";
          this.athletes.get(this.index).add(this.athletes.get(this.index - 1).get(i));
          ++count;
        }
        
      }
      
      
      Collections.sort(this.athletes.get(this.index), this::compare_result); // this is the array for the next stage, for beneficial we sort it
      
    }
    else
    {
      // if it's the final we just race it and get the ranks, easy
      
      this.race(1);
      
      Collections.sort(this.athletes.get(2), this::compare_result);
      
      
      for (int i = 0; i < this.athletes.get(2).size(); ++i)
      {
        this.athletes.get(2).get(i).ranks[this.index - 1] = i + 1;
      }
        
    }
    
  }
  
  
  
  /* FILE OUTPUT METHODS */
  
  
  
  void pw_title()
  {
    // the title of the document
    
    pw_stage_divider();
    pw.println();
    pw.println(this.event_name);
    pw.println();
    pw.println(this.venue);
    pw.println();
  }
  
  
  
  void pw_print_startlist()
  {
    // print the startlist table
    
    String[] arr = {"Round-1", "Semi-final", "Final"};
    pw.println(arr[this.index -1] + " Startlist");
    
    pw_table_divider();
    
    if (this.index == 1)
      pw.println( custom_tab("Name", 30) + "Nat." + "\t" + "SB" + "\t" + "Lane");
    else
      pw.println( custom_tab("Name", 30) + "Nat." + "\t" + "Prev." + "\t" + "Lane");
    
    pw_table_divider();
    
    
    // if it is qualifying status we need to display the heat number as well
    
    if ( this.index < 3)
    {
      int heat = 1;
      
      
      for ( ArrayList<Athlete> al : this.groups.get(this.index - 1) )
      {
        pw.println( "Heat " + str(heat) );
        
        pw_table_divider();
       
        for (Athlete a : al)
        {
          a.pw_print_self_startlist(this.index);
        }
        
        ++heat;
        pw.println();
        
      }
      
    }
    else
    {
      for (Athlete a : this.groups.get(this.index - 1).get(0) )
      {
        a.pw_print_self_startlist(this.index);
      }
    }
    
    
    pw_section_divider();
    
  }
  
  
  
  
  void pw_grouped_results()
  {
    // this is only for non-final ones
    // display each heat and the wind info, and results of each athlete in each group
    
    if (this.index == 3)
      return;
      
    String[] arr = {"Round-1", "Semi-final"};
    
    pw.println( arr[this.index-1] + " Results");
    
    pw_table_divider();
    
    pw.println( custom_tab("Name", 30) + "Nat." + "\t" + "Lane" + "\t" + "Mark" + "\t" + "Qual.");
    
    pw_table_divider();
    
    
    // Use a nested for-loop to print out the grops
    
    int heat = 1;
      
    for (int i = 0; i < this.groups.get(this.index - 1).size(); ++i) // outer loop constrols the heat
    {
      
      ArrayList<Athlete> curr_heat = this.groups.get(this.index - 1).get(i); // get the array of this heat
      
      // first print the header of the table
      
      pw.println("Heat " + str(heat) );
      
      float wind = round_to( this.weathers.get(this.index - 1).get(i).wind, 1 );
      float temperature = round_to( this.weathers.get(this.index - 1).get(i).temperature, 1 );
      int humidity = round( this.weathers.get(this.index - 1).get(i).humidity );
      
      pw.println("Wind: " + str(wind) + " m/s\tTemp: " + temp_str(temperature) + "\tHumid: " + str(humidity) + "%");
      
      pw_table_divider();
      
      // the inner loop controls the athlete individual
     
      for (Athlete a : curr_heat)
      {
        a.pw_print_self_results(this.index, false);
      }
      
      ++heat;
      pw.println();
      
      
    }
    
    
    
    pw_section_divider();
    
  }
  
  
  
  
  
  void pw_summary_results()
  {
    
    // this is more general than grouped results, and applys for ALL rounds
    // we view the athletes in the WHOLE round in a single TABLE to visualize the general rankings
    
    String[] arr = {"Round-1", "Semi-final", "Final"};
    
    pw.println(arr[this.index - 1] + " Results Summary");
    
    
    if (this.index == 3)
    {
      // if it is the final we can display the weather details, same as the grouped results
      // but for qualifying we tend to display only the qualify status cuz the grouped results have displayed before
      // also the qualifying rounds is a lot of people so we need to keep it simple
      
      pw_table_divider();
      
      float wind = round_to( this.weathers.get(this.index - 1).get(0).wind, 1 );
      float temperature = round_to( this.weathers.get(this.index - 1).get(0).temperature, 1 );
      int humidity = round( this.weathers.get(this.index - 1).get(0).humidity );
      
      pw.println("Wind: " + str(wind) + " m/s\tTemp: " + temp_str(temperature) + "\tHumid: " + str(humidity) + "%");
    }
    
    pw_table_divider();
    
    // then we just call the results function in each athlete in the round using a loop in the current round array
    
    if (this.index < 3)
      pw.println( custom_tab("Name", 30) + "Nat." + "\t" + "Heat" + "\t" + "Lane" + "\t" + "Mark" + "\t" + "Qual.");
    else
      pw.println( custom_tab("Name", 30) + "Nat." + "\t" + "Lane" + "\t" + "Mark");
    
    pw_table_divider();
    
    for (Athlete a : this.athletes.get(this.index - 1))
    {
      a.pw_print_self_results(this.index, true);
    }
    
  }
  
  

}


/* END OF CLASS */
