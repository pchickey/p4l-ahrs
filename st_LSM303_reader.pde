// Accellerometer and Magnetometer Reader
// Communicates with an ST Micro LMSM303DLH using the Wire library
// Pat Hickey - pat@moreproductive.org
// 11 Febuary 2010

#include <Wire.h>
#include "ST_LSM303.h"

unsigned char acc_x_l, acc_x_h, acc_y_l, acc_y_h,acc_z_l, acc_z_h;
unsigned char mag_x_l, mag_x_h, mag_y_l, mag_y_h, mag_z_l, mag_z_h;

int acc_x, acc_y, acc_z;
int mag_x, mag_y, mag_z;

byte i2cReadRegister(int i2c_device, char i2c_register)
{
  Wire.beginTransmission(i2c_device);
  Wire.send(i2c_register);
  Wire.endTransmission();
  Wire.requestFrom(i2c_device, 1);
  return Wire.receive();  
}

void i2cWriteRegister(int i2c_device, char i2c_register, char value)
{
  Wire.beginTransmission(i2c_device);
  Wire.send(i2c_register);
  Wire.send(value);
  Wire.endTransmission();
}  

void magReadAndConvert(void)
{ 
  mag_x_l = i2cReadRegister(MAG_ADDR, MAG_X_L);
  mag_x_h = i2cReadRegister(MAG_ADDR, MAG_X_H);
  mag_y_l = i2cReadRegister(MAG_ADDR, MAG_Y_L);
  mag_y_h = i2cReadRegister(MAG_ADDR, MAG_Y_H);
  mag_z_l = i2cReadRegister(MAG_ADDR, MAG_Z_L);
  mag_z_h = i2cReadRegister(MAG_ADDR, MAG_Z_H);

  mag_x = int((mag_x_h << 8) + mag_x_l);
  mag_y = int((mag_y_h << 8) + mag_y_l);
  mag_z = int((mag_z_h << 8) + mag_z_l);
}

