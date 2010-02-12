// Accellerometer and Magnetometer Reader
// Communicates with an ST Micro LMSM303DLH using the Wire library
// Pat Hickey - pat@moreproductive.org
// 11 Febuary 2010

#include <Wire.h>
#include "ST_LSM303.h"

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
void setup()
{
  Serial.begin(19200); // to computer
  Wire.begin(); // master device on i2c bus
  
  // Configure the ACC measurment rate
  i2cWriteRegister(ACC_ADDR, ACC_CTL1, 
    ACC_CTL1_NORMALMODE | ACC_CTL1_50HZ | ACC_CTL1_XYZENABLE);
  char acc_ctl1 = i2cReadRegister(ACC_ADDR, ACC_CTL1);
  if (acc_ctl1 != (ACC_CTL1_NORMALMODE | ACC_CTL1_50HZ | ACC_CTL1_XYZENABLE))
    Serial.println("acc_ctl1 config appears unsuccessful.");
  Serial.print("read acc_ctl1  "); 
  Serial.println(int(acc_ctl1)); 
  
  
  
}

unsigned char acc_x_l, acc_x_h, acc_y_l, acc_y_h, acc_z_l, acc_z_h;
unsigned char mag_x_l, mag_x_h, mag_y_l, mag_y_h, mag_z_l, mag_z_h;

int acc_x, acc_y, acc_z;
int mag_x, mag_y, mag_z;

void loop()
{
  acc_x_l = i2cReadRegister(ACC_ADDR, ACC_X_L);
  acc_x_h = i2cReadRegister(ACC_ADDR, ACC_X_H);
  acc_x = int((acc_x_h << 8) + acc_x_l) >> 4;
  Serial.print("acc x: ");
  Serial.println(acc_x);




  delay(500);
}
