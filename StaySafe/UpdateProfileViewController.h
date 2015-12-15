//
//  UpdateProfileViewController.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/9/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
//  contains the declaration of methods for updating user profile

#import <UIKit/UIKit.h>
#import "RepositoryModel.h"

@interface UpdateProfileViewController : UIViewController
//set by IconPageViewcontroller in order to have a single repository instance
- (void) setRepository:(RepositoryModel *)repository;

@property (weak, nonatomic) IBOutlet UITextField *updateNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *updateEmailTextField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
- (IBAction)onClickUpdateButtton:(id)sender;
//handle to the repository responsible for handling the data
@property(nonatomic,weak) RepositoryModel *repository;

@end
