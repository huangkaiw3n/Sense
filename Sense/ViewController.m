//
//  ViewController.m
//  Sense
//
//  Created by Kaiwen Huang on 20/8/15.
//  Copyright (c) 2015 Kaiwen Huang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

static const CGSize FRAME_SIZE = { 130, 40 };

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drawHelloWorld];
}


- (void)drawHelloWorld {
    
    CGRect frame;
    int scale;
    CGFloat x = (arc4random() % (int)self.view.bounds.size.width - 300);
    CGFloat y = (arc4random() % (int)self.view.bounds.size.height - 200);
    frame.origin = CGPointMake(x, y);
    scale = (arc4random() % 6) + 1;
    frame.size = CGSizeMake(FRAME_SIZE.width * scale, FRAME_SIZE.height * scale);
    
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.attributedText = [[NSAttributedString alloc] initWithString:@"Hello World!" attributes:@{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody], NSForegroundColorAttributeName: [self randomColor]}];
    textView.font = [textView.font fontWithSize: 12 * scale];
    textView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:3.0 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        textView.alpha = 0.0;
    } completion:^(BOOL fin) {if (fin) [textView removeFromSuperview];}];
    [self.view addSubview:textView];
}

- (UIColor *)randomColor{
    switch (arc4random() % 6){
        case 0: return [UIColor greenColor];
        case 1: return [UIColor blueColor];
        case 2: return [UIColor orangeColor];
        case 3: return [UIColor redColor];
        case 4: return [UIColor purpleColor];
    }
    return [UIColor yellowColor];
}

@end
