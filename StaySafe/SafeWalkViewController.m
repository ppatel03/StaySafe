//
//  SafeWalkViewController.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/5/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import "SafeWalkViewController.h"

@interface SafeWalkViewController ()

@end

@implementation SafeWalkViewController



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

//set by IconPageViewcontroller in order to have a single repository instance
- (void) setRepository:(RepositoryModel *)repository{
    _repository = repository;
}

@end
