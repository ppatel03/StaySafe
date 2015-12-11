//
//  RequestSafeWalkViewController.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/8/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import "RequestSafeWalkViewController.h"

@interface RequestSafeWalkViewController ()

@end

@implementation RequestSafeWalkViewController

//getters and setters generators for dictionary for safe walk requested users for the current user
@synthesize safeWalkRequestUsersDict;
//getters and setters generators for the array which holds value for drop down cells
@synthesize safeWalkUsers;


NSString* currentUserIdForSafeWalk;
UserDetailVO* currentUserForSafeWalk;
UserDetailVO* currentlyWatchedUser;
NSTimer* timer;
bool isAnnotationShowingUpFirstTime;
UIColor *currentColor;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //loading defaults
    [self loadDefault];
    
    //adding background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light-blue-background-1"]];
    //rounded corners
    self.watchSafeWalkButton.layer.cornerRadius = 10; // this value vary as per your desire
    self.watchSafeWalkButton.clipsToBounds = YES;
    //rounded corners
    self.safeWalkRequestTableView.layer.cornerRadius = 10; // this value vary as per your desire
    self.safeWalkRequestTableView.clipsToBounds = YES;
    
    //fetch and store safewalk related information
    [self.repository storeSafeWalkRelatedInformation];
    
    // Storing the count
    int count = [self.repository.safeWalkRequestedFromUsers[currentUserIdForSafeWalk] count];
    NSString* countString =  [NSString stringWithFormat:@"%d", count ];
    [self.numberOfSafeWalkRequestsLabel setText:countString];
    
    //store the data in safe walker requested user
    [self loadDataIntoDropDownList];
    
    //show requested users location on the Map
    UserDetailVO* firstUser = [self getFirstRandomUserFromDictionary];
    
    //adding the map view delegate to itself
    [self.watchSafeWalkMapView.delegate   self];

    // show user on map
    [self showUserOnTheMap:firstUser.latitude long:firstUser.longitude];

    //add annotation for those users
    [self addAnnotationForSafeWalkRequestedUsers];
    
   
    //assign the delegate to itself
    self.safeWalkRequestTableView.delegate = self;
    self.safeWalkRequestTableView.dataSource = self;
    
    //refresh the table view with new data
    [self.safeWalkRequestTableView reloadData];
    
    //hide the table view to appear as the Select drop down box
    self.safeWalkRequestTableView.hidden = YES;
}

//set by SafeWalkViewcontroller in order to have a single repository instance
- (void) setRepository:(RepositoryModel *)repository{
    _repository = repository;
}

-(void) loadDefault{
    // intialize the dictionary for safe walk requested users for the current user
    safeWalkRequestUsersDict = [NSMutableDictionary dictionary];
    //initialize the array which holds value for drop down cells
    safeWalkUsers = [[NSMutableArray alloc]  init];
    
    // current user data
    currentUserIdForSafeWalk = [self.repository.currentUser suid];
    currentUserForSafeWalk = self.repository.users[currentUserIdForSafeWalk];
    
    
    //flag for to show dropping pin  animation
    isAnnotationShowingUpFirstTime = YES;
    
    //rdefault color
    currentColor = [UIColor blueColor];
}




//locating the user on the Map so that user's location can always be shown on the center
-(void) showUserOnTheMap : (double) latitude long : (double) longitude{
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
    [self.watchSafeWalkMapView setRegion:userRegion animated:YES];
}

