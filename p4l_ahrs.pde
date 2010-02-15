// Magnetometer, Accellerometer, and Rate Gyro (MARG) interface firmware
// Supports ST Micro LMSM303DLH 3-axis Accellerometer and Magnetometer,
// and Invensense ITG-3200 3-axis rate gyro.

// Pat Hickey - pat@moreproductive.org
// 11 Febuary 2010

#include <Wire.h>
#include "i2c_registers.h"
#include "ST_LSM303_hw.h"
#include "ST_LSM303_i2c.h"


int acc_x, acc_y, acc_z;
int mag_x, mag_y, mag_z;


void setup()
{
  Serial.begin(115200); // to computer
  Wire.begin(); // master device on i2c bus

  // Configure Accellerometer
  //---------------------------------

  // Configure the Accellerometer measurment rate
  i2cWriteWithCheck(ACC_ADDR, ACC_CTL1, 
  ACC_CTL1_NORMALMODE | ACC_CTL1_50HZ | ACC_CTL1_XYZENABLE, "acc_ctl1 50hz xyz-enable");

  // Set Accellerometer measurment scale to +-4G
  i2cWriteWithCheck(ACC_ADDR, ACC_CTL4, ACC_CTL4_SCALE_4G, "acc_ctl4 scale +-4g");    

  // Perform Accellerometer Self Test
  //---------------------------------------



  // Configure Magnetometer
  // ------------------------------------

  // Configure the Magnetometer measurment rate
  i2cWriteWithCheck(MAG_ADDR, MAG_CRA, MAG_CRA_75HZ, "mag cra 75HZ");

  // Configure the Magnetometer gain
  i2cWriteWithCheck(MAG_ADDR, MAG_CRB, MAG_CRB_GAIN4_0, "mag crb gain4.0");

  // Perform Magnetometer Self Test
  // ---------------------------------------
  magSelfTest();
  delay(100);
  magSelfTest();

  // Reset testing configuration
  i2cWriteWithCheck(MAG_ADDR, MAG_CRA, MAG_CRA_75HZ | MAG_CRA_NORMAL, "mag_cra 75hz");

  // Configure the Magnetometer Conversion Mode - Continuous
  i2cWriteWithCheck(MAG_ADDR, MAG_MR, MAG_MR_CONTINUOUS, "mag mr continuous");
  Serial.println("Exiting Magnetometer Self Test");


}



void loop()
{

  if(accNewData())
  {
    accReadAndConvert();
    //    accSend();
  }
  if(magNewData())
  {
    magReadAndConvert();  
    //    magSend();
  }

}



