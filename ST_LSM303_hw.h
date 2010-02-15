// ST Micro LSM303 I2C Register Macros
// Pat Hickey - pat@moreproductive.org
// 11 Feb 2010

#ifndef __ST_LSM303_HW_H_
#define __ST_LSM303_HW_H

// 7 bit I2C slave addresses
// Accellerometer slave address: SA0 is grounded, so last bit is 0.
#define ACC_ADDR ((int) B0011000)
// Accellerometer registers:
#define ACC_X_L ((char) B0101000)
#define ACC_X_H ((char) B0101001)
#define ACC_Y_L ((char) B0101010)
#define ACC_Y_H ((char) B0101011)
#define ACC_Z_L ((char) B0101100)
#define ACC_Z_H ((char) B0101101)

#define ACC_CTL1 ((char) B00100000) // default value is 7

// Bitfields for the ACC_CTL1 register.
// There are other MODEs for lower power operation.
#define ACC_CTL1_NORMALMODE ((char) B00100000)
#define ACC_CTL1_XYZENABLE  ((char) B00000111)
#define ACC_CTL1_50HZ       ((char) B00000000)
#define ACC_CTL1_100HZ      ((char) B00001000)
#define ACC_CTL1_400HZ      ((char) B00010000)
#define ACC_CTL1_1000Hz     ((char) B00011000)

#define ACC_CTL2 ((char) B00100001) // default 0
// Not interested in high-pass filter configuration

#define ACC_CTL3 ((char) B00100010) // default 0
// Not interested in interrupt control 

#define ACC_CTL4 ((char) B00100011) // default 0
#define ACC_CTL4_CONT_UPDATE ((char) B00000000)
// output registers not updated between MSB and LSB reading
#define ACC_CTL4_BLCK_UPDATE ((char) B10000000)
// Keep this default (LSB_LOWER)
#define ACC_CTL4_LSB_LOWER   ((char) B00000000)
#define ACC_CTL4_MSB_LOWER   ((char) B01000000)
// Full Scale Selection
#define ACC_CTL4_SCALE_2G    ((char) B00000000)
#define ACC_CTL4_SCALE_4G    ((char) B00010000)
#define ACC_CTL4_SCALE_8G    ((char) B00110000)
// Self test sign:
#define ACC_CTL4_SELFTEST_POS ((char) B00000000)
#define ACC_CTL4_SELFTEST_NEG ((char) B00001000)
// Self test enable:
#define ACC_CTL4_SELFTEST_ENABLE ((char) B00000010)

#define ACC_CTL5 ((char) B00100100) // default 0
// not interested in sleep-to-wake functionality

#define ACC_STAT ((char) B00100111)
// Overruns- new data overwritten before read
#define ACC_STAT_XYZOR ((char) B10000000)
#define ACC_STAT_XOR   ((char) B00010000)
#define ACC_STAT_YOR   ((char) B00100000)
#define ACC_STAT_ZOR   ((char) B01000000)
// Data available- new data since previous read
#define ACC_STAT_XYZDA ((char) B00001000)
#define ACC_STAT_XDA   ((char) B00000001)
#define ACC_STAT_YDA   ((char) B00000010)
#define ACC_STAT_ZDA   ((char) B00000100) 

// Magnetometer slave address:
#define MAG_ADDR ((int) B0011110)

// CRA Configuration Register A
#define MAG_CRA ((char) B00000000)
// Output rate
#define MAG_CRA_0_75HZ ((char) B00000000)
#define MAG_CRA_1_5HZ  ((char) B00000100)
#define MAG_CRA_3HZ    ((char) B00001000)
#define MAG_CRA_7_5HZ  ((char) B00001100)
#define MAG_CRA_15HZ   ((char) B00010000)
#define MAG_CRA_30HZ   ((char) B00010100)
#define MAG_CRA_75HZ   ((char) B00011000)
// Bias Mode
#define MAG_CRA_NORMAL  ((char) B00000000)
#define MAG_CRA_POSBIAS ((char) B00000001)
#define MAG_CRA_NEGBIAS ((char) B00000010)

// CRB Configuration Register B. 
#define MAG_CRB ((char) B00000001)
// Sensor input field range in +- gauss:
// Table of LSB/Gauss in datasheet on p40.
#define MAG_CRB_GAIN1_3 ((char) B00100000)
#define MAG_CRB_GAIN1_9 ((char) B01000000)
#define MAG_CRB_GAIN2_5 ((char) B01100000)
#define MAG_CRB_GAIN4_0 ((char) B10000000)
#define MAG_CRB_GAIN4_7 ((char) B10100000)
#define MAG_CRB_GAIN5_6 ((char) B11000000)
#define MAG_CRB_GAIN8_1 ((char) B11100000)

// MR Mode Register
#define MAG_MR ((char) B00000010)
// Only three settings here: Continous, Single Conversion, Sleep
#define MAG_MR_CONTINUOUS ((char) B00000000)
#define MAG_MR_SINGLE     ((char) B00000001)
#define MAG_MR_SLEEP      ((char) B00000011)

// Magnetometer Output registers:
#define MAG_X_L ((char) B0000100)
#define MAG_X_H ((char) B0000011)
#define MAG_Y_L ((char) B0000110)
#define MAG_Y_H ((char) B0000101)
#define MAG_Z_L ((char) B0001000)
#define MAG_Z_H ((char) B0000111)

// SR Status Register
#define MAG_SR ((char) B00001001)
// 3 status bits:
// Regulator Enable Bit. Set means internal voltage reg is enabled.
#define MAG_SR_REN  ((char) B0000100)
// Data Output Register Lock. set when some, not all, of six data output registers have been read.
// New data not placed into registers until either of 1. all six read 2. mode changed, 
// 3. POR issued, 4. measurement changed
#define MAG_SR_LOCK ((char) B0000010)
// Ready Bit. Set when data is written into all six registers, 
// cleared when device initiates a write to the output registers (takes 5us).
#define MAG_SR_RDY  ((char) B0000001)


#endif
