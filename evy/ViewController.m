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
@property (weak, nonatomic) IBOutlet UITextField *txtLowRisk;
@property (weak, nonatomic) IBOutlet UITextField *txtMedRisk;
@property (weak, nonatomic) IBOutlet UITextField *txtHighRisk;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCountdown:(id)sender {
    
    int days = self.txtDays.text.intValue;
    
    int hrTens = self.txtHrTens.text.intValue;
    int hrOnes = self.txtHrOnes.text.intValue;
    
    int minTens = self.txtMinTens.text.intValue;
    int minOnes = self.txtMinOnes.text.intValue;
    
    int secTens = self.txtSecTens.text.intValue;
    int secOnes = self.txtSecOnes.text.intValue;
    
    [self printCountdown: days hrTens: hrTens hrOnes: hrOnes minTens: minTens minOnes: minOnes secTens: secTens secOnes: secOnes];
    
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
//    NSDate *startDate = [[timer userInfo] objectForKey:@"StartDate"];
//    
//    NSLog(@"Timer started on %@", startDate);
    
    count--;
    self.txtTimeSnapshot.text = [NSString stringWithFormat:@"%d", count];
    [self updateTimeShown];
    
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

//    int totalTime = count * maxTime;
//    int time = count % maxTime;
    NSLog (@"PreTime(s): %d", timeLen);
    timeLen = timeLen % maxTime;
    NSLog (@"PostTime(s): %d", timeLen);
   
    [tensPlace setText:[NSString stringWithFormat:@"%d", timeLen / 10]];
    [onesPlace setText:[NSString stringWithFormat:@"%d", timeLen % 10]];
   
}

- (void) postCountdown {
    [self stopTimer];
    [self countdownDone];
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
//    [self.btnCountdown setTitle:@"Countdown Begun" forState:UIControlStateNormal];
    [self.btnCountdown setAlpha:0];
    [self.lblRisk1 setAlpha:1];
    [self.txtLowRisk setAlpha:1];
    [self.riskTitle setAlpha:1];
    //TODO After testing, change this back to the total seconds.
    count = NUM_FOLLOWUP_SEC;
 }

- (NSString*)getTimeSnapshot {
    long long timeSeconds = (long long)([[NSDate date] timeIntervalSince1970]);
    
    return [NSString stringWithFormat:@"%lld", timeSeconds];
}


@end
