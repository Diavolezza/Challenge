//
//  SecondaryViewController.h
//  Challenge
//
//  Created by wanner on 20.09.13.
//  Copyright (c) 2013 Gerhard Wanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondaryViewController : UIViewController
{
    IBOutlet UITextField *laps;
    IBOutlet UITextField *refLap;
    IBOutlet UITextField *boxTime;
}

@property(nonatomic, retain) IBOutlet UITextField *laps;
@property(nonatomic, retain) IBOutlet UITextField *refLap;
@property(nonatomic, retain) IBOutlet UITextField *boxTime;

-(IBAction)settingsDone:(id)sender;

@end
