/*

 Author: Ricky Tang
 Date: October 10th, 2024
 Purpose: This program takes in the top 56 athletes as of October 15th 2024. It simulates a brilliant matchup
 between them by computing the weather, health, and other effects.
 You can either choose the commenting in console or animation in graphics. But no matter what you will have a full
 "Professional results booklet" in .txt exported
 
 */


/*

 IMPORTANT DECLAIMER
 When you see 2 athletes have the "same" numeric value, their times are NOT different, they are simply rounded and displayed.
 For example, 9.999 and 9.999 can actually be 9.9981 and 9.9983, and etc.
 
 */


// IMPORTING PACKAGES (for sorting and shuffling)

import java.util.*;


// GLOBAL VARIABLES (and constants)


final String[] medals = {"Gold", "Silver", "Bronze"};

PrintWriter pw;

float WR = 9.58; // world record (might alter although the probability is about 0 for this data sample)

color track_col; 

String mode = "animation"; // TRY CHANGE THIS -> either "commentator" or "animation".
// If you change it to something else, you will still get a .txt file output

// The global objects

Competition tokyo25;
Commentator ricky;
Animator tang;
Host h;

// The medal images

PImage gold;
PImage silver;
PImage bronze;


void setup()
{
  
  // prepare for outputing
  
  pw = createWriter("Full Results.txt");

  
  // Initialize the objects
  
  tokyo25 = new Competition("2025 World Athletics Championships Men's 100m", "Tokyo National Stadium", 23.0, 23.0, 73, 101.1);

  ricky = new Commentator(tokyo25);

  h = new Host(tokyo25, ricky);
  
  
  // Call the host to do the whole work

  h.whole_process( mode.equals("commentator") );


  pw.close();

  if (!mode.equals("animation"))
  {
    exit();
  }
  
  
  // The following process will activiate only if you choose animation mode

  size(1100, 550);
  textFont(createFont("Arial Bold", 40));
  frameRate(50);
  colorMode(HSB, 360, 100, 100); // Use HSB mode to enable we can use hue value scale like electromagnetic spectrum
  track_col = color(19, 95, 86);


  gold = loadImage("gold.png");
  silver = loadImage("silver.png");
  bronze = loadImage("bronze.png");

  // Initialize the animator
  
  tang = new Animator(tokyo25);
}



void draw()
{
  background(0, 0, 10); // color for dark mode interface

  tang.animate();
}
