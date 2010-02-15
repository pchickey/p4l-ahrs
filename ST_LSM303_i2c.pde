#include <Wire.h>
#include "i2c_registers.h"
#include "ST_LSM303_hw.h"
#include "ST_LSM303_i2c.h"

unsigned char acc_x_l, acc_x_h, acc_y_l, acc_y_h,acc_z_l, acc_z_h;
unsigned char mag_x_l, mag_x_h, mag_y_l, mag_y_h, mag_z_l, mag_z_h;

bool magSelfTest(void)
{
 Serial.println("Entering Magnetometer Self Test");

  magReadAndConvert(); // clear any LOCK state

  // Trigger a Positive Bias self test
  Serial.println("triggering magnetic self test, positive bias");
  i2cWriteRegister(MAG_ADDR, MAG_CRA, MAG_CRA_75HZ | MAG_CRA_POSBIAS);
  i2cWriteWithCheck(MAG_ADDR, MAG_MR, MAG_MR_SINGLE, "mag mr single");
  delay(100);
  magReadAndConvert();

  Serial.print("mag x nominal 270 test ");
  Serial.println(mag_x);
  Serial.print("mag y nominal 270 test ");
  Serial.println(mag_y);
  Serial.print("mag z nominal 255 test ");
  Serial.println(mag_z);  
  float mag_deviation = sqrt( (mag_x - 270)*(mag_x - 270) + (mag_y - 270)*(mag_y - 270) +
    (mag_z - 255)*(mag_z - 255) );

  Serial.print("positive bias self test deviation magnitude ");
  Serial.println(mag_deviation);  

  // Trigger a Negative Bias self test
  Serial.println("triggering magnetic self test, negative bias");
  i2cWriteRegister(MAG_ADDR, MAG_CRA, MAG_CRA_75HZ | MAG_CRA_NEGBIAS);
  i2cWriteWithCheck(MAG_ADDR, MAG_MR, MAG_MR_SINGLE, "mag mr single");
  delay(100);
  magReadAndConvert();

  //magPrintStatus();

  Serial.print("mag x nominal -270 test ");
  Serial.println(mag_x);
  Serial.print("mag y nominal -270 test ");
  Serial.println(mag_y);
  Serial.print("mag z nominal -255 test ");
  Serial.println(mag_z);
  mag_deviation = sqrt( (mag_x + 270)*(mag_x + 270) + (mag_y + 270)*(mag_y + 270) +
    (mag_z + 255)*(mag_z + 255) );
  Serial.print("negative bias self test deviation magnitude ");
  Serial.println(mag_deviation);  
  
  return true;
}


void magPrintStatus(void)
{
  char stat = i2cReadRegister(MAG_ADDR, MAG_SR);
  Serial.print("Mag Status Register: ");
  if (stat & MAG_SR_LOCK)
    Serial.print("LOCK and ");
  if (stat & MAG_SR_RDY)
    Serial.println("RDY");
  else
    Serial.println("NOT RDY");
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


bool accNewData(void)
{
  char stat = i2cReadRegister(ACC_ADDR, ACC_STAT);
  if (stat & ACC_STAT_XYZDA)
    return true;
  else return false;
}

bool magNewData(void)
{
  char stat = i2cReadRegister(MAG_ADDR, MAG_SR);
  if (stat & MAG_SR_RDY)
    return true;
  else return false;
}


void accSend (void)
{
  Serial.print("$A,X,");
  Serial.println(acc_x);
  Serial.print("$A,Y,");
  Serial.println(acc_y);
  Serial.print("$A,Z,");
  Serial.println(acc_z);
}

void magSend (void)
{
  Serial.print("$M,X,");
  Serial.println(mag_x);
  Serial.print("$M,Y,");
  Serial.println(mag_y);
  Serial.print("$M,Z,");
  Serial.println(mag_z);
}
