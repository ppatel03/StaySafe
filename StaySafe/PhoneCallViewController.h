//
//  PhoneCallViewController.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/9/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneCallViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *dpsCallButton;
- (IBAction)onClickDPSCallButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *fireCallButton;
- (IBAction)onClickFireCallButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *policeCallButton;
- (IBAction)onClickPoliceCallButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *escortCallButton;
- (IBAction)onClickEscortCallButton:(id)sender;

@end
