//
//  RequestSafeWalkViewController.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/8/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepositoryModel.h"
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "UserDetailVO.h"


@import CoreLocation;

@interface RequestSafeWalkViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

//handle tp CLLocationManager is the central point for configuring the delivery of location
@property (nonatomic , strong) CLLocationManager *mgr;

//handle to the repository responsible for handling the data
@property(nonatomic,weak) RepositoryModel *repository;

//store number of safe walk requests
@property (weak, nonatomic) IBOutlet UILabel *numberOfSafeWalkRequestsLabel;

//select button for dropdown
@property (weak, nonatomic) IBOutlet UIButton *watchSafeWalkButton;

//drop down list showing the list of users who wanted you to watch them walk
@property (weak, nonatomic) IBOutlet UITableView *safeWalkRequestTableView;

@property (weak, nonatomic) IBOutlet MKMapView *watchSafeWalkMapView;


//select to watch your requested user walk
- (IBAction)onSelectWatchSafeWalkButton:(id)sender;

//array which which will hold values to populate data
@property (strong, nonatomic) NSMutableArray* safeWalkUsers;

//dictionary of safe walk requested users for the current user
@property (strong, nonatomic)NSMutableDictionary* safeWalkRequestUsersDict;

@end
