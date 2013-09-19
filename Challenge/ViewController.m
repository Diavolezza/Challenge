//
//  ViewController.m
//  Challenge
//
//  Created by wanner on 18.09.13.
//  Copyright (c) 2013 Gerhard Wanner. All rights reserved.
//
//
// TODO
// - Totalanzeige nach letzter Runde stehen lassen und nicht mehr weiterzählen
// - Aktuelle Rundenzeit anzeigen
// - Options-Fenster für die Konstanten
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

SystemSoundID mBeep;
SystemSoundID mAlert;

int mLap = -1;                      // Rundenanzahl
bool running = false;               // Gibt an, ob die Stopuhr läuft
bool inBox = false;                 // Gibt an, ob der Boxenstop bereits erfolgt ist
NSTimer *timer;                     // Timer für die asynchrone Zeitanzeige

NSDate *startTime;                  // Startzeit der Messung
NSDate *startLapTime;               // Startzeit der aktuellen Runde
NSDate *startRefTime;               // Startzeit der Referenzrunde
NSDate *endRefTime;                 // Endzeit der Referenzrunde

// Referenzrunde
NSTimeInterval refLapTimeInterval;  // Zeit der Referenzrunde

const int REF_LAP = 2;              // Runde, in der die Referenzzeit genommen wird
const int TOTAL_LAP = 20;           // Gesamtanzahl Runden
const int BOX_TIME = 90;            // Geschätzte Boxenzeit inkl. Ein- und Ausfahrt

const int ALERT_BOX = 0;
const int ALERT_RESET = 1;

@interface ViewController ()

@end

@implementation ViewController

@synthesize counter;
@synthesize totalTime;
@synthesize lapTime;
@synthesize lastLapTime;
@synthesize refLapTime;
@synthesize targetLapTime;
@synthesize targetTotalTime;
@synthesize boxButton;
@synthesize incButton;
@synthesize decButton;

-(void)alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case (ALERT_BOX):
            if(buttonIndex != [alertView cancelButtonIndex]) {
                inBox = true;
                boxButton.enabled = false;
            }
            break;
        case ALERT_RESET:
            if(buttonIndex != [alertView cancelButtonIndex]) {
                [self reset];
            }
            break;
        default:
            break;
    }
}

-(IBAction)box:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Box" message:@"Boxenstop?" delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja", nil ];
    alert.tag = ALERT_BOX;
    [alert show];
}

-(IBAction)dec:(id)sender
{
    mLap--;
    [self displayCounter];
     AudioServicesPlaySystemSound(mBeep);
}

-(void)displayCounter
{
    int lap = mLap;
    if(lap == -1) {
        lap = 0;
    }
    counter.text = [NSString stringWithFormat:@"%d", lap ];
}

- (void)displayLastLapTime
{
    NSString * timeString;
    if(startLapTime != nil) {
        NSDate *currentDate = [NSDate date];
        NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startLapTime];
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"mm:ss.S"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        timeString = [dateFormatter stringFromDate:timerDate];
    } else {
        timeString = @"";
    }
    lastLapTime.text = timeString;
}

- (void)displayRefTime
{
    NSString * timeString;
    if(startLapTime != nil) {
        refLapTimeInterval = [endRefTime timeIntervalSinceDate:startRefTime];
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:refLapTimeInterval];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"mm:ss.S"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        timeString = [dateFormatter stringFromDate:timerDate];
    } else {
        timeString = @"";
    }
    refLapTime.text = timeString;

}

-(void)displayTimerTimes
{
    [self displayTotalTime];
    [self displayTargetTotalTime];
}

- (void)displayTotalTime
{
    NSString * timeString;
    if(startTime != nil) {
        NSDate *currentDate = [NSDate date];
        NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startTime];
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"H:mm:ss.S"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        timeString = [dateFormatter stringFromDate:timerDate];
    } else {
        timeString = @"0:00:00.0";
    }
    totalTime.text = timeString;
}

