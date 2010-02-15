
#ifndef __I2C_REGISTERS_H_
#define __I2C_REGISTERS_H_

char i2cReadRegister(int, char);
void i2cWriteRegister(int, char, char);
void i2cWriteWithCheck(int, char, char, char*);

#endif
