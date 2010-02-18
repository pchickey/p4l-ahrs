// Invensense ITG-3200 I2C interface
// Pat Hickey - pat@moreproductive.org
// 15 Feb 2010

#ifndef __ITG_3200_I2C_H
#define __ITG_3200_I2C_H

extern int gyro_pin;
extern int gyro_x, gyro_y, gyro_z;

void gyroReadAndConvert(void);

void gyroSend(void);
void gyroSendDebug(void);

bool gyroNewData(void);

#endif
