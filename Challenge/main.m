//
//  main.m
//  Challenge
//
//  Created by wanner on 20.09.13.
//  Copyright (c) 2013 Gerhard Wanner. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int REF_LAP = 2;                // Runde, in der die Referenzzeit genommen wird
int TOTAL_LAP = 20;             // Gesamtanzahl Runden
int BOX_TIME = 90;              // Geschätzte Boxenzeit inkl. Ein- und Ausfahrt

int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
