//
//  VideoViewController.m
//  Sense
//
//  Created by Kaiwen Huang on 23/8/15.
//  Copyright (c) 2015 Kaiwen Huang. All rights reserved.
//

#import "VideoViewController.h"


@interface VideoViewController ()
@property (nonatomic, retain) AVPlayerViewController *avPlayerViewcontroller;

@end

@implementation VideoViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    UIView *view = self.view;
    NSString *resourceName = @"Star Wars Episode VII - The Force Awakens - Teaser Trailer 2.mp4";
    NSString* movieFilePath = [[NSBundle mainBundle]
                               pathForResource:resourceName ofType:nil];
    NSAssert(movieFilePath, @"movieFilePath is nil");
    NSURL *fileURL = [NSURL fileURLWithPath:movieFilePath];
    
    AVPlayerViewController *playerViewController =
    [[AVPlayerViewController alloc] init];
    playerViewController.player =
    [AVPlayer playerWithURL:fileURL];
    self.avPlayerViewcontroller = playerViewController;
    [self resizePlayerToViewSize];
    [view addSubview:playerViewController.view];
    view.autoresizesSubviews = TRUE;
}

- (void) resizePlayerToViewSize
{
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(0.0, 50);
    frame.size.width = frame.size.width;
    frame.size.height = frame.size.height - 100;
    
    
    NSLog(@"frame size %d, %d", (int)frame.size.width, (int)frame.size.height);
    
    self.avPlayerViewcontroller.view.frame = frame;
}

@end