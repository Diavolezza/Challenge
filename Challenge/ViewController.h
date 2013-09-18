//
//  ViewController.h
//  Challenge
//
//  Created by wanner on 18.09.13.
//  Copyright (c) 2013 Gerhard Wanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UIButton *counter;
}

@property(nonatomic, retain) IBOutlet UIButton *counter;

-(IBAction)incrementCounter:(id)sender;

-(IBAction)resetCounter:(id)sender;

@end
