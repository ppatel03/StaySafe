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

double safeWalkLatitude, safeWalkLongitude;

NSString* currentUserId;
UserDetailVO* currentUser;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //loading defaults
    [self loadDefault];
    
    //load gps data
    [self loadGpsParams];
    
    //contact data
    self.contactData = [[NSMutableArray alloc]  init];
    
    //get the nearby users
    [self storeDataOfNearbyUsers];
    
    //fetch the contact information
    [self storeAllContactsInRepository];
    
    NSLog(@"Contacts = %@",self.repository.contactList);
    
    //store the sorted contacts
    [self storeContactsSortedByDistance];
    
    
    //assign the delegate to itself
    self.contactsTableView.delegate = self;
    self.contactsTableView.dataSource = self;
    
    //refresh the table view with new data
    [self.contactsTableView reloadData];
    
    
    //hide the table view to appear as the Select drop down box
    self.contactsTableView.hidden = YES;
}


//set by IconPageViewcontroller in order to have a single repository instance
- (void) setRepository:(RepositoryModel *)repository{
    _repository = repository;
}

-(void) loadDefault{
    //default latitude and longitude - incase GPS is not working
    safeWalkLatitude = [self.repository defaultLatitude];
    safeWalkLongitude = [self.repository defaultLongitude];
    currentUserId = @"678713856";
    currentUser = self.repository.users[currentUserId];
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
    
    
    safeWalkLatitude = location.coordinate.latitude;
    safeWalkLongitude = location.coordinate.longitude;
    
    //update the new location for the user asynchronous location
    NSString* userId = currentUserId;
    [self.repository updateUserLocation:userId lat:safeWalkLatitude long:safeWalkLongitude];
    
    //show the user on the Map with necessary coordinate configs
    [self showUserOnTheMap];
    
    //showing the nearby registered users on the Map along with Annotation
    [self addAnnotationForNearByUsers];
    
    //store the sorted contacts which are new due to location change
    [self storeContactsSortedByDistance];
    
    //refresh the table view with new data
    [self.contactsTableView reloadData];
}

//locating the user on the Map so that user's location can always be shown on the center
-(void) showUserOnTheMap{
    //create the region
    MKCoordinateRegion userRegion;
    //Center
    CLLocationCoordinate2D center;
    center.latitude = safeWalkLatitude;
    center.longitude = safeWalkLongitude;
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
    CLLocation *currentLocationOfUser = [[CLLocation alloc] initWithLatitude:safeWalkLatitude longitude:safeWalkLongitude];
    
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
            //if (![user.suid isEqualToString:currentUserId] )
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
        [self.safewalkMapView removeAnnotations:[self.safewalkMapView annotations]];
        
        //add the new annotations
        [self.safewalkMapView addAnnotations:nearbyUsersLocation];
    }
    
}

- (void) storeDataOfNearbyUsers{
    //current user id
    NSString* userId = currentUserId;
    
    //get the current user
    UserDetailVO* currentUser = self.repository.users[userId];
    
    //Setting the current location
    CLLocation *currentLocationOfUser = [[CLLocation alloc] initWithLatitude:currentUser.latitude longitude:currentUser.longitude];
    
    if([self.repository users] != Nil){
        //looping through the users dictionary and adding annotation for each user
        for (id key in [self.repository users]) {
            UserDetailVO *user = [self.repository users][key];
            
            //the user should not be same as the current user - it will show that current user is nearby to himself :P
            //if (![user.suid isEqualToString:currentUserId] )
            {
                CLLocation *registeredUserLocation = [[CLLocation alloc] initWithLatitude:user.latitude longitude:user.longitude];
                CLLocationDistance distanceBetweenCurrentAndRegisteredUser = [currentLocationOfUser distanceFromLocation:registeredUserLocation];
                user.distanceFromUser =[NSNumber numberWithDouble: distanceBetweenCurrentAndRegisteredUser];
                
                //the registred user is a nearby user if the distance is less than 300 meters
                if (distanceBetweenCurrentAndRegisteredUser < MAX_NEARBY_DISTANCE)
                {
                    //Store these nearby users in the dictionary
                    [self.repository.nearbyUsers setObject:user forKey:user.suid];
                }
            }
            
        }
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

//store the user's contact list into repository
- (void)storeAllContactsInRepository {
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    __block BOOL accessGranted = NO;
    
    if (&ABAddressBookRequestAccessWithCompletion != nil) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    
    else { // We are on iOS 5 or Older
        accessGranted = YES;
        [self.repository storeContactsWithAddressBook:addressBook];
    }
    
    if (accessGranted) {
        [self.repository storeContactsWithAddressBook:addressBook];
    }
}

//operations to handle when safe walk request button is clicked
- (IBAction)onClickSafeWalkRequestButton:(id)sender {
    
    NSString *selectedCellText= [self.contactTableViewButton currentTitle];
    selectedCellText = [selectedCellText  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //perform safe walk sms and insert operation for valid dropdown text
    if ([selectedCellText compare: @DEFAULT_SAFE_WALK_DROPDOWN_TEXT  options:NSCaseInsensitiveSearch] != NSOrderedSame){
        NSArray *selectedCellArray = [selectedCellText componentsSeparatedByString:@" - "];
        
        //we are interested in fetching the phone number
        NSString* phoneNumberForSafeWalkRequest = selectedCellArray[1];
        
        //fetch the user based on phone number
        UserDetailVO* requestedUser = [self.repository getUserBasedOnPhoneNumber:phoneNumberForSafeWalkRequest];
        
        if(requestedUser != nil){
            //first send SMS to the requested user - since its an current user's safety is more important
            NSMutableDictionary* safewalkRequestedUserDictionary = [NSMutableDictionary dictionary];
            [safewalkRequestedUserDictionary setObject:requestedUser forKey:requestedUser.suid];
            
            //current user's name
            NSString* userName = currentUser.name;
            
            //sms message
            NSString* message = [userName stringByAppendingString:DEFAULT_SAFE_WALK_MESSAGE];
            
            //take help of repository to send SMS
            [self.repository sendSMSToUsers:safewalkRequestedUserDictionary sms:message];
            
            //NOW INSERT THE SAFEWALK Data into database
            [self.repository insertUserSafeWalkData:currentUser.suid to: requestedUser.suid ];
        }
        
        
    }
}

//sort the contact list
- (void) storeContactsSortedByDistance{
    
    //clear the inital contacts
    [self.contactData removeAllObjects];
    
    NSMutableDictionary* dict = [self.repository nearbyUsers];
    
    //order the dictionary keys according to the nearby distance
    NSArray *orderedKeys = [dict keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [[obj1 distanceFromUser] compare:[obj2 distanceFromUser]];
    }];
    
    NSLog(@" Ordered Dcitionary%@", orderedKeys);
    
    //looping through the dictionary in iOS
    for(NSString* key in orderedKeys){
        UserDetailVO* user = self.repository.users[key];
        if([self.repository doesContactUserExist : self.repository.contactList byName:user.phone]){
            
            NSString* contactUserData = [@[user.name , user.phone] componentsJoinedByString:@" - "];
            [self.contactData addObject:contactUserData];
        }
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
