//
//  SafeWalkViewController.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/5/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
//  contains the declaration of methods for implementing SAFE WALK functionality. Displays the nearby contacts sorted according to distance
//

#import <UIKit/UIKit.h>
#import "RepositoryModel.h"
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "UserDetailVO.h"
#import "RequestSafeWalkViewController.h"


@import CoreLocation;


@interface SafeWalkViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate,CLLocationManagerDelegate>

//handle tp CLLocationManager is the central point for configuring the delivery of location
@property (nonatomic , strong) CLLocationManager *mgr;

//handle to the repository responsible for handling the data
@property(nonatomic,weak) RepositoryModel *repository;
//to populate the nearby contacts
@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
//button to  request safe walk
@property (weak, nonatomic) IBOutlet UIButton *safewalkRequestButton;
//map for showing the nearby users
@property (weak, nonatomic) IBOutlet MKMapView *safewalkMapView;
//array which which will hold values to populate data
@property (strong, nonatomic) NSMutableArray* contactData;
//button which will behave like  a dropdown menu for table view
//to appear and reappear dropdown menu when clicked
@property (weak, nonatomic) IBOutlet UIButton *contactTableViewButton;
//operations to handle when safe walk request button is clicked
- (IBAction)onClickSafeWalkRequestButton:(id)sender;
//handle to RequestSafeWalkViewController for passing the repository via seque
@property (weak, nonatomic) RequestSafeWalkViewController  *requestSafeWalkViewController;
//view the safe walk reuqests
@property (weak, nonatomic) IBOutlet UIButton *viewSafeWalkRequestButton;


@end
