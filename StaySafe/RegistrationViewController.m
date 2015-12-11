//
//  RegistrationViewController.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/9/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
int direction;
int shakes;
UserDetailVO* user;
NSString* rightCode;
NSString* enteredCode;
bool isNewUser;

- (void)viewDidLoad {
    
    //temporary logic to show registration page
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
    
    //adding background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light-blue-background-1"]];
    //rounded corners
    self.sendSMSButton.layer.cornerRadius = 10; // this value vary as per your desire
    self.sendSMSButton.clipsToBounds = YES;
    self.registerButton.layer.cornerRadius = 10; // this value vary as per your desire
    self.registerButton.clipsToBounds = YES;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set text field to default colors
    [self setTextFieldToDefaultColors];
    
    //load the defaults in the repository
    [self.repository storeDefaultLatitudeAndLongitude];
    
    //call the repository to retreive the user details
    [self.repository getAllUserDetails];
    
    user = [self.repository loadDataFromPList];
    
    
    if(user != nil){
        //call segue programmatically
        [self performSegueWithIdentifier:@"register" sender:self];
        //not a new user
        isNewUser = NO;
        
    } else {
        user = [[UserDetailVO alloc] init];
        //it is a new user
        isNewUser = YES;
        
    }
    
}

// We override the default auto-generated getter for property model (which just
// returns the current value of ivar _model;), so we can do LAZY INSTANTIATION
// of our model object of class Model; doing lazy instantiation in getters
// is good practice, as objects won't be created until they are needed).  Note
// that we must use ivar _model here (using self.model would cause recursive call!)
- (RepositoryModel *) repository
{
    if (! _repository)
        _repository = [[RepositoryModel alloc] init];
    
    return  _repository;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)onClickSendSMSButton:(id)sender {
    
    user.name = [self.nameTextField text];
    user.email = [self.emailTextField text];
    user.phone = [self.phoneTextField text];
    user.suid = [self.userIdUITextField text];
    
    if([self isTextFieldCorrect:self.phoneTextField default:@"Phone"] &&
       [self isTextFieldCorrect:self.userIdUITextField default:@"Student ID"]){
        //generate random number
        int randomNumber = arc4random_uniform(10000);
        rightCode = [NSString stringWithFormat:@"%i", randomNumber];
        
        //send SMS to user
        NSMutableDictionary* userDict = [NSMutableDictionary dictionary];
        [userDict setObject:user forKey:user.suid];
        //[self.repository sendSMSToUsers:userDict sms:[@DEFAULT_VERIFICATION_USERS_TEXT stringByAppendingString:rightCode]];
    }
    
}

- (IBAction)onClickRegisterButton:(id)sender {
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
// This function can also be called explicitly
//[self performSegueWithIdentifier:@"myIdentifier" sender:self];
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // note which segue chosen (need to know if more than one segue from current view controller)
    NSLog( @"Transition via segue: '%@'", segue.identifier);
    
    
    [super prepareForSegue:segue sender:sender];
    
    //save data into databse and NSUserDefaults for new user
    if(isNewUser){
        //insert user into DB
        [self.repository insertUserUserDetailData:user];
        
        //save the data into plist
        [self.repository saveData:user];
    }
    
    
    if([@"register" caseInsensitiveCompare: segue.identifier] == NSOrderedSame  ){
        // pick up destination view controller from segue object - broadcast
        self.iconPageViewController = segue.destinationViewController;
        [self.iconPageViewController setRepository:self.repository];
        
    }
    
}

//default colors for text field
-(void) setTextFieldToDefaultColors{
    self.nameTextField.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.3];
    self.emailTextField.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.3];
    self.phoneTextField.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.3];
    self.userIdUITextField.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.3];
    self.verficationCodeTextField.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.3];
    
}

//form validity will decide the seque to proceed
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    //set text field to default colors
    [self setTextFieldToDefaultColors];
    
    bool proceedSeque = YES;
    user.name = [self.nameTextField text];
    user.email = [self.emailTextField text];
    user.phone = [self.phoneTextField text];
    user.suid = [self.userIdUITextField text];
    enteredCode = [self.verficationCodeTextField text];
    
    if(!([self isTextFieldCorrect:self.nameTextField default:@"Name"] &
         [self isTextFieldCorrect:self.emailTextField default:@"Email"] &
         [self isTextFieldCorrect:self.phoneTextField default:@"Phone"] &
         [self isTextFieldCorrect:self.userIdUITextField default:@"Student ID"] &
         [self isTextFieldCorrect:self.verficationCodeTextField default:@"Code"])){
        proceedSeque = NO;
    }
    
    if(![enteredCode isEqualToString: rightCode]){
        direction = 1;
        shakes = 0;
        [self shake :  self.verficationCodeTextField];
        self.verficationCodeTextField.backgroundColor = [UIColor colorWithRed:0.9 green:0.2 blue:0.1 alpha:0.3];
        proceedSeque = NO;
    }
    
    return proceedSeque;
}

//return NO and give shake effect if the textField is empty
-(BOOL) isTextFieldCorrect : (UITextField*) textField default : (NSString*) defaultText{
    bool isValidTextField = YES;
    NSString* name = [textField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([name isEqualToString:@""] || [name isEqualToString:defaultText]){
        direction = 1;
        shakes = 0;
        [self shake :  textField];
        textField.backgroundColor = [UIColor colorWithRed:0.9 green:0.2 blue:0.1 alpha:0.3];
        isValidTextField =  NO;
    }
    return isValidTextField;
}

//shake animation
-(void)shake:(UIView *)theOneYouWannaShake
{
    [UIView animateWithDuration:0.03 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*direction, 0);
     }
                     completion:^(BOOL finished)
     {
         if(shakes >= 10)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             return;
         }
         shakes++;
         direction = direction * -1;
         [self shake:theOneYouWannaShake];
     }];
}



@end
