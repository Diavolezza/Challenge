//
//  SecondaryViewController.m
//  Challenge
//
//  Created by wanner on 20.09.13.
//  Copyright (c) 2013 Gerhard Wanner. All rights reserved.
//

#import "SecondaryViewController.h"
#import "main.h"

@interface SecondaryViewController ()

@end

@implementation SecondaryViewController

@synthesize laps;
@synthesize refLap;
@synthesize boxTime;

- (IBAction)settingsDone:(id)sender {
    TOTAL_LAP = [laps.text intValue];
    REF_LAP = [refLap.text intValue];
    BOX_TIME = [boxTime.text intValue];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    laps.text = [NSString stringWithFormat:@"%d", TOTAL_LAP];
    refLap.text = [NSString stringWithFormat:@"%d", REF_LAP];
    boxTime.text = [NSString stringWithFormat:@"%d", BOX_TIME];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
