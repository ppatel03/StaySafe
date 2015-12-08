//
//  RepositoryModel.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/29/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
// It contains the declaration of methods  querying the data layer and storing the required data
// to map the business entities
//
// Its  a Repository pattern based on the idea of to separate the logic that retrieves the data and
// maps it to the entity model from the business logic that acts on the model.
// Refer https://msdn.microsoft.com/en-us/library/ff649690.aspx for Repository pattern

#import <Foundation/Foundation.h>
#include "InitModel.h"
#include "UserDetailDAO.h"
#include "UserDetailVO.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface RepositoryModel : NSObject

//loading the default parameters
@property (strong,nonatomic) InitModel* defaults;

//HAS-A relationship with UserDetailDAO to load and process user data
@property (strong,nonatomic) UserDetailDAO* userDetailDAO;

//HAS-A NSMutableDictionary of users
@property (strong,nonatomic) NSMutableDictionary* users;

//HAS-A NSMutableDictionary of nearby users
@property (strong,nonatomic) NSMutableDictionary* nearbyUsers;

//holds the contact list of the users
@property (strong,nonatomic) NSMutableArray *contactList;


//default getters and setters
@property  double defaultLatitude;
@property  double defaultLongitude;

//stores default latitude and longitude
-(void) storeDefaultLatitudeAndLongitude;

//retreives all the users details from the database
-(NSMutableDictionary*) getAllUserDetails;

//update the user location
-(void) updateUserLocation : (NSString*) userId lat : (double)latitude long : (double) longitude;

// aynchronous sending of SMSes to the list of users
- (void) sendSMSToUsers : (NSMutableDictionary*) users sms : (NSString*) message ;

// Get and store the contacts into contactList.
- (void)storeContactsWithAddressBook:(ABAddressBookRef )addressBook;

//  insert safewalk request data
- (void) insertUserSafeWalkData : (NSString*) from to : (NSString*) to;

//get the user based on phone number
- (UserDetailVO*) getUserBasedOnPhoneNumber : (NSString*) phoneNumber;

//check if the phone number exists in the contact list
- (BOOL)doesContactUserExist:(NSMutableArray *)array byName:(NSString *)theName;


@end
