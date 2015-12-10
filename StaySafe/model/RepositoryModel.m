//
//  RepositoryModel.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/29/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
// It contains the declaration of methods  querying the data layer and storing the required data
// to map the business entities
//
// Also comntains the logic of adding the contact the numbers to the contact list - taken from
// https://www.dropbox.com/s/i6bymuddrwxbmkp/AddressBook.zip?dl=0 which is created
// by JK on 01/08/13.
//  Copyright (c) 2013 Fafadia Tech, Mumbai. All rights reserved.
//
// Its  a Repository pattern based on the idea of to separate the logic that retrieves the data and
// maps it to the entity model from the business logic that acts on the model.
// Refer https://msdn.microsoft.com/en-us/library/ff649690.aspx for Repository pattern

#import "RepositoryModel.h"


@interface RepositoryModel ()
@end

@implementation RepositoryModel

//getters and setters generators for default latitude
@synthesize defaultLatitude;
//getters and setters generators for default longitude
@synthesize defaultLongitude;
//getters and setters generators for dictionary of nearby users
@synthesize nearbyUsers;
//getters and setters generators for dictionary of safewalk requested From users
@synthesize safeWalkRequestedFromUsers;
//getters and setters generators for dictionary of safewalk requested To users
@synthesize safeWalkRequestedToUsers;
//current logged in user
@synthesize currentUser;



//default constructor
- (id) init
{
    if ( self = [super init] )
    {
        //initialize current logged in user
        currentUser = [[UserDetailVO alloc] init];
        // intialize the dictionary for nearby users
        nearbyUsers = [NSMutableDictionary dictionary];
        // intialize the dictionary for safewalk requested From users
        safeWalkRequestedFromUsers = [NSMutableDictionary dictionary];
        // intialize the dictionary for safewalk requested To users
        safeWalkRequestedToUsers = [NSMutableDictionary dictionary];
        
    }
    return self;
}

/* =========== LOGIC of OVERRIDDING default auto-generated getter STARTS HERE =============== */

// We override the default auto-generated getter for property model (which just
// returns the current value of ivar _model;), so we can do LAZY INSTANTIATION
// of our model object of class Model; doing lazy instantiation in getters
// is good practice, as objects won't be created until they are needed).  Note
// that we must use ivar _model here (using self.model would cause recursive call!)
//1. defaults
- (InitModel *) defaults
{
    if (!_defaults)
        _defaults = [[InitModel alloc] init];
    
    return _defaults;
}



//3. userDetailDAO
- (UserDetailDAO *) userDetailDAO
{
    if (!_userDetailDAO)
        _userDetailDAO = [[UserDetailDAO alloc] init];
    
    return _userDetailDAO;
}

/* =========== LOGIC of OVERRIDDING default auto-generated getter ENDS HERE =============== */


//stores default latitude and longitude
-(void) storeDefaultLatitudeAndLongitude{
    self.defaultLatitude = self.defaults.getDefaultLatitude;
    self.defaultLongitude = self.defaults.getDefaultLongitude;
}

//retreives all the users details from the database
-(NSMutableDictionary*) getAllUserDetails{
    
    //calling the REST API layer
    self.users = [self.userDetailDAO getAllUserDetails];
    
    return self.users;
}

//retreives all the users details from the database
-(UserDetailVO*) getUserInDBFromUserID : (NSString*) userID{
    UserDetailVO* oldUser = self.users[userID];
    
    //calling the REST API layer
    UserDetailVO* updatedUser = [self.userDetailDAO getUserFromUserId:userID];
    
    //copy the old coordinate data
    updatedUser.coordinates = oldUser.coordinates;
    
    //update coordinate Data
    updatedUser = [self updateCoordinateData:oldUser newUser:updatedUser];
    
    //copy the new user details into users if available - THIS IS OBVIOUS
    if (self.users[userID] != nil) {
        [self.users setObject:updatedUser forKey:userID];
    }
    //copy the new user details into nearby users if available
    if (self.nearbyUsers[userID] != nil) {
        [self.nearbyUsers setObject:updatedUser forKey:userID];
    }
   
    return updatedUser;
}

