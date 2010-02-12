// ST_LSM303 I2C Register Macros
// Pat Hickey 11 Feb 2010

// 7 bit I2C slave addresses
// Accellerometer slave address: SA0 is grounded, so last bit is 0.
#define ACC_ADDR (int) B0011000
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
// Bitfields for the ACC_CTL1 register.
// There are other MODEs for lower power operation.
#define ACC_CTL1_NORMALMODE ((char) B00100000)
#define ACC_CTL1_XYZENABLE  ((char) B00000111)
#define ACC_CTL1_50HZ       ((char) B00000000)
#define ACC_CTL1_100HZ      ((char) B00001000)
#define ACC_CTL1_400HZ      ((char) B00010000)
#define ACC_CTL1_1000Hz     ((char) B00011000)

// Magnetometer slave address:
#define MAG_ADDR (int) B0011110
// Magnetometer registers:
#define MAG_X_L ((char) B0000100)
#define MAG_X_H ((char) B0000011)
#define MAG_Y_L ((char) B0000110)
#define MAG_Y_H ((char) B0000101)
#define MAG_Z_L ((char) B0001000)
#define MAG_Z_H ((char) B0000111)

// CRA Configuration Register A
#define MAG_CRA ((char) B00000000)
// Output rate
#define MAG_CRA_0_75HZ ((char) B00000000)
#define MAG_CRA_1_5HZ  ((char) B00000100)
#define MAG_CRA_3HZ    ((char) B00001000)
#define MAG_CRA_7_5HZ  ((char) B00001100)
#define MAG_CRA_15HZ   ((char) B00010000)
#define MAG_CRA_30HZ   ((char) B00010100)
#define MAG_CRA 75HZ   ((char) B00011000)
// Bias Mode
#define MAG_CRA_NORMAL  ((char) B00000000)
#define MAG_CRA_POSBIAS ((char) B00000001)
#define MAG_CRA_NEGBIAS ((char) B00000010)

// MR Mode Register
#define MAG_MR ((char) B00000010)
// Only three settings here: Continous, Single Conversion, Sleep
#define MAG_MR_CONTINUOUS ((char) B00000000)
#define MAG_MR_SINGLE     ((char) B00000001)
#define MAG_MR_SLEEP      ((char) B00000011)

// SR Status Register
#define MAG_SR ((char) B00001001)
