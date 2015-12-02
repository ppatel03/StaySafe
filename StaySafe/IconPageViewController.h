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


@interface IconPageViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *shareIconButton;
@property (weak, nonatomic) IBOutlet UIButton *broadcastIconButton;
@property (weak, nonatomic) IBOutlet UIButton *helpIconButton;
@property (weak, nonatomic) IBOutlet UIButton *safewalkIconButton;
@property (strong,nonatomic) RepositoryModel *repository;
@property (weak, nonatomic) BroadcastViewController  *broadcastViewController;
- (IBAction)shareIconButtonAction:(id)sender;

@end
