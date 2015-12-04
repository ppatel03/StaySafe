//
//  JSONQueryModel.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/1/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONQueryModel : NSObject
//json search query for fetching all the records
//extern NSString *const SEARCH_QUERY_FOR_ALL_RECORDS;
#define SEARCH_QUERY_FOR_ALL_RECORDS @"{\"query\":\"*\"}"

//get JSON query to retreive all the records from the table
-(NSString*) getJSONQueryForFetchingAllRecords;

//get the mutable dictionary of user id and its object
-(NSMutableDictionary*) getUsersDictionaryFromJson : (NSString*) jsonString;

//get the query for location update
-(NSString*) getJSONQueryForLocationUpdate : (NSString*) userId lat : (double) latitude long : (double) longitude;

@end
