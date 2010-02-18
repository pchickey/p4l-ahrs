// Invensense ITG-3200 I2C interface
// Pat Hickey - pat@moreproductive.org
// 15 Feb 2010

#include "i2c_registers.h"
#include "ITG_3200_hw.h"
#include "ITG_3200_i2c.h"

char readbuf[8];

void gyroReadAndConvert(void)
{
  i2cReadRegisterSequential(GYRO_ADDR, GYRO_TMP_H, 8, readbuf); 
  gyro_x = int((readbuf[2] << 8) + readbuf[3]);
  gyro_y = int((readbuf[4] << 8) + readbuf[5]);
  gyro_z = int((readbuf[6] << 8) + readbuf[7]);
}

void gyroSendDebug(void)
{
  int ii;
  Serial.print("gyro: ");
  for (ii = 0; ii < 8; ii++)
  {
    Serial.print(int(readbuf[ii]));
    Serial.print(" ");
  }
  Serial.println();
}
void gyroSend(void)
{
  Serial.print("$G,X,");
  Serial.println(gyro_x);
  Serial.print("$G,Y,");
  Serial.println(gyro_y);
  Serial.print("$G,Z,");
  Serial.println(gyro_z);
}

bool gyroNewData(void)
{
  char stat = i2cReadRegister(GYRO_ADDR, GYRO_INT_STAT);
  Serial.print("gyro stat: ");
  Serial.println(int(stat));
  if (stat & GYRO_INT_STAT_DATA_RDY) return true; else return false;
  
}

