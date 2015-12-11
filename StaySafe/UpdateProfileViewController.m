//
//  UpdateProfileViewController.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/9/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import "UpdateProfileViewController.h"

@interface UpdateProfileViewController ()

@end

@implementation UpdateProfileViewController
int updateDirection;
int updateShakes;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //adding background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light-blue-background-1"]];
    //rounded corners
    self.updateButton.layer.cornerRadius = 10; // this value vary as per your desire
    self.updateButton.clipsToBounds = YES;
    
    //load already existing user details
    [self loadDefault];
}

//set by IconPageViewcontroller in order to have a single repository instance
- (void) setRepository:(RepositoryModel *)repository{
    _repository = repository;
}

-(void) loadDefault{
    self.updateNameTextField.text = self.repository.currentUser.name;
    self.updateEmailTextField.text= self.repository.currentUser.email;
    //set text field to default colors
    [self setTextFieldToDefaultColors];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//default colors for text field
-(void) setTextFieldToDefaultColors{
    self.updateNameTextField.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.3];
    self.updateEmailTextField.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.3];
    }

//when user clicks on update button
- (IBAction)onClickUpdateButtton:(id)sender {
    
    //set text field to default colors
    [self setTextFieldToDefaultColors];
    
    if([self isTextFieldCorrect:self.updateEmailTextField default:[self.repository.currentUser email]] |
       [self isTextFieldCorrect:self.updateNameTextField default:[self.repository.currentUser name]]){
        
        UserDetailVO* updatedUser = self.repository.currentUser;
        updatedUser.email =self.updateEmailTextField.text;
        updatedUser.name = self.updateNameTextField.text;
        
        //update the users in the db
        [self.repository updateCurrentUser : updatedUser];
        
        //send SMS to user
        NSMutableDictionary* userDict = [NSMutableDictionary dictionary];
        [userDict setObject:updatedUser forKey:updatedUser.suid];
        [self.repository sendSMSToUsers:userDict sms: @DEFAULT_UPDATION_USERS_TEXT];
    }

    
}


//return NO and give shake effect if the textField is empty
-(BOOL) isTextFieldCorrect : (UITextField*) textField default : (NSString*) defaultText{
    bool isValidTextField = YES;
    NSString* name = [textField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([name isEqualToString:@""] || [name isEqualToString:defaultText]){
        updateDirection = 1;
        updateShakes = 0;
        [self updateShake :  textField];
        textField.backgroundColor = [UIColor colorWithRed:0.9 green:0.2 blue:0.1 alpha:0.3];
        isValidTextField =  NO;
    }
    return isValidTextField;
}

//shake animation
-(void)updateShake:(UIView *)theOneYouWannaShake
{
    [UIView animateWithDuration:0.03 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*updateDirection, 0);
     }
                     completion:^(BOOL finished)
     {
         if(updateShakes >= 10)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             return;
         }
         updateShakes++;
         updateDirection = updateDirection * -1;
         [self updateShake:theOneYouWannaShake];
     }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

@end
