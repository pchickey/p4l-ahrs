// Invensense ITG-3200 I2C Register Macros
// Pat Hickey - pat@moreproductive.org
// 15 Feb 2010

#ifndef __ITG_3200_HW_H
#define __ITG_3200_HW_H

// 7 bit I2C slave address
// pin AD0 is pulled high, so last bit is 1
#define GYRO_ADDR ((int) B1101001)

#define GYRO_WHOAMI ((char) 0x00)
// Whoami: lower 7 bits are the gyro's i2c address.

#define GYRO_SMPLRT_DIV ((char) 0x15)
// Sample Rate Divider:
// Sample frequency is set by DLPF_CFG (reg 0x16, bits 2:0)
// The internal low-pass output is delivered to the registers
// at the number of sample cycles determined by this register.
// All 8 bits may be used, Fsample = Finternal / (divider + 1)
#define GYRO_DLPF_FS    ((char) 0x16)
// FS_SEL: bits 4:3; Only one setting, +-2000 deg/sec, is valid
#define GYRO_FS_2000    ((char) B00011000)
// DLPF: bits 2:0; specified by low pass filter bandwith, in Hz
#define GYRO_DLPF_256    ((char) B00000000) // 8kHz sample
#define GYRO_DLPF_188    ((char) B00000001) // 1kHz sample
#define GYRO_DLPF_98     ((char) B00000010) // 1kHz sample
#define GYRO_DLPF_42     ((char) B00000011) // 1kHz sample
#define GYRO_DLPF_20     ((char) B00000100) // 1kHz sample
#define GYRO_DLPF_10     ((char) B00000101) // 1kHz sample
#define GYRO_DLPF_5      ((char) B00000110) // 1kHz sample
#define GYRO_DLPF_2100   ((char) B00000111) // 8kHz sample

#define GYRO_INT_CFG    ((char) 0x17)
// Interrupt Configuration: interrupt behavior and source
#define GYRO_INT_ACTIVE_H     ((char) B00000000)
#define GYRO_INT_ACTIVE_L     ((char) B10000000)
#define GYRO_INT_PUSH_PULL    ((char) B00000000)
#define GYRO_INT_OPEN_DRAIN   ((char) B01000000)
#define GYRO_INT_MODE_LATCH   ((char) B00100000)
#define GYRO_INT_MODE_PULSE   ((char) B00000000)
#define GYRO_INT_CLEAR_STAT   ((char) B00000000)
#define GYRO_INT_CLEAR_ANY    ((char) B00010000)
#define GYRO_INT_CFG_CLK_RDY  ((char) B00000100)
#define GYRO_INT_CFG_DATA_RDY ((char) B00000001)


#define GYRO_INT_STAT  ((char) 0x1A)
// Interrupt status: find out which event caused interrupt
#define GYRO_INT_STAT_CLK_RDY  ((char) B00000100)
#define GYRO_INT_STAT_DATA_RDY ((char) B00000001)

// 8 measurment output registers
#define GYRO_TMP_H      ((char) 0x1B)
#define GYRO_TMP_L      ((char) 0x1C)
#define GYRO_X_H        ((char) 0x1D)
#define GYRO_X_L        ((char) 0x1E)
#define GYRO_Y_H        ((char) 0x1F)
#define GYRO_Y_L        ((char) 0x20)
#define GYRO_Z_H        ((char) 0x21)
#define GYRO_Z_L        ((char) 0x22)

#define GYRO_PWR	((char) 0x3E)
// Power managment: Force power events
#define GYRO_PWR_RESET  ((char) B10000000)
#define GYRO_PWR_SLEEP  ((char) B01000000)
#define GYRO_PWR_STBY_X ((char) B00100000)
#define GYRO_PWR_STBY_Y ((char) B00010000)
#define GYRO_PWR_STBY_Z ((char) B00001000)
// Clock Source: Gyro references are reccommended, more stable
#define GYRO_PWR_CLK_INTERNAL ((char) B00000000)
#define GYRO_PWR_CLK_GX_REF   ((char) B00000001)
#define GYRO_PWR_CLK_GY_REF   ((char) B00000010)
#define GYRO_PWR_CLK_GZ_REF   ((char) B00000011)
#define GYRO_PWR_CLK_EX_32K   ((char) B00000100)
#define GYRO_PWR_CLK_EX_19M   ((char) B00000101)

#endif
