
/* COMPUTATIONS */

float round_to(float value, int dp) 
{
  // the track and field rounding is different
  // if the last digit is not 0, we ALWAYS round up
  
  
  float scale = pow(10, dp);          // Calculate 10^dp to shift the decimal
  float scaledValue = value * scale;  // Move decimal point to the right

  // Get the last digit after the desired precision
  
  float last_digit = scaledValue - floor(scaledValue);

  // Round up if the last digit is not 0
  if (last_digit > 0) 
  {
    scaledValue = ceil(scaledValue);  // Use ceiling to round up
  }

  // Shift the decimal back to the original place
  
  return scaledValue / scale;
}



/* FIXING PRINTING PROBLEMS */

String custom_tab(String str, int char_num)
{
  // this is for handling the longer strings
  
  while (str.length() <= char_num)
  {
    str += " ";
  }
  
  return str;
}



String temp_str(float temperature)
{
  // for displaying special degree celsius symbol
  
  return str(temperature) + " \u2103";
}



/* FOR CREATING NEATER FILE OUTPUTS */


void pw_table_divider()
{
  // this is generally for separating the header of each table in the file and the individual rows
  
  pw.println("-------------------------------------------------------------------------------------------------");
  
}



void pw_section_divider()
{
  // for separating each table in a series of table
  
  pw.println();
  pw.println("*************************************************************************************************");
  pw.println();
}


void pw_stage_divider()
{
  
  // for separating the round1, semis, and final
  
  pw.println();
  pw.println();
  pw.println("##################################################################################################");
  pw.println();
  pw.println();
}


// Those funcitons are same as the pw function except they are for console


void table_divider()
{
  println("-------------------------------------------------------------------------------------------------");
  
}



void section_divider()
{
  println();
  println("*************************************************************************************************");
  println();
}


void stage_divider()
{
  println();
  println();
  println("##################################################################################################");
  println();
  println();
}
