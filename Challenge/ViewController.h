//
//  ViewController.h
//  Challenge
//
//  Created by wanner on 18.09.13.
//  Copyright (c) 2013 Gerhard Wanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UILabel *counter;
    IBOutlet UITextField *totalTime;
    IBOutlet UITextField *lapTime;
    IBOutlet UITextField *lastLapTime;
    IBOutlet UITextField *refLapTime;
    IBOutlet UITextField *targetLapTime;
    IBOutlet UITextField *targetTotalTime;
    IBOutlet UIButton *boxButton;
    IBOutlet UIButton *incButton;
    IBOutlet UIButton *decButton;
    IBOutlet UIButton *refPlusHButton;
    IBOutlet UIButton *refMinusHButton;
    IBOutlet UIButton *refPlusZButton;
    IBOutlet UIButton *refMinusZButton;
}

@property(nonatomic, retain) IBOutlet UILabel *counter;
@property(nonatomic, retain) IBOutlet UITextField *totalTime;
@property(nonatomic, retain) IBOutlet UITextField *lapTime;
@property(nonatomic, retain) IBOutlet UITextField *lastLapTime;
@property(nonatomic, retain) IBOutlet UITextField *refLapTime;
@property(nonatomic, retain) IBOutlet UITextField *targetLapTime;
@property(nonatomic, retain) IBOutlet UITextField *targetTotalTime;
@property(nonatomic, retain) IBOutlet UIButton *boxButton;
@property(nonatomic, retain) IBOutlet UIButton *incButton;
@property(nonatomic, retain) IBOutlet UIButton *decButton;
@property(nonatomic, retain) IBOutlet UIButton *refPlusHButton;
@property(nonatomic, retain) IBOutlet UIButton *refMinusHButton;
@property(nonatomic, retain) IBOutlet UIButton *refPlusZButton;
@property(nonatomic, retain) IBOutlet UIButton *refMinusZButton;

-(IBAction)lap:(id)sender;
-(IBAction)box:(id)sender;
-(IBAction)reset:(id)sender;
-(IBAction)inc:(id)sender;
-(IBAction)dec:(id)sender;
-(IBAction)refPlusH:(id)sender;
-(IBAction)refMinusH:(id)sender;
-(IBAction)refPlusZ:(id)sender;
-(IBAction)refMinusZ:(id)sender;

@end
