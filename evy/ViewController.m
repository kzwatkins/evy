//
//  ViewController.m
//  evy
//
//  Created by Kera Z. Watkins on 7/2/17.
//  Copyright © 2017 Watkins Proactive Research LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtDays;

@property (weak, nonatomic) IBOutlet UITextField *txtHrTens;
@property (weak, nonatomic) IBOutlet UITextField *txtHrOnes;

@property (weak, nonatomic) IBOutlet UITextField *txtMinTens;
@property (weak, nonatomic) IBOutlet UITextField *txtMinOnes;

@property (weak, nonatomic) IBOutlet UITextField *txtSecTens;
@property (weak, nonatomic) IBOutlet UITextField *txtSecOnes;

@property (weak, nonatomic) IBOutlet UILabel *txtTimeSnapshot;
@property (weak, nonatomic) IBOutlet UIButton *btnCountdown;

// Risk
@property (weak, nonatomic) IBOutlet UITextField *riskTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblRisk1;
@property (weak, nonatomic) IBOutlet UILabel *lblRisk2;
@property (weak, nonatomic) IBOutlet UILabel *lblRisk3;
@property (weak, nonatomic) IBOutlet UILabel *lblRisk4;
@property (weak, nonatomic) IBOutlet UILabel *lblRisk5;

// Levels of Risk
@property (weak, nonatomic) IBOutlet UITextField *riskLevel1;
@property (weak, nonatomic) IBOutlet UITextField *riskLevel2;
@property (weak, nonatomic) IBOutlet UITextField *riskLevel3;
@property (weak, nonatomic) IBOutlet UITextField *riskLevel4;
@property (weak, nonatomic) IBOutlet UITextField *riskLevel5;

// Post Countdown
@property (weak, nonatomic) IBOutlet UILabel *lblCountdownDone;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    riskLabelAry = [[NSMutableArray alloc] initWithCapacity:RISK_ARY_SIZE];

    riskLevelAry = [[NSMutableArray alloc] initWithCapacity:RISK_ARY_SIZE];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCountdown:(id)sender {
    // 0) Init
    [self initWork];
    
   // 1) Initial btn press handling
    if(self.btnCountdown.isEnabled){
        [self initPress];
        [self createTimer:1];
    }
}

//: Modified from https://looksok.wordpress.com/2012/12/29/ios-timer-countdown-implementation-tutorial-including-source-code/

- (void) createTimer: (int) secInterval {
    
    timer = [NSTimer scheduledTimerWithTimeInterval:secInterval
        target:self
        selector:@selector(updateTimeView)
        userInfo:nil
        repeats:YES ];
 
    NSRunLoop* runner = [NSRunLoop currentRunLoop];
    [runner addTimer:timer forMode: NSDefaultRunLoopMode];

}


- (void) updateTimeView {
    count--;
    self.txtTimeSnapshot.text = [NSString stringWithFormat:@"%d", count];
    [self updateTimeShown];
    [self showRisk:count];
    if(count <= 0){
        [self postCountdown];
    }
}

- (void) updateTimeShown {
    
    [self updateTimeText:SEC_MAX timeLen:count txtTensPlace:self.txtSecTens txtOnesPlace:self.txtSecOnes];
    [self updateTimeText:MIN_MAX timeLen:[self secToMins:count] txtTensPlace:self.txtMinTens txtOnesPlace:self.txtMinOnes];
    [self updateTimeText:HR_MAX timeLen:[self secToHrs:count] txtTensPlace:self.txtHrTens txtOnesPlace:self.txtHrOnes];
    [self updateDays:count];
}

- (void) updateDays: (int) seconds{
    int days = [self secToDays:seconds];
    days = days % DAY_MAX;
    [self.txtDays setText:[NSString stringWithFormat:@"%d", days]];
}

- (int) secToDays: (int) sec {
    int result = sec / SEC_MAX / MIN_MAX / HR_MAX;
    return result;
}

