//
//  JSONQueryModel.m - contains the implementation for preparing JSON input for REST POST calls and
//  processing the JSON response
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/1/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import "JSONQueryModel.h"

@implementation JSONQueryModel

//default constructor
- (id) init
{
    if ( self = [super init] )
    {
        // do nothing
    }
    return self;
}


//get JSON query to retreive all the records from the table
-(NSString*) getJSONQueryForFetchingAllRecords{
    return SEARCH_QUERY_FOR_ALL_RECORDS;
}

//get the mutable dictionary of user id and its object
-(NSMutableDictionary*) getUsersDictionaryFromJson : (NSString*) jsonString{
    
    NSError *jsonError;
    NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:objectData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&jsonError];
    
    return jsonDictionary;
}


//get the query for location update
-(NSString*) getJSONQueryForLocationUpdate : (NSString*) userId lat : (double) latitude long : (double) longitude{
    NSString* query =  @"{\"id\":\"id_value\",\"latitude\":\"lat_value\",\"longitude\":\"long_value\"}";
    NSNumber *latitudeNumber = [NSNumber numberWithDouble:latitude];
    NSNumber *longitudeNumber = [NSNumber numberWithDouble:longitude];
    query = [query stringByReplacingOccurrencesOfString:@"id_value" withString:userId];
    query = [query stringByReplacingOccurrencesOfString:@"lat_value" withString:[latitudeNumber stringValue]];
    query = [query stringByReplacingOccurrencesOfString:@"long_value" withString:[longitudeNumber stringValue]];
    return query;
}

@end
