//
//  ViewController.m
//  Challenge
//
//  Created by wanner on 18.09.13.
//  Copyright (c) 2013 Gerhard Wanner. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

// ivar
SystemSoundID mBeep;

@interface ViewController ()

@end

@implementation ViewController

@synthesize counter;

-(IBAction)resetCounter:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Rundenzähler zurücksetzen" message:@"Rundenzähler auf 0 zurücksetzen?" delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja", nil];
    [alert show];
}

-(IBAction)incrementCounter:(id)sender
{
//    int c = counter.currentTitle.intValue+1;
//    [counter setTitle: [NSString stringWithFormat:@"%d", c ] forState:UIControlStateNormal];
    AudioServicesPlaySystemSound(mBeep);
}

-(void)alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != [alertView cancelButtonIndex]) {
        NSLog(@"Ok clicked");
        [counter setTitle: @"0" forState:UIControlStateNormal];
        AudioServicesPlaySystemSound(mBeep);
    } else {
        NSLog(@"Cancel clicked");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Create the sound ID
    NSURL* beepURL = [[NSBundle mainBundle]
                      URLForResource:@"Default" withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)beepURL, &mBeep);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	// Do any additional setup after loading the view, typically from a nib.
    AudioServicesDisposeSystemSoundID(mBeep);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
