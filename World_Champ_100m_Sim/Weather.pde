class Weather
{
  /* FIELDS */
  
  float wind;
  float temperature;
  float humidity;
  float barometer;
  
  
  // constants (they are determined through the city's geographic factors and researching)
  
  final float altitude;
  final float base_humidity;
  final float base_temperature;
  final float base_barometer;
  
  
  /* CONSTRUCTOR */
  
  Weather(float a, float temp, float hum, float baro)
  {
    this.altitude = a;
    this.base_humidity = hum;
    this.base_temperature = temp;
    this.base_barometer = baro;
    
    this.wind = 0.0;
  }
  
  
  /* METHODS */
  
  
  void generate_weather()
  {
    float random_val = random(0, 100);
    
    // 50% proability of normal wind, 30% probility of getting strong wind, and 20% probability of getting the crazy wind
    
    if (random_val < 10)
    {
      this.wind = random(-3.5, -1.8);
    }
    else if (random_val < 25)
    {
      this.wind = random(-1.8, -1);
    }
    else if (random_val < 75)
    {
      this.wind = random(-1, 1);
    }
    else if (random_val < 90)
    {
      this.wind = random(1, 1.8);
    }
    else
    {
      this.wind = random(1.8, 3.5);
    }
    
    
    
    
    // The other information will not vary that much around the base state
    
    
    this.humidity = random( this.base_humidity - 10, this.base_humidity + 10);
    
    this.temperature = random( this.base_temperature - 5, this.base_temperature + 5);
    
    this.barometer = random( this.base_barometer - 0.1, this.base_barometer + 0.1);
    
    
    
  }
  
  
  
  float get_effect()
  {
    this.generate_weather();
    
    // More info can be found in my google doc of the research (big thanks to Mr. Jonas Mureika)
    // This function adds up all the effects from all the factors, to be passed to the athletes objects and be used
    
    float wind_effect = 0;
    
    if (this.wind > 0)
    {
      if (this.wind > 1)
      {
        wind_effect = -this.wind * 0.05 * pow(0.95, this.wind);
      }
      else
      {
        wind_effect = -this.wind * 0.05;
      }
    }
    else
    {
      wind_effect = -this.wind * 0.06;
    }
    
    float alti_effect = -this.altitude * (3.2/100000.0);
    float temp_effect = (26 - this.temperature) * 0.001;
    float humi_effect = (50 - this.humidity) * 0.001/20.0;
    float baro_effect = (this.barometer - 101.325) * 0.001/0.3;
    
    return wind_effect + alti_effect + temp_effect + humi_effect + baro_effect;
  
  }

}
