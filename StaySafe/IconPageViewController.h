//
//  IconPageViewController.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/19/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "model/RepositoryModel.h"
#import "BroadcastViewController.h"
#import "SafeWalkViewController.h"
#import "UpdateProfileViewController.h"


@interface IconPageViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *shareIconButton;
@property (weak, nonatomic) IBOutlet UIButton *broadcastIconButton;
@property (weak, nonatomic) IBOutlet UIButton *helpIconButton;
@property (weak, nonatomic) IBOutlet UIButton *safewalkIconButton;
//handle to the repository responsible for handling the data
@property(nonatomic,weak) RepositoryModel* repository;
//set by RegistrationViewcontroller in order to have a single repository instance
- (void) setRepository:(RepositoryModel *)repository;
@property (weak, nonatomic) BroadcastViewController  *broadcastViewController;
@property (weak, nonatomic) SafeWalkViewController  *safewalkViewController;
@property (weak, nonatomic) UpdateProfileViewController  *updateProfileViewController;

- (IBAction)shareIconButtonAction:(id)sender;

@end
