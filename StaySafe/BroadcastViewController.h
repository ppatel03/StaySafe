//
//  BroadcastViewController.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/24/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "model/RepositoryModel.h"
@import CoreLocation;

@interface BroadcastViewController: UIViewController<CLLocationManagerDelegate>
//set by IconPageViewcontroller in order to have a single repository instance
- (void) setRepository:(RepositoryModel *)repository;
@end
