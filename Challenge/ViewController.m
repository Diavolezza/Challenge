//
//  ViewController.m
//  Challenge
//
//  Created by wanner on 18.09.13.
//  Copyright (c) 2013 Gerhard Wanner. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

SystemSoundID mBeep;
int mLap = 0;
bool running = false;
NSTimer *timer;
int timerCount;

@interface ViewController ()

@end

@implementation ViewController

@synthesize counter;
@synthesize totalTime;

-(IBAction)resetCounter:(id)sender
{
    NSLog(@"resetCounter");
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Rundenzähler zurücksetzen" message:@"Rundenzähler auf 0 zurücksetzen?" delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja", nil];
    [alert show];
}

-(IBAction)incrementCounter:(id)sender
{
    NSLog(@"incrementCounter");
    if(!running) {
        running = true;
        timerCount = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(displayTimer) userInfo:nil repeats:YES];
    }
    mLap++;
    [self displayCounter];
}

- (void)displayTimer
{
    NSLog(@"displayTimer");
    totalTime.text = [NSString stringWithFormat:@"%d", timerCount++];
}

-(void)alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"alertView");
    if(buttonIndex != [alertView cancelButtonIndex]) {
        NSLog(@"Ok clicked");
        mLap = 0;
        running = false;
        [self displayCounter];
    } else {
        NSLog(@"Cancel clicked");
    }
}

-(void)displayCounter
{
    NSLog([NSString stringWithFormat:@"%d", mLap ]);
    counter.text = [NSString stringWithFormat:@"%d", mLap ];
//    [counter setTitle: [NSString stringWithFormat:@"%d", mLap ] forState:UIControlStateNormal];
    AudioServicesPlaySystemSound(mBeep);
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
