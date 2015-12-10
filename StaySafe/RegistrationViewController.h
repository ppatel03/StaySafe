//
//  RegistrationViewController.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/9/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model/RepositoryModel.h"
#import  "IconPageViewController.h"
#import "UserDetailVO.h"

@interface RegistrationViewController : UIViewController

//handle to the repository responsible for handling the data
@property(nonatomic,strong) RepositoryModel* repository;
@property (weak, nonatomic) IconPageViewController  *iconPageViewController;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIdUITextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendSMSButton;
@property (weak, nonatomic) IBOutlet UITextField *verficationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)onClickSendSMSButton:(id)sender;
- (IBAction)onClickRegisterButton:(id)sender;


@end
