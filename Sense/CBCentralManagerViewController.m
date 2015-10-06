//
//  CBCentralManagerViewController.m
//  Sense
//
//  Created by Kaiwen Huang on 28/8/15.
//  Copyright (c) 2015 Kaiwen Huang. All rights reserved.
//

#import "CBCentralManagerViewController.h"
#include <math.h>

@implementation CBCentralManagerViewController

- (IBAction)disconnectButton:(UIButton *)sender {
        if (_centralManager){
            NSLog(@"STOPSCAN!");
            [_centralManager stopScan];
        }
        if (_discoveredPeripheral){
            NSLog(@"CLEANUP!");
            [self cleanup];
        }
        [_attitudeText setText:nil];
        [_bankText setText:nil];
        [_headingText setText:nil];
        [_gxText setText:nil];
        [_gyText setText:nil];
        [_gzText setText:nil];
        [_mxText setText:nil];
        [_myText setText:nil];
        [_mzText setText:nil];
        [_axText setText:nil];
        [_ayText setText:nil];
        [_azText setText:nil];
    
}

- (IBAction)connectButton:(UIButton *)sender {
        
    [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
        NSLog(@"Scanning started");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_centralManager)
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    if (!_data)
        _data = [[NSData alloc] init];
    
    self.cube = [[OpenGLView alloc] initWithFrame:self.cubeView.bounds];
    [self.cubeView addSubview:self.cube];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        // Scan for devices
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    if (_discoveredPeripheral != peripheral) {
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        _discoveredPeripheral = peripheral;
        
        // And connect
        NSLog(@"Connecting to peripheral %@", peripheral);
        [_centralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Failed to connect");
    [self cleanup];
}

- (void)cleanup {
    
    // See if we are subscribed to a characteristic on the peripheral
    if (_discoveredPeripheral.services != nil) {
        for (CBService *service in _discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            [_discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                        }
                    }
                }
            }
        }
    }
    
    [_centralManager cancelPeripheralConnection:_discoveredPeripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Connected");
    
    [_centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
    }
    // Discover other characteristics
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error");
        return;
    }
    _data = characteristic.value;
    
    NSData *gyroData = [_data subdataWithRange:NSMakeRange(14, 6)];
    NSData *magData = [_data subdataWithRange:NSMakeRange(8, 6)];
    NSData *accData = [_data subdataWithRange:NSMakeRange(2, 6)];
    float changeHead, changeAtt, changeBank;
    
    const int8_t* gyroBytes = (const int8_t*) [gyroData bytes];
    const int8_t* magBytes = (const int8_t*) [magData bytes];
    const int8_t* accBytes = (const int8_t*) [accData bytes];
    
    int32_t gx = (gyroBytes[0] << 8) + (0x0FF & gyroBytes[1]);
    gx = gx << 16;
    gx = gx >> 16;
    gx = gx * -1;
    
    int32_t gy = (gyroBytes[2] << 8) + (0x0FF & gyroBytes[3]);
    gy = gy << 16;
    gy = gy >> 16;
    gy = gy * -1;
    
    int32_t gz = (gyroBytes[4] << 8) + (0x0FF & gyroBytes[5]);
    gz = gz << 16;
    gz = gz >> 16;
    
    int32_t mx = (magBytes[0] << 8) + (0x0FF & magBytes[1]);
    mx = mx << 20;
    mx = mx >> 20;
    
    int32_t my = (magBytes[2] << 8) + (0x0FF & magBytes[3]);
    my = my << 20;
    my = my >> 20;
    
    int32_t mz = (magBytes[4] << 8) + (0x0FF & magBytes[5]);
    mz = mz << 20;
    mz = mz >> 20;
    
    int32_t ax = (accBytes[1] << 8) + (0xFF & accBytes[0]);
    ax = ax << 16;
    ax = ax >> 20;

    int32_t ay = (accBytes[3] << 8) + (0xFF & accBytes[2]);
    ay = ay << 16;
    ay = ay >> 20;
    
    int32_t az = (accBytes[5] << 8) + (0xFF & accBytes[4]);
    az = az << 16;
    az = az >> 20;
    az = 0;
    
    
//    NSLog(@"Gyro x:%d, y:%d, z:%d", gx, gy, gz);
//    NSLog(@"Mag x:%d, y:%d, z:%d", mx, my, mz);
//    NSLog(@"Acc x:%d, y:%d, z:%d", ax, ay, az);
    // Have we got everything we need?
    //[_centralManager cancelPeripheralConnection:peripheral];
    MadgwickAHRSupdate(GLKMathDegreesToRadians(gy), GLKMathDegreesToRadians(gx), GLKMathDegreesToRadians(gz), ax, ay, az, mx, my, mz);
    heading = asin(2 * (q0 * q2 - q3 * q1)); //y
    attitude = atan2(2 * (q0 * q1 + q2 * q3), 1 - 2 * (q1 * q1 + q2 * q2));  //x
    bank = atan2(2 * (q0 * q3 + q1 * q2), 1 - 2 * (q2 * q2 + q3 * q3));  //z
    heading = GLKMathRadiansToDegrees(heading);
    attitude = GLKMathRadiansToDegrees(attitude);
    bank = GLKMathRadiansToDegrees(bank);
    
    changeAtt = attitude - self.cube.currentRoll;
    changeHead = heading - self.cube.currentPitch;
    changeBank = bank - self.cube.currentYaw;
    
    NSLog(@"ChangeAtt:%f, ChangeHead:%f, ChangeBank:%f", changeAtt, changeHead, changeBank);
    
//    if (changeAtt > 0.04 || changeAtt < 0.04)
//        self.cube.currentRoll = attitude;
//    if (changeHead > 0.055 || changeHead < 0.055) {
//        self.cube.currentPitch = heading;
//    }
//    if (changeBank > 0.05 || changeBank < 0.05) {
//        self.cube.currentYaw = bank;
//    }
    self.cube.currentRoll = attitude;
    self.cube.currentPitch = heading;
    self.cube.currentYaw = bank;
    NSLog(@"AccX:%d, AccY:%d, AccZ:%d", ax, ay, az);
    NSLog(@"Quaternion q0:%f, q1:%f, q2:%f, q3:%f", q0, q1, q2, q3);
    NSLog(@"Heading:%lf , Attitude:%lf, Bank:%lf", heading, attitude, bank);
    [_headingText setText:[NSString stringWithFormat:@"%f", heading]];
    [_attitudeText setText:[NSString stringWithFormat:@"%f", attitude]];
    [_bankText setText:[NSString stringWithFormat:@"%f", bank]];
    [_gxText setText:[NSString stringWithFormat:@"%d", gx]];
    [_gyText setText:[NSString stringWithFormat:@"%d", gy]];
    [_gzText setText:[NSString stringWithFormat:@"%d", gz]];
    [_mxText setText:[NSString stringWithFormat:@"%d", mx]];
    [_myText setText:[NSString stringWithFormat:@"%d", my]];
    [_mzText setText:[NSString stringWithFormat:@"%d", mz]];
    [_axText setText:[NSString stringWithFormat:@"%d", ax]];
    [_ayText setText:[NSString stringWithFormat:@"%d", ay]];
    [_azText setText:[NSString stringWithFormat:@"%d", az]];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    } else {
        // Notification has stopped
        [_centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    _discoveredPeripheral = nil;
    
    //[_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
}


@end
