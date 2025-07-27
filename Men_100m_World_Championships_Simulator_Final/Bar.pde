class Bar
{
  // FIELDS
  
  color col;
  float time; // how much time it needs to get to the finish
  final float max_len; // the length at which it stops
  final float x_start;
  final float y_start;
  final float self_width;
  float len; // current length
  Boolean finish; // check if it finishes the race
  
  
  // CONSTRUCTOR
  
  Bar(float ml, float x, float y, float w)
  {
    this.max_len = ml;
    this.len = 0.0;
    this.time = 12.0; // 12 seconds by default, although it is too slow for pros
    this.x_start = x;
    this.y_start = y;
    this.self_width = w;
    this.col = color(255);
    this.finish = false;
  }
  
  
  
  // METHODS
  
  void set_time(float t, Boolean no_mark)
  {
    this.time = t;
    this.set_col();
    
    if (no_mark)
      // if the athlete is dq/dnf, there is no point of letting the bar run
      this.finish = true;
  }
  
  
  void set_col() 
  {
    float t = constrain(this.time, 9.50, 10.50); // make sure no extreme number effects the bar color
    
    
    float hue_val = map(t, 9.50, 10.50, 270, 120); // map the time onto the green-violet color scale to get correct according color
    
    float opacity = 100;
    
    float alpha = opacity/100 * 255; // controls the opacity
    
    this.col = color(hue_val, 100, 100, alpha);
  }
  
  
  void reset()
  {
    this.len = 0.0;
    this.time = 12.0;
    this.col = color(255);
    this.finish = false;
  }
  
  
  void move()
  {
    
    if (!this.finish)
      this.len += this.max_len/(this.time * frameRate); // the thing on the right is the speed (length/number of frames in total)
    
    if (this.len >= this.max_len)
    {
      this.finish = true;
    }
  }
  
  
  void draw_self()
  {
    noStroke();
    fill(this.col);
    rect(this.x_start, this.y_start, this.len, this.self_width);
  }

}
