//
//  PhoneCallViewController.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/9/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
//  contains the implementation of methods for implementting phone calls


#import "PhoneCallViewController.h"

@interface PhoneCallViewController ()

@end

@implementation PhoneCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //adding background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light-blue-background-1"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickDPSCallButton:(id)sender {
    NSURL *phoneNumber = [NSURL URLWithString:@"telprompt://3154431870"];
    [[UIApplication sharedApplication] openURL:phoneNumber];
}


- (IBAction)onClickFireCallButton:(id)sender {
    NSURL *phoneNumber = [NSURL URLWithString:@"telprompt://3154735525"];
    [[UIApplication sharedApplication] openURL:phoneNumber];
}
- (IBAction)onClickPoliceCallButton:(id)sender {
    NSURL *phoneNumber = [NSURL URLWithString:@"telprompt://911"];
    [[UIApplication sharedApplication] openURL:phoneNumber];
}
- (IBAction)onClickEscortCallButton:(id)sender {
    NSURL *phoneNumber = [NSURL URLWithString:@"telprompt://3154437233"];
    [[UIApplication sharedApplication] openURL:phoneNumber];
}
@end
