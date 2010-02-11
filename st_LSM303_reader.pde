// Accellerometer and Magnetometer Reader
// Communicates with an ST Micro LMSM303DLH using the Wire library
// Pat Hickey - pat@moreproductive.org
// 11 Febuary 2010

#include <Wire.h>

// 7 bit I2C slave addresses
// Accellerometer slave address: SA0 is grounded, so last bit is 0.
#define ACCAD (int) B0011000
// Accellerometer registers:
#define ACC_X_L ((char) B0101000)
#define ACC_X_H ((char) B0101001)
#define ACC_Y_L ((char) B0101010)
#define ACC_Y_H ((char) B0101011)
#define ACC_Z_L ((char) B0101100)
#define ACC_Z_H ((char) B0101101)

#define ACC_CTL1 ((char) B0100000) // default value is 7
#define ACC_CTL2 ((char) B0100001) // default 0
#define ACC_CTL3 ((char) B0100010) // default 0
#define ACC_CTL4 ((char) B0100011) // default 0
#define ACC_CTL5 ((char) B0100100) // default 0

// Magnetometer slave address:
#define MAGAD (int) B0011110
// Magnetometer registers:
#define MAG_X_L ((char) B0000100)
#define MAG_X_H ((char) B0000011)
#define MAG_Y_L ((char) B0000110)
#define MAG_Y_H ((char) B0000101)
#define MAG_Z_L ((char) B0001000)
#define MAG_Z_H ((char) B0000111)

byte i2cReadRegister(int i2c_device, char i2c_register)
{
  Wire.beginTransmission(i2c_device);
  Wire.send(i2c_register);
  Wire.endTransmission();
  Wire.requestFrom(i2c_device, 1);
  return Wire.receive();  
}

void setup()
{
  Serial.begin(19200); // to computer
  Wire.begin(); // master device on i2c bus
  
  
}

byte acc_x_l, acc_x_h, acc_y_l, acc_y_h, acc_z_l, acc_z_h;
byte mag_x_l, mag_x_h, mag_y_l, mag_y_h, mag_z_l, mag_z_h;

int acc_x, acc_y, acc_z;
int mag_x, mag_y, mag_z;

void loop()
{
  acc_x_l = i2cReadRegister(ACCAD, ACC_X_L);
  acc_x_h = i2cReadRegister(ACCAD, ACC_X_H);
  acc_x = int(acc_x_l) + (int(acc_x_h) << 8);
  Serial.print("acc x: ");
  Serial.println(acc_x);

  delay(500);
}