//Showing safe walk requested users on the Map along with the annotation
-(void) addAnnotationForSafeWalkRequestedUsers{
    //Create the location array for storing multiple annotations
    NSMutableArray* safeWalkUsersLocation = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D location;
    Annotation* nearbyUsersAnnotation;
    
    if(self.safeWalkRequestUsersDict != Nil){
        //looping through the users dictionary and adding annotation for each user
        for (id key in self.safeWalkRequestUsersDict) {
            UserDetailVO *user = self.safeWalkRequestUsersDict[key];
            
            //Show these users on the Map along with annotation
            nearbyUsersAnnotation = [[Annotation alloc]init];
            location.latitude = user.latitude;
            location.longitude = user.longitude;
            nearbyUsersAnnotation.coordinate = location;
            nearbyUsersAnnotation.title = user.name;
            nearbyUsersAnnotation.subtitle = [@"Student ID : " stringByAppendingString:user.suid];
            
            [safeWalkUsersLocation addObject:nearbyUsersAnnotation];
            
        }
    }
    
    //adding the set  annotations to Mapview
    if([safeWalkUsersLocation count] > 0){
        // remove all the existing annotations of nearby users
        [self.watchSafeWalkMapView removeAnnotations:[self.watchSafeWalkMapView annotations]];
        
        //add the new annotations
        [self.watchSafeWalkMapView addAnnotations:safeWalkUsersLocation];
    }
    
}


//select to watch your requested user walk
- (IBAction)onSelectWatchSafeWalkButton:(id)sender {
    if(self.safeWalkRequestTableView.hidden == YES){
        self.safeWalkRequestTableView.hidden = NO;
    } else {
        self.safeWalkRequestTableView.hidden =YES;
    }
    
}

// total number of rows in the tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.safeWalkUsers count];
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
    cell.textLabel.text = [self.safeWalkUsers objectAtIndex:indexPath.row];
    
    // set accessory type to standard detail disclosure indicator
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//when a row cell is selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //invalidate the current timer
    [timer invalidate];
    timer = nil;
    
    UITableViewCell* cell = [self.safeWalkRequestTableView cellForRowAtIndexPath:indexPath];
    
    [self.watchSafeWalkButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
    self.safeWalkRequestTableView.hidden = YES;
    
    NSString *selectedCellText= [self.watchSafeWalkButton currentTitle];
    selectedCellText = [selectedCellText  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //perform safe walk sms and insert operation for valid dropdown text
    if ([selectedCellText compare: @DEFAULT_REQUESTED_SAFE_WALK_USERS_TEXT  options:NSCaseInsensitiveSearch] != NSOrderedSame){
        NSArray *selectedCellArray = [selectedCellText componentsSeparatedByString:@" - "];
        
        //we are interested in fetching the phone number
        NSString* phoneNumberForSafeWalkRequest = selectedCellArray[1];
        
        //fetch the user based on phone number
        UserDetailVO* requestedUser = [self.repository getUserBasedOnPhoneNumber:phoneNumberForSafeWalkRequest];
        
        if(requestedUser != nil){
            //set it to currently watched user to be used by NSTimer
            currentlyWatchedUser = requestedUser;
            
            //show the selected user to the center of the Map
            [self showUserOnTheMap:requestedUser.latitude long:requestedUser.longitude];
            
            //current user's name
            NSString* userName = currentUserForSafeWalk.name;
            
            //sms message
            NSString* message = [@[userName, DEFAULT_WATCH_WALK_MESSAGE] componentsJoinedByString:@" "];
            
            //create the dictionary for sending SMS to these requested users since the current user is watching them walk
            NSMutableDictionary* safewalkRequestingUserDictionary = [NSMutableDictionary dictionary];
            [safewalkRequestingUserDictionary setObject:requestedUser forKey:requestedUser.suid];
            
            //take help of repository to send SMS
            [self.repository sendSMSToUsers:safewalkRequestingUserDictionary sms:message];
            
            //generating random color to show on the map
            CGFloat hue = ( arc4random() % 256 / 256.0 ); // 0.0 to 1.0
            CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0, away from white
            CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0, away from black
            UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
            currentColor = color;
            
            //assigning the timer
            timer = [NSTimer scheduledTimerWithTimeInterval:20.0
                                             target:self
                                           selector:@selector(showUpdatedLocationOfUserPeriodically  )
                                           userInfo:nil
                                            repeats:YES];
            

        }
        
        
    }
    
    
}

//control the timer to update the location
-(void) showUpdatedLocationOfUserPeriodically  {
    NSString* requestedUserID = currentlyWatchedUser.suid;
    UserDetailVO* updatedRequestedUser = [self.repository getUserInDBFromUserID:requestedUserID];
    if(updatedRequestedUser != nil){
        //update the new currently watched user
        currentlyWatchedUser = updatedRequestedUser;
        //updating local dictionary
        [safeWalkRequestUsersDict setObject:updatedRequestedUser forKey:requestedUserID];
        // drawing lines for tracing the path of the user
        [self showLines:updatedRequestedUser.coordinates];
        //flag for to show dropping pin  animation
        isAnnotationShowingUpFirstTime = NO;
        //update the annotations on Mapview
        [self addAnnotationForSafeWalkRequestedUsers];
        

    }
}


// drawing lines for tracing the path of the user
- (void)showLines : (NSMutableArray*) coodinates {
    CLLocationCoordinate2D *pointsCoordinate = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * [coodinates count]);
    
    int count = 0;
    
    for (NSMutableArray* coordinate in coodinates) {
        pointsCoordinate[count++] = CLLocationCoordinate2DMake([coordinate[0] doubleValue], [coordinate[1] doubleValue]);
    }
    
    /*
     pointsCoordinate[0] = CLLocationCoordinate2DMake(43.0412, -76.1195);
     pointsCoordinate[1] = CLLocationCoordinate2DMake(43.04159, -76.1206);
     pointsCoordinate[2] = CLLocationCoordinate2DMake(43.0413, -76.1299);
    */
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:pointsCoordinate count:count];
    free(pointsCoordinate);
    [self.watchSafeWalkMapView addOverlay:polyline];
    
}

