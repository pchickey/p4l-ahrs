

char i2cReadRegister(int, char);
void i2cWriteRegister(int, char, char);
void i2cWriteWithCheck(int, char, char, char*);

void magPrintStatus(void);
void magReadAndConvert(void);
void accReadAndConvert(void);

void accSend(void);
void magSend(void);

