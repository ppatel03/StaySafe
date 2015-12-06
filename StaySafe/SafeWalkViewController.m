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

double latitude, longitude;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    //loading defaults
    [self loadDefault];
    
    //load gps data
    [self loadGpsParams];
    
    //contact data
    self.contactData = [[NSArray alloc] initWithObjects:@"Value1",@"Value2",@"Value3", nil];
    
    //assign the delegate to itself
    self.contactsTableView.delegate = self;
    self.contactsTableView.dataSource = self;
    
    //hide the table view to appear as the Select drop down box
    self.contactsTableView.hidden = YES;
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
    NSString* userId = @"678713856";
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
    [self.safewalkMapView setRegion:userRegion animated:YES];
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
        [self.safewalkMapView removeAnnotations:[self.safewalkMapView annotations]];
        
        //add the new annotations
        [self.safewalkMapView addAnnotations:nearbyUsersLocation];
    }
    
}







// total number of rows in the tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contactData count];
}


//assings each row of the table view as contact list's value
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"SimpleTableItem";
    
    
    // check if we can reuse a cell from row that just went off screen
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // create new cell, if needed
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // set text attibute of cell
    cell.textLabel.text = [self.contactData objectAtIndex:indexPath.row];
    
    // set accessory type to standard detail disclosure indicator
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//when a row cell is selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.contactsTableView cellForRowAtIndexPath:indexPath];
    
    [self.contactTableViewButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
    self.contactsTableView.hidden = YES;
}

//to appear and reappear dropdown menu when clicked
- (IBAction)contactTableViewButtonAction:(id)sender {
    if(self.contactsTableView.hidden == YES){
        self.contactsTableView.hidden = NO;
    } else {
        self.contactsTableView.hidden =YES;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
