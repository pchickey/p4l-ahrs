// Accellerometer and Magnetometer Reader
// Communicates with an ST Micro LMSM303DLH using the Wire library
// Pat Hickey - pat@moreproductive.org
// Made for Paparazzi for Linux: 
// http://moreproductive.org/autopilot


#include <Wire.h>

void setup()
{
  Serial.begin(9600); // to computer
  Wire.begin(); // master device on i2c bus


}

void loop()
{

  
  
  
}
