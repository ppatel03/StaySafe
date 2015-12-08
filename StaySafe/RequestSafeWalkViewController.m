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




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //loading defaults
    [self loadDefault];
    
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
    currentUserIdForSafeWalk = @"678713856";
    currentUserForSafeWalk = self.repository.users[currentUserIdForSafeWalk];
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
            
            [self showUserOnTheMap:requestedUser.latitude long:requestedUser.longitude];
        }
        
        
    }
    
    
}

//load data into safe walk requested users array to populate into the dropdown
-(void) loadDataIntoDropDownList{
    NSMutableArray* safeRequestedUserIdArray = self.repository.safeWalkRequestedFromUsers[currentUserIdForSafeWalk];
    for (NSString* userId in safeRequestedUserIdArray) {
        UserDetailVO* requestedUser =self.repository.users[userId];
        [self.safeWalkRequestUsersDict setObject:requestedUser  forKey:userId];
        NSString* userCellText = [@[requestedUser.name,requestedUser.phone] componentsJoinedByString:@" - "];
        [self.safeWalkUsers addObject:userCellText];
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
