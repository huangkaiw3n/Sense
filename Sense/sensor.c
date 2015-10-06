uint8_t buf[20], acc[6], gyro[6], mag[6];
    
    uint16_t combinedAcc[3];
    uint16_t tempGyro[3], tempMag[3];
    
    float accelerometer[3];
    float gyroscope[3];
    float magnetometer[3];
    
     [[sensorData subdataWithRange:NSMakeRange(0, 20)] getBytes:buf length:20];
    
     //compute gyro
     gyro[0] = buf[15];
     gyro[1] = buf[14];
     memcpy(&tempGyro[0], gyro, 2);
     
     gyro[2] = buf[17];
     gyro[3] = buf[16];
     memcpy(&tempGyro[1], gyro+2, 2);
     
     gyro[4] = buf[19];
     gyro[5] = buf[18];
     memcpy(&tempGyro[2], gyro+4, 2);
     
     
     //compute acc
     acc[0] = ((buf[2] & 0xf0) >> 4) | ((buf[3] & 0x0f) << 4);
     acc[1] = ((buf[3] & 0xf0) >> 4);
    
     if ((acc[1] & 0x08) != 0x00) {
         acc[1] |= 0xf0;
     }
     memcpy(&combinedAcc[0], acc, 2);
     
     acc[2] = ((buf[4] & 0xf0) >> 4) | ((buf[5] & 0x0f) << 4);
     acc[3] = ((buf[5] & 0xf0) >> 4);
    
     if ((acc[3] & 0x08) != 0x00) {
         acc[3] |= 0xf0;
     }
     memcpy(&combinedAcc[1], acc+2, 2);
     
     acc[4] = ((buf[6] & 0xf0) >> 4) | ((buf[7] & 0x0f) << 4);
     acc[5] = ((buf[7] & 0xf0) >> 4);
    
     if ((acc[5] & 0x08) != 0x00) {
         acc[5] |= 0xf0;
     }
     memcpy(&combinedAcc[2], acc+4, 2);
     
     
     //compute mag     
     mag[0] = buf[9];
     mag[1] = buf[8] & 0x0f;
     if ((mag[1] & 0x08) != 0x00) {
         mag[1] |= 0xf0;
     }
     memcpy(&tempMag[0], mag, 2);
     
     mag[2] = buf[11];
     mag[3] = buf[10] & 0x0f;
     if ((mag[3] & 0x08) != 0x00) {
         mag[3] |= 0xf0;
     }
     memcpy(&tempMag[1], mag+2, 2);
     
     mag[4] = buf[13];
     mag[5] = buf[12] & 0x0f;
     if ((mag[5] & 0x08) != 0x00) {
         mag[5] |= 0xf0;
     }
     memcpy(&tempMag[2], mag+4, 2);
     
     for (int rawCounter = 0; rawCounter < 3; rawCounter++) {
        accelerometer[rawCounter] = [[NSNumber numberWithShort:combinedAcc[rawCounter]] floatValue];
        gyroscope[rawCounter] = [[NSNumber numberWithShort:tempGyro[rawCounter]] floatValue];
        magnetometer[rawCounter] = [[NSNumber numberWithShort:tempMag[rawCounter]] floatValue];
    }
    
    MadgwickAHRSupdate (gyroscope[1]*DEG_TO_RAD/14.375,
                        gyroscope[0]*DEG_TO_RAD/-14.375,
                        gyroscope[2]*DEG_TO_RAD/14.375,
                        accelerometer[0],
                        accelerometer[1],
                        accelerometer[2],
                        magnetometer[0],
                        magnetometer[1],
                        magnetometer[2]);