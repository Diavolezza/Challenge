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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    // Design-Größe (iPad-Portrait)
    CGFloat designWidth = 768.0;
    CGFloat designHeight = 1024.0;

    // Tatsächliche Bildschirmgröße
    CGSize screenSize = self.view.bounds.size; // Das ist *aktuelle Ausrichtung*
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;

    if (round(screenWidth) != round(designWidth)) {
        // Einheitliche Skalierung berechnen
        CGFloat scaleX = screenWidth / designWidth;
        CGFloat scaleY = screenHeight / designHeight;
        CGFloat scale = MIN(scaleX, scaleY); // damit nichts rausfällt

        // Skalierung anwenden
        self.view.transform = CGAffineTransformMakeScale(scale, scale);

        // Nach Skalierung: neue Größe
        CGFloat scaledWidth = designWidth * scale;
        CGFloat scaledHeight = designHeight * scale;

        // Differenz berechnen, um zu zentrieren
        CGFloat dx = (screenWidth - scaledWidth) / 2.0;
        CGFloat dy = (screenHeight - scaledHeight) / 2.0;

        // Frame verschieben zur Zentrierung
        self.view.frame = CGRectMake(dx, dy, scaledWidth, scaledHeight);
    }

}

@end
