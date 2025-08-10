class Commentator
{
  
  /* FIELDS */
  
  Competition comp;
  int index;
  
  
  /* CONSTRUCTOR */
  
  Commentator(Competition c)
  {
    this.comp = c;
    this.index = 1;
  }
  
  
  
  /* METHODS */
  
  
  
  // CONSTRUCTOR
  
  
  int compare_comment(Athlete a1, Athlete a2) 
  {
    
    // return -1 the element is BEFORE the other
      
    // Check for DQ first (DQ is the first)
    
    if (a1.DQ && !a2.DQ) 
    {
      return -1;
    } 
    else if (!a1.DQ && a2.DQ) 
    {
      return 1;
    }
    
    // Check for DNF next (DNF is before than finishing)
    
    if (a1.DNF && !a2.DNF) 
    {
      return -1; 
    } 
    else if (!a1.DNF && a2.DNF) 
    {
      return 1; 
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
  
  
  
  int compare_PB(Athlete a1, Athlete a2)
  {
    // sort the array by PB ascending order
    
    if (a1.PB < a2.PB)
    {
      return -1;
    }
    
    if (a1.PB > a2.PB)
    {
      return 1;
    }
    
    return 0;
  }
  
  
  
  // PRINTING-METHODS
  
  
  
  
  void greeting()
  {
    
    // Just intro and introduce the event
    
    ArrayList<Athlete> al = this.comp.athletes.get(0);
    
    println("Welcome to the", this.comp.event_name, "here at", this.comp.venue);
    
    println("We have", al.size(), "athletes here, and they are:");
    println();
    
    for (Athlete a : al)
    {
      delay(100);
      a.introduction();
    }
    
    
  }
  
  
  
  void group_commenting()
  {
    if (this.index < 3)
    {
      for (int i = 0; i < this.comp.groups.get(index-1).size(); ++i)
      {
        String[] arr = {"Round 1", "Semi-final"};
        
        println(arr[this.index - 1], "Heat", i + 1, "starts now!");
        
        table_divider();
        
        float wind = round_to( this.comp.weathers.get(index-1).get(i).wind, 1);
        
        String add_comment = "";
        
        // Add some comment on the wind
        
        if (wind > 2)
        {
          add_comment = "Ahhh! It's too windy, so the PB/WR can never be legal! That's a shame";
        }
        else if (wind >= 1)
        {
          add_comment = "Wow. This is so luckly wind, will there be new PB?";
        }
        else if (wind <= -1)
        {
          add_comment = "Oh dear! This wind is so horrible. Bad luck!";
        }
        
        
        println("The wind is", wind, "m/s.", add_comment);
        
        table_divider();
        
        ArrayList<Athlete> curr_heat = this.comp.groups.get(index-1).get(i);
        
        Collections.sort(curr_heat, this::compare_comment);
        
        // call the commenting function in each athlete one by one
        
        for (Athlete a : curr_heat)
        {
          delay(1000);
          a.print_result_comment(this.index);
        }
        
        section_divider();
        
      }
      
    }
    else
    {
      println("This is the ultimate final! Who will get the throne?");
      
      table_divider();
        
      float wind = round_to( this.comp.weathers.get(index-1).get(0).wind, 1);
      
      String add_comment = "";
      
      // add comment on the wind speed
      
      if (wind > 2)
      {
        add_comment = "Ahhh! It's too windy, so the PB/WR can never be legal! That's a shame";
      }
      else if (wind >= 1)
      {
        add_comment = "Wow. This is so luckly wind, will there be new PB?";
      }
      else if (wind <= -1)
      {
        add_comment = "Oh dear! This wind is so horrible. Bad luck!";
      }
      
      
      println("The wind is", wind, "m/s.", add_comment);
      
      table_divider();
      
      ArrayList<Athlete> al = this.comp.athletes.get(this.index - 1);
      
      Collections.sort(al, this::compare_comment);
      
      
      // A race is generally very close if the 1st and 2nd is differ by 0.01 or 1st and 4th differ by 0.04
      
      if ( (al.get(1).results[this.index-1] - al.get(0).results[this.index-1] < 0.01) || 
      (al.get(3).results[this.index-1] - al.get(0).results[this.index-1] < 0.04) )
      {
        println("Oh wow! This race is so so so close! Check it out who is the winner!");
        println();
      }
      
      // call the commenting function in each athlete one by one
      
      for (Athlete a : this.comp.athletes.get(this.index - 1))
      {
        delay(1000);
        a.print_result_comment(this.index);
      }
    }
    
    
  
  }
  
  
  
  
  void print_advanced()
  {
    // Display all the athlete that advance to the next round
    
    if (this.index == 3)
      return;
    
    ArrayList<Athlete> al = this.comp.athletes.get(this.index);
    
    String[] arr = {"Semi-final", "Final"};
    
    println("These guys are going to the " + arr[this.index - 1] + "! Congratulations!");
    
    table_divider();
    
    for (Athlete a : al)
    {
      delay(500);
      a.print_advanced_comment(this.index);
    }
    
    section_divider();
  }
  
  
  
  void say_goodbye()
  {
    println("That's all guys! Congratulations to these guys for their crazily amazing performance!");
    println("We will see you again at the next World Championships 2 years later!");
  }
  
  
  
  

}
