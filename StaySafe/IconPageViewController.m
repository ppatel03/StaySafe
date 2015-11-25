//
//  IconPageViewController.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/19/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
@import CoreLocation;
#import "IconPageViewController.h"

@interface IconPageViewController ()


@property (weak, nonatomic) IBOutlet UIButton *shareIconButton;

@property (weak, nonatomic) IBOutlet UIButton *broadcastIconButton;
@property (weak, nonatomic) IBOutlet UIButton *helpIconButton;

@property (weak, nonatomic) IBOutlet UIButton *safewalkIconButton;
- (IBAction)shareIconButtonAction:(id)sender;

@end

@implementation IconPageViewController

NSString* const imagePath = @"../images/";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
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

- (IBAction)shareIconButtonAction:(id)sender {
}
@end