//updates the coordinate data of the user
- (UserDetailVO*) updateCoordinateData : (UserDetailVO*) oldUser newUser : (UserDetailVO*) updatedUser{
    //storing cordinate data if location of user is changed make sure you are not storing the same location
    if (!(oldUser.latitude == updatedUser.latitude && oldUser.longitude == updatedUser.longitude))
    {
        NSMutableArray* OldCoordinate = [[NSMutableArray alloc]  init] ;
        [OldCoordinate addObject:[NSNumber numberWithDouble :oldUser.latitude]];
        [OldCoordinate addObject:[NSNumber numberWithDouble :oldUser.longitude]];
        
        
        NSMutableArray* coordinate = [[NSMutableArray alloc]  init] ;
        [coordinate addObject:[NSNumber numberWithDouble : updatedUser.latitude]];
        [coordinate addObject:[NSNumber numberWithDouble : updatedUser.longitude]];
        
        
        if(updatedUser.coordinates == nil){
            NSMutableArray* coordinates = [[NSMutableArray alloc]  init] ;
            [coordinates addObject:OldCoordinate];
            [coordinates addObject:coordinate];
            updatedUser.coordinates = coordinates;
            
        } else{
            NSMutableArray* coordinates = updatedUser.coordinates;
            [coordinates addObject:coordinate];
            updatedUser.coordinates = coordinates;
            
        }
    }
    
    return updatedUser;
}




//update the user location
-(void) updateUserLocation : (NSString*) userId lat : (double)latitude long : (double) longitude{
    UserDetailVO *updatedUser = self.users[userId];
    
    if(updatedUser != nil){
        //update the user's location only
        updatedUser.latitude = latitude;
        updatedUser.longitude = longitude;
        
        //aynchronous call to update the user location
        [self.userDetailDAO updateUserLocation:updatedUser];
        
        // update the user location in the repository
        [self.users setObject:updatedUser forKey:userId];
    } else{
        NSLog(@"user not found to update the location");
    }
}

// aynchronous sending of SMSes to the list of users
- (void) sendSMSToUsers : (NSMutableDictionary*) users sms : (NSString*) message {
    
    //asynchronous call to send SMS to all users one by one through REST APIs
    [self.userDetailDAO sendSMSToUsers:users sms:message];
}

//  insert safewalk request data
- (void) insertUserSafeWalkData : (NSString*) from to : (NSString*) to{
    
    //asynchronous call to inserrt user's safewalk data through REST APIs
    [self.userDetailDAO insertUserSafeWalkData:from to:to];
    
}

//  insert user detail data
- (void) insertUserUserDetailData :( UserDetailVO*) user{
    
    //asynchronous call to inserrt user's safewalk data through REST APIs
    [self.userDetailDAO insertUserDataIntoDB:user.suid name:user.name email:user.email phone:user.phone latitude:user.latitude longitude:user.longitude];
    
    //adding this user to the repository
    [self.users setValue:user forKey:user.suid];
}

//update the user profile
- (void) updateCurrentUser : (UserDetailVO*) updatedUser{
    
    //update the user profile
    [self.userDetailDAO updateUserProfile:updatedUser];
    
    //adding this user to the repository
    [self.users setValue:updatedUser forKey:updatedUser.suid];
}



