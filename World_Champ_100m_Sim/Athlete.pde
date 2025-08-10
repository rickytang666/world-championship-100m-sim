class Athlete
{
  /* ***** FIELDS ***** */
  
  // final means constant, you can never assign it unless in constructor
  
  final String name;
  final String first_name;
  final String last_name;
  
  int world_rank;
  float PB; // personal best
  float SB; // season's best -> best reperesents the athlete's current performance level
  final String nationality;
  float mentality; // the higher the more likely the athlete gets good result
  float health; // if not 100, the athlete might have some probability to injure or run very slow
  Boolean defending_champ;
  Boolean DNF; // did not finish. injured during the race
  Boolean DQ; // disqualified. false start in the race
  
  // Arrays that stores the athlete's data throughout the event
  
  float[] results;
  int[] ranks;
  int[] lanes;
  int[] heat_nums;
  String[] qualifys;
  Boolean[] break_SB;
  Boolean[] break_PB;
  Boolean[] break_WR;
  
  
  /*  ***** CONSTRUCTOR ***** */
  
  Athlete( int wr, String fn, String ln, float pb, float sb, String nat, float ment, float h, String def)
  {
    this.first_name = fn;
    this.last_name = ln;
    this.name = fn + " " + ln;
    this.world_rank = wr;
    this.PB = pb;
    this.SB = sb;
    this.nationality = nat;
    this.mentality = ment;
    this.health = h;
    
    if (def.equals("y") )
    {
      this.defending_champ = true;
    }
    else
    {
      this.defending_champ = false;
    }
    
    this.DNF = false;
    this.DQ = false;
    
    // initilialize into boring values
    
    this.results = new float[]{-1, -1, -1};
    this.ranks = new int[]{99, 99, 99};
    this.lanes = new int[]{-1, -1, -1};
    this.heat_nums = new int[]{-1, -1};
    this.qualifys = new String[]{"out","out"};
    this.break_SB = new Boolean[]{false, false, false};
    this.break_PB = new Boolean[]{false, false, false};
    this.break_WR = new Boolean[]{false, false, false};
    
  }
  
  
  
  /* ***** METHODS ***** */
  
  
  
  /* FILE OUTPUTING METHODS */
  
  
  
  void pw_print_self_startlist(int index)
  {
    String def_str = (this.defending_champ) ? "DEFENDING CHAMPION" : "";
    
    if (index == 1) // since this is round 1 we don't have any previous results, we display just SB
    {
      pw.println( custom_tab(this.name, 30) + this.nationality + "\t" + str( this.SB ) + "\t" + str( this.lanes[index - 1]) + "\t" + def_str);
    }
    else
    {
      String prev = nf( round_to(this.results[index - 2], 3), 0, 3 );
      pw.println( custom_tab(this.name, 30) + this.nationality + "\t" + prev + "\t" + str( this.lanes[index - 1]) + "\t" + def_str );
    }
  }
  
  
  
  void pw_print_self_results(int index, Boolean summary)
  {
    // Display the "record"s if any
    
    String breakthrough = "";
    
    if (this.break_WR[index-1])
    {
      breakthrough = "WR";
    }
    else if (this.break_PB[index - 1])
    {
      breakthrough = "PB";
    }
    else if (this.break_SB[index - 1])
    {
      breakthrough = "SB";
    }
    
    String result_str = "";
    
    if (this.DQ)
    {
      result_str = "DQ";
    }
    else if (this.DNF)
    {
      result_str = "DNF";
    }
    else
    {
      result_str = nf( round_to(this.results[index - 1], 3), 0, 3 );
    }
    
    
    if (index < 3)
    {
      String heat_str = (summary) ? str(this.heat_nums[index-1]) + "\t" : ""; // if it is no summary just grouped results, we dont need to print out the heat number
      
      pw.println( custom_tab(this.name, 30) + this.nationality + "\t" + heat_str 
      + str(this.lanes[index - 1]) + "\t" + result_str + "\t" 
      + this.qualifys[index - 1] + "\t" + breakthrough );
    }
    else
    {
      // if it is final we also display the medals/certificates
      
      String honor_str = "";
      String def_str = (this.defending_champ && this.ranks[index - 1] == 1) ? "TITLE DEFENDED!" : "";
      
      if ( !this.DQ && !this.DNF )
      {
        honor_str = "Certificate";
        
        if ( this.ranks[index - 1] <= 3 )
        {
          honor_str = medals[ this.ranks[index - 1] - 1 ];
        }
      }
      
      pw.println( custom_tab(this.name, 30) + this.nationality + "\t" + str(this.lanes[index - 1]) 
      + "\t" + result_str + "\t" + custom_tab( honor_str, 15) + breakthrough + "\t" + def_str);
    }
  }
  
  
  
  /* COMMENTATOR-PRINTING METHODS */
  
  
  
  void introduction()
  {
    // display the title, name, ranking, nationality, and PB + SB
    
    String pb_str = nf( this.PB, 0, 2 );
    String sb_str = nf( this.SB, 0, 3 );
    
    String def_str = (this.defending_champ) ? ", also the defending champion!" : "";
    println("World rank No." + str(this.world_rank) + ", " + this.name + " from " + this.nationality + ", with a personal best of "
    + pb_str + " and season's best of " + sb_str + def_str);
  }
  
  
  
  
  void print_advanced_comment(int index)
  {
    // display the qualifier type and result
    
    String qualify_str = (this.qualifys[index-1] == "Q") ? "Automatic Qualifier" : "Secondary Qualifier";
    String result_str = nf( round_to(this.results[index-1], 3), 0, 3 );
    println( custom_tab(this.name, 30) + custom_tab( result_str , 10  ) + qualify_str);
  }
  
  
  
  void print_result_comment(int index)
  {
    
    // Add some pity if the athlete dq/dnf
    // Add congratulations when there is new records
    
    if (this.DQ)
    {
      println("Oh, come on!", this.name, "false started!");
      println();
    }
    else if (this.DNF)
    {
      println("Oh my dear!", this.name, "injured during the race!");
      println();
    }
    else
    {
      String result_str = nf( round_to(this.results[index - 1], 3), 0, 3 ) + "s.";
      
      String breakthrough = (this.break_PB[index - 1]) ? " And a new personal best! Hooray!" : "";
      
      if (this.break_WR[index - 1])
      {
        breakthrough = " Wow! This is a new world record! Sensational";
      }
      else if (this.break_PB[index - 1])
      {
        breakthrough = " And a new personal best! Hooray!";
      }
      else if (this.break_SB[index - 1])
      {
        breakthrough = " And a new season's best! Nice!";
      }
      
      // Display the honors if this is final
      
      String honor_str = (index == 3) ? "He got the Certificate!" : "";
        
      if ( this.ranks[index - 1] <= 3 && index == 3)
      {
        honor_str = "He got the " + medals[ this.ranks[index - 1] - 1 ] + "!";
        
        if (this.ranks[index - 1] == 1 && !this.defending_champ)
        {
          honor_str += " He is the new KING of 100m!";
        }
        else if (this.ranks[index - 1] == 1 && this.defending_champ)
        {
          honor_str += " Finally, he defended his throne!";
        }
        
      }
      
      println(this.name, "ran", result_str, honor_str + breakthrough);
      
    }
  }
  
  
  

  
  
  
  
  /* COMPUTATION METHODS */
  
  
  
  void get_result(int index, float weather_effect, float wind, Boolean selected)
  {
    // If the athlete is selected, there is a bit of probability that he gets false start
    
    float rand_num = random(0, 100);
    
    if ( selected && rand_num < 10 )
    {
      this.DQ = true;
      return;
    }
    
    
    // If the athelte has some injuries, then he might be DNF, and the function ends here if the athlete is dq/dnf
    
    rand_num = random(0, 100);
    
    if ( rand_num < (100.0 - this.health) * random(0.4, 0.6) )
    {
      this.DNF = true;
      return;
    }
    
    // calculate the effects that the data can bring to the athlete
    
    float mentality_effect = (100 - this.mentality) * random(0.0005, 0.002) * pow(1.15, index - 1);
    float health_effect = (100 - this.health) * random(0.002, 0.005);
    float ability = weather_effect + mentality_effect + health_effect + random(SB - 0.02, SB + 0.04); // this is what he can run if he tries his best
    
    // typically 10.15 is semifinal cutoff and 9.95 is final cutoff
    
    // some best guys would shut down to save energy until final
    
    float shut_down = 0;
    
    if (index == 1)
    {
      if (ability > 10.15)
        shut_down = 0;
      
      shut_down = random(0.05, 0.6) * (random(10.10, 10.20) - ability);
      
      if (wind > 1.5)
        shut_down *= random(1, 1.3);
    }
    else if (index == 2)
    {
      if (ability > 9.95)
        shut_down = 0;
        
      
      shut_down = random(0, 0.4) * (random(9.90, 10.05) - ability);
      
      if (wind > 1.5)
        shut_down *= random(1, 1.3);
    }
    
    
    
    float time = ability + shut_down;
    
    
    this.results[index - 1] = time;
    
    
    // Some guys are not sensible
    // They run too fast in round1/semi-final, consuming energy and adding risk of injuries
    
    
    float consume = 100 * ( (this.SB + 0.05) - time) * (index * 0.75);
    
    if (consume > 0)
      this.health -= consume;
    
    
    if ( round_to(wind, 1) <= 2 )
    {
    
    
      if ( round_to(time, 2) < WR )
      {
        WR = time;
        this.PB = time;
        this.break_WR[index - 1] = true;
        this.break_PB[index - 1] = true;
      }
      else if ( round_to(time, 2) < this.PB )
      {
        this.PB = time;
        this.SB = time;
        this.break_PB[index - 1] = true;
      }
      else if ( round_to(time, 2) < this.SB )
      {
        this.SB = time;
        this.break_SB[index - 1] = true;
      }
      
    }
    
    
  }
  

}