- (int) secToMins: (int) sec {
    int result = sec / SEC_MAX;
    return result;
}

- (int) secToHrs: (int) sec {
    int result = sec / SEC_MAX / MIN_MAX ;
    return result;
}

- (void) updateTimeText: (int) maxTime timeLen: (int)timeLen txtTensPlace:(UITextField*) tensPlace txtOnesPlace:(UITextField*) onesPlace{

//    NSLog (@"PreTime(s): %d", timeLen);
    timeLen = timeLen % maxTime;
//    NSLog (@"PostTime(s): %d", timeLen);
   
    [tensPlace setText:[NSString stringWithFormat:@"%d", timeLen / 10]];
    [onesPlace setText:[NSString stringWithFormat:@"%d", timeLen % 10]];
   
}

- (void) postCountdown {
    [self stopTimer];
    [self countdownDone];
    [self.lblCountdownDone setAlpha:1];
}

- (void) stopTimer {
    if(timer){
        [timer invalidate];
        timer = nil;
    }
}

- (void)countdownDone {
    [self.btnCountdown setTitle:@"Countdown Done" forState:UIControlStateNormal];
   
    NSLog(@"Countdown is done!");
}

- (void)printCountdown: (int) days hrTens: (int) hrTens hrOnes: (int) hrOnes minTens: (int) minTens minOnes: (int) minOnes secTens: (int) secTens secOnes: (int) secOnes{
    NSLog(@"days - %d, hours - %d:%d, minutes - %d:%d, seconds - %d:%d", days, hrTens, hrOnes, minTens, minOnes, secTens, secOnes);
}

- (void) initPress {
    self.btnCountdown.enabled = NO;
    [self.btnCountdown setAlpha:0];
    [self.riskTitle setAlpha:1];
 }

- (void) initWork {
    //TODO After testing, change this back to the total seconds.
    count = NUM_FOLLOWUP_SEC;
    [self setRiskArrays];
}

- (void) setRiskArrays {
    [riskLabelAry addObject:self.lblRisk1];
    [riskLabelAry addObject:self.lblRisk2];
    [riskLabelAry addObject:self.lblRisk3];
    [riskLabelAry addObject:self.lblRisk4];
    [riskLabelAry addObject:self.lblRisk5];
    
    [riskLevelAry addObject:self.riskLevel1];
    [riskLevelAry addObject:self.riskLevel2];
    [riskLevelAry addObject:self.riskLevel3];
    [riskLevelAry addObject:self.riskLevel4];
    [riskLevelAry addObject:self.riskLevel5];
}

//TODO Add in risk showing logic.
- (void) showRisk: (int) seconds {
    int index = 10.0 * (NUM_FOLLOWUP_SEC - count) / NUM_FOLLOWUP_SEC - 1;
    
    int iterator = index % 2;
    index = (index / 2);
    [self updateRiskAlpha:index iterator:iterator];
}

- (void) updateRiskAlpha:(int) index iterator:(int) iterator{
    if(iterator % 2 == 0){
        if(index - 1 >= 0){
            [self setRiskAlpha:index - 1 alpha:0.5];
        }
        
        [self setRiskAlpha:index alpha:0.5];
        
    } else {
        if(index - 1 >= 0){
            [self setRiskAlpha:index - 1 alpha:0.1];
        }
        
        [self setRiskAlpha:index alpha:1];
    }
}

- (void) setRiskAlpha:(int) index alpha:(double) alpha{
    UILabel* riskLevel = [riskLevelAry objectAtIndex: index];
    UILabel* riskLabel = [riskLabelAry objectAtIndex: index];
    
    
    [riskLevel setAlpha:alpha];
    [riskLabel setAlpha:alpha];
}

- (NSString*)getTimeSnapshot {
    long long timeSeconds = (long long)([[NSDate date] timeIntervalSince1970]);
    
    return [NSString stringWithFormat:@"%lld", timeSeconds];
}


@end