// Get and store the contacts into contactList.
- (void)storeContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    
    self.contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++) {
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
        }
        
        //For Phone number
        for (int i=0; i < ABMultiValueGetCount(phones); i++) {
            CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phones, i);
            CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phones, i);
            
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                [dOfPerson setObject:(__bridge NSString *)currentPhoneValue forKey:@"mobileNumber"];
                NSString* numberString = dOfPerson[@"mobileNumber"];
                numberString = [[numberString componentsSeparatedByCharactersInSet:
                                 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                [dOfPerson setObject:numberString forKey:@"phone"];
            }
            
            if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                [dOfPerson setObject:(__bridge NSString *)currentPhoneValue forKey:@"homeNumber"];
                NSString* numberString = dOfPerson[@"homeNumber"];
                numberString = [[numberString componentsSeparatedByCharactersInSet:
                                 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                [dOfPerson setObject:numberString forKey:@"phone"];
                
            }
            
            CFRelease(currentPhoneLabel);
            CFRelease(currentPhoneValue);
        }
        CFRelease(phones);
        
        [self.contactList addObject:dOfPerson];
        
    }
   
}

//check if the phone number exists in the contact list
- (BOOL)doesContactUserExist:(NSMutableArray *)array byName:(NSString *)theName {
    NSInteger idx = 0;
    for (NSDictionary* dict in array) {
        if ([[dict objectForKey:@"phone"] isEqualToString:theName])
            return YES;
        ++idx;
    }
    return NO;
}

//get the user based on phone number
- (UserDetailVO*) getUserBasedOnPhoneNumber : (NSString*) phoneNumber {
    for (id key in self.users) {
        UserDetailVO* user = self.users[key];
        if([user.phone isEqualToString:phoneNumber] ){
            return user;
        }
    }
    
    return nil;
}

//store the data containing safewalk related information
- (void) storeSafeWalkRelatedInformation {
    //very important to remove all remove all the exisiting entries in the dictionary
    [self.safeWalkRequestedFromUsers removeAllObjects];
    [self.safeWalkRequestedToUsers removeAllObjects];

    NSMutableDictionary* jsonDictionary = [self.userDetailDAO getAllSafeWalkData];
    
    //using jsonDictionary to store safe walk information of the form  from --- [to] and to --- [from]:
    if ([jsonDictionary isKindOfClass:[NSMutableDictionary class]]){
        NSArray *userDictionaryArray = jsonDictionary[@"documents"];
        if ([userDictionaryArray isKindOfClass:[NSArray class]]){
            for (NSDictionary *dictionary in userDictionaryArray) {
                
                NSString* fromId = [dictionary objectForKey:@"from"];
                NSString* toId= [dictionary objectForKey:@"to"];
                
                // store data in safeWalkFromUsers
                if(self.safeWalkRequestedFromUsers[fromId] == nil){
                    NSMutableArray* safeWalkToArray = [[NSMutableArray alloc]  init];
                    [safeWalkToArray addObject:toId];
                    [self.safeWalkRequestedFromUsers setObject:safeWalkToArray forKey:fromId];
                } else{
                    NSMutableArray* safeWalkToArray = self.safeWalkRequestedFromUsers[fromId];
                    [safeWalkToArray addObject:toId];
                    [self.safeWalkRequestedFromUsers setObject:safeWalkToArray forKey:fromId];
                }
                
                // store data in safeWalkToUsers
                if(self.safeWalkRequestedToUsers[toId] == nil){
                    NSMutableArray* safeWalkFromArray = [[NSMutableArray alloc]  init];
                    [safeWalkFromArray addObject:fromId];
                    [self.safeWalkRequestedToUsers setObject:safeWalkFromArray forKey:toId];
                } else{
                    NSMutableArray* safeWalkFromArray = self.safeWalkRequestedToUsers[toId];
                    [safeWalkFromArray addObject:fromId];
                    [self.safeWalkRequestedToUsers setObject:safeWalkFromArray forKey:toId];
                }
                
                
            }
        }
    }

}

//saving data into NSUserDefaults to avoid user logging in again
- (void) saveData : (UserDetailVO*) user{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:user.suid forKey:@"user"];
    UserDetailVO* registredUser = self.users[user.suid];
    currentUser = registredUser;
}

//load data from NSUserDefaults to avoid user registering in or login in again
-(UserDetailVO*) loadDataFromPList {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *userId = [prefs stringForKey:@"user"];
    UserDetailVO* user = self.users[userId];
    currentUser = user;
    return user;
}


@end
