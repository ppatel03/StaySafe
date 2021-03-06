//
//  UserDetailDAO.h - contains the declaration of all the methods used to perform DB operations on
//  user data via REST API using RestApiDAO
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/1/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
//  Declaration file for Data Access Object Design Pattern - provides data access to the repository model by preparing the query with the help of
//  JSONQueryModel and interacting with RESTApiDAO to make Rest api call
//

#import <Foundation/Foundation.h>
#import "RESTApiDAO.h"
#import "JSONQueryModel.h"
#import "UserDetailVO.h"

@interface UserDetailDAO : NSObject

//HAS-A relationship for fetching json POST string and processing JSON
@property (strong,nonatomic) JSONQueryModel* jsonModel;

// contains the handle to RestApiDAO
//operating on the data on the database servers using REST APIs
@property (strong,nonatomic) RESTApiDAO* restAPIDAO;

//  retrieves all the records from the user_detail database
- (NSMutableDictionary*) getAllUserDetails ;

//  asynchronous update to user location
- (void) updateUserLocation : (UserDetailVO*) user;

//  asynchronous update to user's profile
- (void) updateUserProfile : (UserDetailVO*) user;

// aynchronous sending of SMSes to the list of users
- (void) sendSMSToUsers : (NSMutableDictionary*) users sms : (NSString*) message ;

//  insert safewalk request data
- (void) insertUserSafeWalkData : (NSString*) from to : (NSString*) to;

// fetch  all data related to safe walk
- (NSMutableDictionary *) getAllSafeWalkData  ;

//  retrieves user detail record from the user_detail database based on userId
- (UserDetailVO*) getUserFromUserId : (NSString*) userId;

//insert user detail data
- (void) insertUserDataIntoDB: (NSString*)suid name : (NSString*) name email : (NSString*) email
                       phone : (NSString*) phone latitude : (double) latitude longitude :  (double)  longitude;
@end
