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


//default constructor
- (id) init
{
    if ( self = [super init] )
    {
        // intialize the dictionary for nearby users
        nearbyUsers = [NSMutableDictionary dictionary];
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




@end
