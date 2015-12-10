//
//  BroadcastViewController.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/24/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import "BroadcastViewController.h"

@import CoreLocation;


@interface BroadcastViewController ()

@end

@implementation BroadcastViewController

double latitude, longitude;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    //loading defaults
    [self loadDefault];
    
    //load gps data
    [self loadGpsParams];    
   
    
}

//set by IconPageViewcontroller in order to have a single repository instance
- (void) setRepository:(RepositoryModel *)repository{
    _repository = repository;
}

-(void) loadDefault{
    //default latitude and longitude - incase GPS is not working
    latitude = [self.repository defaultLatitude];
    longitude = [self.repository defaultLongitude];
}

//initializing and enabling the GPS service to implicitly call didUpdateLocation
-(void) loadGpsParams{
    //gpx
    if ( [CLLocationManager locationServicesEnabled] )
    {
        NSLog(@"locationServicesEnabled");
        self.mgr = [[CLLocationManager alloc] init];  // get a location manager
        self.mgr.distanceFilter = 20.0;               // set criterion for location updating
        self.mgr.desiredAccuracy = kCLLocationAccuracyBest; // set criterion for location updating
        self.mgr.delegate =  self; // establish delegate to listen for updates
        if ( [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0 )
        {
            NSLog(@"iOS >= 8.0");
            [self.mgr requestAlwaysAuthorization]; // for permission to use location services whenever the app is running.
        }
        //        if([self.mgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        //            [self.mgr requestAlwaysAuthorization];
        //        }
        // - or -
        //        if([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        //            [self.mgr requestWhenInUseAuthorization];
        //        }
        [self.mgr startUpdatingLocation ];
    }
}



// CLLocationManagerDelegate method that receives location updates
- (void)locationManager: (CLLocationManager *)manager
     didUpdateLocations: (NSArray *)locations
{
    
    NSLog(@"locationManager:didUpdateLocations:");
    CLLocation* location = [locations lastObject];
    NSLog(@"latitude %+.6f, longitude %+.6f\n",location.coordinate.latitude, location.coordinate.longitude);
    
    
    latitude = location.coordinate.latitude;
    longitude = location.coordinate.longitude;
    
    //update the new location for the user asynchronous location
    NSString* userId = [self.repository.currentUser suid];
    [self.repository updateUserLocation:userId lat:latitude long:longitude];
    
    //show the user on the Map with necessary coordinate configs
    [self showUserOnTheMap];
    
    //showing the nearby registered users on the Map along with Annotation
    [self addAnnotationForNearByUsers];
    
}

//locating the user on the Map so that user's location can always be shown on the center
-(void) showUserOnTheMap{
    //create the region
    MKCoordinateRegion userRegion;
    //Center
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    //Span
    MKCoordinateSpan userSpan;
    userSpan.latitudeDelta = THE_SPAN;
    userSpan.longitudeDelta = THE_SPAN;
    //assign the center
    userRegion.center = center;
    userRegion.span = userSpan;
    //set our Mapview
    [self.broadcastMapView setRegion:userRegion animated:YES];
}

//Showing nearby users on the Map along with the annotation
-(void) addAnnotationForNearByUsers{
    //Annotation
    
    //Setting the current location
    CLLocation *currentLocationOfUser = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    //Create the location array for storing multiple annotations
    NSMutableArray* nearbyUsersLocation = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D location;
    Annotation* nearbyUsersAnnotation;
    
    //very important to remove all remove all the exisiting entries in the dictionary of nearby users
    [self.repository.nearbyUsers removeAllObjects];
   
    
    if([self.repository users] != Nil){
        //looping through the users dictionary and adding annotation for each user
        for (id key in [self.repository users]) {
            UserDetailVO *user = [self.repository users][key];
            
            //the user should not be same as the current user - it will show that current user is nearby to himself :P
            //if (![user.suid isEqualToString:@"678713856"] )
            {
                CLLocation *registeredUserLocation = [[CLLocation alloc] initWithLatitude:user.latitude longitude:user.longitude];
                CLLocationDistance distanceBetweenCurrentAndRegisteredUser = [currentLocationOfUser distanceFromLocation:registeredUserLocation];
                user.distanceFromUser =[NSNumber numberWithDouble: distanceBetweenCurrentAndRegisteredUser];

                //the registred user is a nearby user if the distance is less than 300 meters
                 if (distanceBetweenCurrentAndRegisteredUser < MAX_NEARBY_DISTANCE)
                {
                    //Store these nearby users in the dictionary
                    [self.repository.nearbyUsers setObject:user forKey:user.suid];
                    
                    //Show these users on the Map along with annotation
                    nearbyUsersAnnotation = [[Annotation alloc]init];
                    location.latitude = user.latitude;
                    location.longitude = user.longitude;
                    nearbyUsersAnnotation.coordinate = location;
                    nearbyUsersAnnotation.title = user.name;
                    nearbyUsersAnnotation.subtitle = [@"Student ID : " stringByAppendingString:user.suid];
                    [nearbyUsersLocation addObject:nearbyUsersAnnotation];
                }
            }
            
        }
    }
    
    //adding the set  annotations to Mapview
    if([nearbyUsersLocation count] > 0){
        // remove all the existing annotations of nearby users
        [self.broadcastMapView removeAnnotations:[self.broadcastMapView annotations]];
        
        //add the new annotations
        [self.broadcastMapView addAnnotations:nearbyUsersLocation];
    }
    
}



// It does the function to dispose of any resources that can be recreated.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// when the user clicks on broadcast alert button
- (IBAction)onClickBroadcastAlertButton:(id)sender {
    
    //message from broadcast text field
    NSString* message = [self.broadcastMessageText text];
    
    //show the default message if the text field is empty. Case when user uses the App in emergency and do not have time to wirte the message
    if (message == nil) {
        message = DEFAULT_ALERT_MESSAGE ;
    }
    
    //trimming the alert message
    NSString *trimmedString = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //delegating the task to repository to take care of SMS sending to nearby users
    [self.repository sendSMSToUsers:self.repository.nearbyUsers sms:trimmedString];

}

//clear the text field when you start editing
- (void) textViewDidBeginEditing:(UITextView *) textView {
    [textView setText:@""];
}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
