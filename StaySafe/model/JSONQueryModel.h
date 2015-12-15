//
//  JSONQueryModel.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/1/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
//  Contains the declaration of methods responsible for generating JSON query to make it helpful for REST API call
//

#import <Foundation/Foundation.h>

@interface JSONQueryModel : NSObject
//json search query for fetching all the records
//extern NSString *const SEARCH_QUERY_FOR_ALL_RECORDS;
#define SEARCH_QUERY_FOR_ALL_RECORDS @"{\"query\":\"*\",\"docs\":1000}"

//get JSON formatted query to retreive all the records from the table
-(NSString*) getJSONQueryForFetchingAllRecords;

//get the mutable dictionary of user id and its object
-(NSMutableDictionary*) getUsersDictionaryFromJson : (NSString*) jsonString;

//get the json formatted query for location update
-(NSString*) getJSONQueryForLocationUpdate : (NSString*) userId lat : (double) latitude long : (double) longitude;

//get the  formatted query for text smses
-(NSString*) getQueryForSendingTextSMS : (NSString*) phone  sms : (NSString*) message ;

//get the query for safewalk update
-(NSString*) getJSONQueryForSafeWalkInsert  : (NSString*) from long : (NSString*) to;

//get JSON formatted query to retreive user detail  record from based  on  user id
-(NSString*) getJSONQueryForFetchingUserFromId : (NSString*) userId;

//get the query for user detail insert
-(NSString*) getJSONQueryForUserInsert : (NSString*)suid name : (NSString*) name email : (NSString*) email
                                 phone : (NSString*) phone latitude : (double) latitude longitude : (double) longitude;

//get the query for user profile update
-(NSString*) getJSONQueryForUserProfileUpdate : (NSString*) userId name : (NSString*) name email : (NSString*) email;


@end
