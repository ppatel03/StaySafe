//
//  IconPageViewController.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/19/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
//  Contains the implementation of methods which are responsible to handle Home page events
//

@import CoreLocation;
#import "IconPageViewController.h"

@interface IconPageViewController ()

@end

@implementation IconPageViewController

NSString* const imagePath = @"../images/";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //adding background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light-blue-background-1"]];

    
    //disable back button of registration page
    [self.navigationItem setHidesBackButton:YES animated:YES];
   
}


//set by RegistrationViewcontroller in order to have a single repository instance
- (void) setRepository:(RepositoryModel *)repository{
    _repository = repository;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    if([@"broadcast" caseInsensitiveCompare: segue.identifier] == NSOrderedSame  ){
        // pick up destination view controller from segue object - broadcast
        self.broadcastViewController = segue.destinationViewController;
        [self.broadcastViewController setRepository:self.repository];
        
    } else if([@"safewalk" caseInsensitiveCompare: segue.identifier] == NSOrderedSame  ){
        // pick up destination view controller from segue object - broadcast
        self.safewalkViewController = segue.destinationViewController;
        [self.safewalkViewController setRepository:self.repository];
        
    }else if([@"update" caseInsensitiveCompare: segue.identifier] == NSOrderedSame  ){
        // pick up destination view controller from segue object - broadcast
        self.updateProfileViewController = segue.destinationViewController;
        [self.updateProfileViewController setRepository:self.repository];
        
    }
}

- (IBAction)shareIconButtonAction:(id)sender {
}


@end