void accReadAndConvert(void)
{
  acc_x_l = i2cReadRegister(ACC_ADDR, ACC_X_L);
  acc_x_h = i2cReadRegister(ACC_ADDR, ACC_X_H);

  acc_y_l = i2cReadRegister(ACC_ADDR, ACC_Y_L);
  acc_y_h = i2cReadRegister(ACC_ADDR, ACC_Y_H);

  acc_z_l = i2cReadRegister(ACC_ADDR, ACC_Z_L);
  acc_z_h = i2cReadRegister(ACC_ADDR, ACC_Z_H);

  acc_x = int((acc_x_h << 8) + acc_x_l) >> 4;
  acc_y = int((acc_y_h << 8) + acc_y_l) >> 4;
  acc_z = int((acc_z_h << 8) + acc_z_l) >> 4;
}
void setup()
{
  Serial.begin(19200); // to computer
  Wire.begin(); // master device on i2c bus

  // Configure the Accellerometer measurment rate
  i2cWriteRegister(ACC_ADDR, ACC_CTL1, 
  ACC_CTL1_NORMALMODE | ACC_CTL1_50HZ | ACC_CTL1_XYZENABLE);
  char acc_ctl1 = i2cReadRegister(ACC_ADDR, ACC_CTL1);
  if (acc_ctl1 != (ACC_CTL1_NORMALMODE | ACC_CTL1_50HZ | ACC_CTL1_XYZENABLE))
    Serial.println("acc_ctl1 config appears unsuccessful.");
  Serial.print("read acc_ctl1  "); 
  Serial.println(int(acc_ctl1)); 

  // Configure the Magnetometer measurment rate
  i2cWriteRegister(MAG_ADDR, MAG_CRA, MAG_CRA_75HZ);
  char mag_cra = i2cReadRegister(MAG_ADDR, MAG_CRA);
  if (mag_cra != MAG_CRA_75HZ)
    Serial.println("mag_cra config appears unsuccessful");
  Serial.print("read mag_cra ");
  Serial.println(int(mag_cra));

  // Configure the Magnetometer gain
  i2cWriteRegister(MAG_ADDR, MAG_CRB, MAG_CRB_GAIN4_0);
  char mag_crb = i2cReadRegister(MAG_ADDR, MAG_CRB);
  if (mag_crb != MAG_CRB_GAIN4_0)
  {
    Serial.println("mag_crb config appears unsuccessful");
    Serial.print("expected "); 
    Serial.print(int(MAG_CRB_GAIN4_0));
    Serial.print(" read ");
    Serial.println(int(mag_crb));
  }
  // Do a Magnetometer Self Test
  // ---------------------------
  Serial.println("Entering Magnetometer Self Test");
  
  // Single Conversion
  Serial.println("Setting Magnetometer to Single Conversion"); 
  i2cWriteRegister(MAG_ADDR, MAG_MR, MAG_MR_SINGLE);
  char mag_mr = i2cReadRegister(MAG_ADDR, MAG_MR);
  if (mag_mr != MAG_MR_SINGLE)
  {  
    Serial.println("mag_mr config appears unsuccessful");
    Serial.print("   read mag_mr= ");
    Serial.print(int(mag_mr));
    Serial.print(", expected mag_mr= ");
    Serial.println(int(MAG_MR_SINGLE));
  }
  
  // Read Status Register
  char mag_sr = i2cReadRegister(MAG_ADDR, MAG_SR);
  Serial.print("read mag_sr: expect RDY 1 read ");
  Serial.println(int(mag_sr));

  if (mag_sr & MAG_SR_LOCK)
  {
    Serial.println("clearing magnetic conversion to eliminate lock");
    magReadAndConvert();
    mag_sr = i2cReadRegister(MAG_ADDR, MAG_SR);
    Serial.print("read mag_sr: expect RDY 1 read ");
    Serial.println(int(mag_sr));
  }

  // Trigger a Positive Bias self test
  Serial.println("triggering magnetic self test, positive bias");
  i2cWriteRegister(MAG_ADDR, MAG_CRA, MAG_CRA_75HZ | MAG_CRA_POSBIAS);
  delay(100);

  magReadAndConvert();

  Serial.print("mag x nominal 270 test ");
  Serial.print(mag_x);
  Serial.print(": ");
  Serial.print(int(mag_x_h));
  Serial.print(", ");
  Serial.println(int(mag_x_l));

  Serial.print("mag y nominal 270 test ");
  Serial.print(mag_y);
  Serial.print(": ");
  Serial.print(int(mag_y_h));
  Serial.print(", ");
  Serial.println(int(mag_y_l));

  Serial.print("mag z nominal 255 test ");
  Serial.print(mag_z);  
  Serial.print(": ");
  Serial.print(int(mag_z_h));
  Serial.print(", ");
  Serial.println(int(mag_z_l));
  
  mag_sr = i2cReadRegister(MAG_ADDR, MAG_SR);
  Serial.print("read mag_sr: expect RDY 1 read ");
  Serial.println(int(mag_sr));

  // Trigger a Negative Bias self test
  Serial.println("triggering magnetic self test, negative bias");
  i2cWriteRegister(MAG_ADDR, MAG_CRA, MAG_CRA_75HZ | MAG_CRA_NEGBIAS);
  delay(100);

  mag_sr = i2cReadRegister(MAG_ADDR, MAG_SR);
  Serial.print("read mag_sr: expect 0 read ");
  Serial.println(int(mag_sr));
  
  magReadAndConvert();

  Serial.print("mag x nominal -270 test ");
  Serial.print(mag_x);
  Serial.print(": ");
  Serial.print(int(mag_x_h));
  Serial.print(", ");
  Serial.println(int(mag_x_l));

  Serial.print("mag y nominal -270 test ");
  Serial.print(mag_y);
  Serial.print(": ");
  Serial.print(int(mag_y_h));
  Serial.print(", ");
  Serial.println(int(mag_y_l));

  Serial.print("mag z nominal -255 test ");
  Serial.print(mag_z);
  Serial.print(": ");
  Serial.print(int(mag_z_h));
  Serial.print(", ");
  Serial.println(int(mag_z_l));

  mag_sr = i2cReadRegister(MAG_ADDR, MAG_SR);
  Serial.print("read mag_sr: expect RDY 1 read ");
  Serial.println(int(mag_sr));
  
  Serial.println("Exiting Magnetometer Self Test");

  // Reset testing configuration
  i2cWriteRegister(MAG_ADDR, MAG_CRA, MAG_CRA_75HZ | MAG_CRA_NORMAL);
  mag_cra = i2cReadRegister(MAG_ADDR,MAG_CRA);
  if (mag_cra != MAG_CRA_75HZ)
    Serial.println("mag cra reconfig appears unsuccessful");
  // Serial.print("read mag_cra ");
  // Serial.println(int(mag_cra));

  // Configure the Magnetometer Conversion Mode - Continuous
  i2cWriteRegister(MAG_ADDR, MAG_MR, MAG_MR_CONTINUOUS);
  mag_mr = i2cReadRegister(MAG_ADDR, MAG_MR);
  if (mag_mr != MAG_MR_CONTINUOUS)
    Serial.println("mag_mr config appears unsuccessful");
  // Serial.print("read mag_mr ");
  // Serial.println(int(mag_mr));
}



void loop()
{
  accReadAndConvert();
  // Serial.print("acc x: ");
  // Serial.println(acc_x);

  magReadAndConvert();  

  // Serial.print("mag x: ");
  // Serial.println(mag_x);

  delay(500);
}

