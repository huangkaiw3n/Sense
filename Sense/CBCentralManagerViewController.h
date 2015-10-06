//
//  CBCentralManagerViewController.h
//  Sense
//
//  Created by Kaiwen Huang on 28/8/15.
//  Copyright (c) 2015 Kaiwen Huang. All rights reserved.
//
#import "OpenGLView.h"
@import GLKit;
@import OpenGLES;
@import QuartzCore;
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "SERVICES.h"
#include "MadgwickAHRS.h"

@interface CBCentralManagerViewController : UIViewController < CBCentralManagerDelegate, CBPeripheralDelegate>;
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) IBOutlet UITextField *headingText;
@property (strong, nonatomic) IBOutlet UITextField *attitudeText;
@property (strong, nonatomic) IBOutlet UITextField *bankText;
@property (strong, nonatomic) IBOutlet UITextField *gxText;
@property (strong, nonatomic) IBOutlet UITextField *gyText;
@property (strong, nonatomic) IBOutlet UITextField *mxText;
@property (strong, nonatomic) IBOutlet UITextField *gzText;
@property (strong, nonatomic) IBOutlet UITextField *myText;
@property (strong, nonatomic) IBOutlet UITextField *mzText;
@property (strong, nonatomic) IBOutlet UITextField *axText;
@property (strong, nonatomic) IBOutlet UITextField *ayText;
@property (strong, nonatomic) IBOutlet UITextField *azText;
@property (strong, nonatomic) IBOutlet UIView *cubeView;
@property OpenGLView *cube;

@end
