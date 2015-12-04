//
//  BroadcastViewController.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/24/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "model/RepositoryModel.h"
#import "Annotation.h"
#import <MapKit/MapKit.h>
#import "UserDetailVO.h"

@import CoreLocation;

@interface BroadcastViewController: UIViewController<CLLocationManagerDelegate>
//set by IconPageViewcontroller in order to have a single repository instance
- (void) setRepository:(RepositoryModel *)repository;

@property (weak, nonatomic) IBOutlet MKMapView *broadcastMapView;
@property (nonatomic , strong) CLLocationManager *mgr;
@property(nonatomic,weak) RepositoryModel *repository;

@end
