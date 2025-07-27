// HOST MANAGES EVERYTHING (but not include the animation)

class Host
{
  
  /* FIELDS */
  
  Competition comp; // competition object
  Commentator comm; // commentator object
  int index; // very important variable. controls the current round of the event. 
  // 1 is round1, 2 is semi-final, 3 is final
  
  
  /* CONSTRUCTOR */
  
  
  Host(Competition c1, Commentator c2)
  {
    this.comp = c1;
    this.comm = c2;
    this.index = 1; // initialize it as "round 1"
  }
  
  
  // METHODS
  
  
  void whole_process(Boolean commenting)
  {
    // this one do the file outputing and commentator (if user choose so) simultaneously
    
    this.comp.pw_title();
    
    if (commenting)
      this.comm.greeting();
    
    // use a for-loop to go through all 3 rounds of the event
    
    for (int i = 1; i <= 3; ++i)
    {
      // assign the index to itself and the employees (objects)
      
      this.index = i;
      this.comp.index = i;
      this.comm.index = i;
      
      
      pw_stage_divider();
      
      if (commenting)
        stage_divider();
        
        
      /* 
        1. fill group, assign the lanes
        2. we have the startlist so we print them
        3. race!
        4. print the grouped results (if it is now qualifying)
        5. print the summary results
        6. either add index to the next round, or say goodbye, depending on the current index
      
      */
      
      
      this.comp.fill_group();
      
      this.comp.pw_print_startlist();
      
      
      this.comp.stage_compete();
      
      this.comp.pw_grouped_results();
      
      if (commenting)
        this.comm.group_commenting();
      
      this.comp.pw_summary_results();
      
      if (commenting)
        this.comm.print_advanced();
      
      
    }
    
    if (commenting)
    {
      stage_divider();
      
      this.comm.say_goodbye();
      
    }
    
  }
  
}
