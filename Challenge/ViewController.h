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
}

@property(nonatomic, retain) IBOutlet UILabel *counter;
@property(nonatomic, retain) IBOutlet UITextField *totalTime;

-(IBAction)incrementCounter:(id)sender;
-(IBAction)resetCounter:(id)sender;

-(void)displayCounter;
-(void)displayTimer;

@end
