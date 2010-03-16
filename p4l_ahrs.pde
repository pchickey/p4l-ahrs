// Magnetometer, Accellerometer, and Rate Gyro (MARG) interface firmware
// Supports ST Micro LMSM303DLH 3-axis Accellerometer and Magnetometer,
// and Invensense ITG-3200 3-axis rate gyro.

// Pat Hickey - pat@moreproductive.org
// 11 Febuary 2010

#include <Wire.h>
#include "i2c_registers.h"
#include "ST_LSM303_hw.h"
#include "ST_LSM303_i2c.h"
#include "ITG_3200_hw.h"
#include "ITG_3200_i2c.h"

int gyro_pin = 10;
int mag_pin = 11;
int acc_pin = 12; // NOT SOLDERED YET

int acc_x, acc_y, acc_z;
int mag_x, mag_y, mag_z;
int gyro_x, gyro_y, gyro_z;


void setup()
{
  // Serial busses
  Serial.begin(115200); // to computer
  Wire.begin(); // master device on i2c bus
  
  // Status pins
  pinMode(gyro_pin, INPUT);
  pinMode(mag_pin, INPUT);
  pinMode(acc_pin, INPUT);

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

  // Configure Rate Gyro
  // ------------------------------------------
  // Sample Rate Divider: 1khz / (divider + 1). 
  // 50hz means divider should be 19
  i2cWriteWithCheck(GYRO_ADDR, GYRO_SMPLRT_DIV, 19, "gyro sample rate divider 19");
  
  // Internal Low Pass filter: 
  // 1Khz sample rate, 98Hz bandwidth
  // Full Scale: +-2000deg/sec
  i2cWriteWithCheck(GYRO_ADDR, GYRO_DLPF_FS, GYRO_FS_2000 | GYRO_DLPF_98, "gyro dlpf 98 fs 2000");
  
  // Interrupt Configuration:
  // Active High (default)
  // Push-Pull (default)
  // Latch mode
  // Clear on Any register read
  // Trigger on Data Ready
  i2cWriteWithCheck(GYRO_ADDR, GYRO_INT_CFG, 
    GYRO_INT_MODE_LATCH | GYRO_INT_CLEAR_ANY | GYRO_INT_CFG_DATA_RDY,
     "gyro interrupt configuration");

  // Power Managment:
  // Get clock from X axis gyro
  i2cWriteWithCheck(GYRO_ADDR, GYRO_PWR, GYRO_PWR_CLK_GX_REF, "gyro clock configuration");
  
}
void loop()
{
  
  if(accNewData())
  {
    accReadAndConvert();
        accSend();
  }
  if(magNewData())
  {
    magReadAndConvert();  
        magSend();
  }
    
  //if(gyroNewData())
  //{
    gyroReadAndConvert();
    gyroSend();
    //gyroSendDebug();
  //}
  //Serial.println("loop done");
  //delay(500);

}