- (void)displayTargetLapTime
{
    NSString * timeString;
    
    if(mLap >= REF_LAP) {
        // Gesamtzeit Wertungsprüfung auf Basis der Referenzrunde
        NSTimeInterval timeInterval = (20 - REF_LAP) * refLapTimeInterval;
        // Zeit seit Ende der Referenzrunde abziehen
        NSDate *currentDate = [NSDate date];
        timeInterval -= [currentDate timeIntervalSinceDate:endRefTime];
        // Durch die Anzahl verbleibender Runden teilen
        timeInterval = timeInterval / (20-mLap);
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"mm:ss.S"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        timeString = [dateFormatter stringFromDate:timerDate];
    } else {
        timeString = @"";
    }
    targetLapTime.text = timeString;
}

- (void)displayTargetTotalTime
{
    NSString * timeString;
    
    if(mLap >= REF_LAP) {
        // Gesamtzeit Wertungsprüfung auf Basis der Referenzrunde
        NSTimeInterval timeInterval = (20 - REF_LAP) * refLapTimeInterval;
        // Erwartete Boxenzeit dazurechnen
        if(!inBox) {
            timeInterval = timeInterval + BOX_TIME;
        }
        // Zeit seit Ende der Referenzrunde abziehen
        NSDate *currentDate = [NSDate date];
        timeInterval -= [currentDate timeIntervalSinceDate:endRefTime];
        // Beep 3 Sekunden vor Ende
        NSLog(@"%f", timeInterval);
        if(((timeInterval < 3.05) && (timeInterval > 2.95)) ||
           ((timeInterval < 2.05) && (timeInterval > 1.95)) ||
           ((timeInterval < 1.05) && (timeInterval > 0.95)) ||
           ((timeInterval < 0.05) && (timeInterval > -0.05))) 
        {
            NSLog(@"Beep");
            AudioServicesPlaySystemSound(mAlert);
        }
        // Wieder hochzählen
        if(timeInterval < 0) {
            timeInterval = -timeInterval;
            targetTotalTime.backgroundColor = [UIColor clearColor];
        }
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"H:mm:ss.S"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        timeString = [dateFormatter stringFromDate:timerDate];
    } else {
        timeString = @"";
        targetTotalTime.backgroundColor = [UIColor whiteColor];
    }
    targetTotalTime.text = timeString;
}

-(IBAction)inc:(id)sender
{
    mLap++;
    [self displayCounter];
    AudioServicesPlaySystemSound(mBeep);
}

-(IBAction)lap:(id)sender
{
    if(!running) {
        running = true;
        startTime = [NSDate date];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0 target:self selector:@selector(displayTimerTimes) userInfo:nil repeats:YES];
    }
    mLap++;
    if(mLap == REF_LAP-1) {
        // Referenzrunde
        startRefTime = [NSDate date];
    }
    if(mLap == REF_LAP) {
        endRefTime = [NSDate date];
        [self displayRefTime];
        incButton.enabled = true;
        decButton.enabled = true;
    }
    [self displayCounter];
    [self displayLastLapTime];
    [self displayTargetLapTime];
    startLapTime = [NSDate date];
    AudioServicesPlaySystemSound(mBeep);
}

-(IBAction)reset:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Reset" message:@"Rundenzähler und Timer zurücksetzen?" delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja", nil];
    alert.tag = ALERT_RESET;
    [alert show];
}

-(void)reset
{
    running = false;
    inBox = false;
    boxButton.enabled = true;
    [self resetCounter];
    [self resetTimer];
    incButton.enabled = false;
    decButton.enabled = false;
}

-(void)resetCounter
{
    mLap = -1;
    [self displayCounter];
}

-(void)resetTimer
{
    if(timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    startTime = nil;
    startRefTime = nil;
    endRefTime = nil;
    startLapTime = nil;
    [self displayTotalTime];
    [self displayRefTime];
    [self displayLastLapTime];
    [self displayTargetLapTime];
    [self displayTargetTotalTime];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Create the sound ID
    NSURL* beepURL = [[NSBundle mainBundle]
                      URLForResource:@"Default" withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)beepURL, &mBeep);
    NSURL* alertURL = [[NSBundle mainBundle]
                      URLForResource:@"Laser" withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)alertURL, &mAlert);
    [self resetTimer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	// Do any additional setup after loading the view, typically from a nib.
    AudioServicesDisposeSystemSoundID(mBeep);
    AudioServicesDisposeSystemSoundID(mAlert);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
