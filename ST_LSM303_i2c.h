
#ifndef __ST_LSM303_I2C_H_
#define __ST_LSM303_I2C_H

extern int acc_x, acc_y, acc_z;
extern int mag_x, mag_y, mag_z;


void magPrintStatus(void);
void magReadAndConvert(void);
void accReadAndConvert(void);

bool magSelfTest(void);

void accSend(void);
void magSend(void);

bool accNewData(void);
bool magNewData(void);

#endif