// overlay for drawing the path on the Map
- (MKPolylineRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{
    
    // create a polylineView using polyline overlay object
    MKPolylineRenderer *polylineView = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    
    // Custom polylineView
    polylineView.strokeColor =  currentColor;
    polylineView.lineWidth = 2.0;
    polylineView.alpha = 0.8;
    
    return polylineView;
}


// adding pins to the Map view
- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    NSString *annotationIdentifier = @"PinViewAnnotation";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *) [self.watchSafeWalkMapView
                                                            dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];    if (!pinView)
    {
        pinView = [[MKPinAnnotationView alloc]
                    initWithAnnotation:annotation
                    reuseIdentifier:annotationIdentifier] ;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
            // create color
            UIColor *color = [UIColor colorWithRed:10/255.0
                                             green:200/255.0
                                              blue:15/255.0
                                             alpha:1];
            
            [pinView setPinTintColor:color];
        }
       
       
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        UIImageView *imageIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lion-king" ]];
        pinView.leftCalloutAccessoryView = imageIconView;
        
    }
    else
    {
        
        pinView.animatesDrop = isAnnotationShowingUpFirstTime;
        
        pinView.annotation = annotation;
    }
    return pinView;
    
}



//load data into safe walk requested users array to populate into the dropdown
-(void) loadDataIntoDropDownList{
    NSMutableArray* safeRequestedUserIdArray = self.repository.safeWalkRequestedToUsers[currentUserIdForSafeWalk];
    for (NSString* userId in safeRequestedUserIdArray) {
        UserDetailVO* requestedUser =self.repository.users[userId];
        if (requestedUser != nil) {
            [self.safeWalkRequestUsersDict setObject:requestedUser  forKey:userId];
            NSString* userCellText = [@[requestedUser.name,requestedUser.phone] componentsJoinedByString:@" - "];
            [self.safeWalkUsers addObject:userCellText];
        }
        
    }
}

//get any first entry in the Dictionary to center the location on the Map
-(UserDetailVO*) getFirstRandomUserFromDictionary{
    NSArray *values = [self.safeWalkRequestUsersDict allValues];
    
    if ([values count] != 0){
        UserDetailVO* user = [values objectAtIndex:0];
        return user;
    } else{
        return nil;
    }
}



// Dispose of any resources that can be recreated.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
