
#include <Wire.h>
#include <Serial.h>

char i2cReadRegister(int i2c_device, char i2c_register)
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

void i2cWriteWithCheck(int i2c_device, char i2c_register, char value, char* name)
{
  i2cWriteRegister(i2c_device, i2c_register, value);
  char check = i2cReadRegister(i2c_device, i2c_register);
  if (check != value)
  {
    Serial.print(name);
    Serial.println(" config appears unsuccessful.");
    Serial.print("expected ");
    Serial.print(int(value));
    Serial.print(" read ");
    Serial.println(int(check));
  }
}

