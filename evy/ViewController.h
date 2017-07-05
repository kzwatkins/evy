//
//  ViewController.h
//  evy
//
//  Created by Kera Z. Watkins on 7/2/17.
//  Copyright © 2017 Watkins Proactive Research LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    
    NUM_FOLLOWUP_DAYS = 180,
    HR_MAX = 24,
    MIN_MAX = 60,
    SEC_MAX = 60,
    DAY_MAX = 365,
    NUM_FOLLOWUP_SEC = NUM_FOLLOWUP_DAYS * HR_MAX * MIN_MAX * SEC_MAX,
    RISK_ARY_SIZE = 5
};

NSTimer* timer;
//NSRunLoop *runner;
int count = 0;
NSMutableArray* riskLabelAry;
NSMutableArray* riskLevelAry;

@interface ViewController : UIViewController

// Initial work
- (void) initPress;

//
- (void) printCountdown: (int) days hrTens: (int) hrTens hrOnes: (int) hrOnes minTens: (int) minTens minOnes: (int) minOnes secTens: (int) secTens secOnes: (int) secOnes;

// Handling timing events.
- (void) createTimer: (int) secInterval;
- (void) updateTimeView;
- (void) updateTimeShown;
- (void) updateTimeText: (int) maxTime timeLen: (int)timeLen txtTensPlace:(UITextField*) tensPlace txtOnesPlace:(UITextField*) onesPlace;
- (void) stopTimer;
- (NSString*) getTimeSnapshot;

// Conversions
- (int) secToMins: (int) sec;
- (int) secToHrs: (int) sec;
- (int) secToDays: (int) sec;

// The countdown has completed.
- (void) postCountdown;
- (void) countdownDone;

// Handling Risk
- (void) setRiskArrays;
- (void) showLevel: (int) seconds;
- (void) setRiskAlpha:(int) index alpha:(double) alpha;


@end

