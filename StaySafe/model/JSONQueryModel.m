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



//get JSON query to retreive all the records from the table
-(NSString*) getJSONQueryForFetchingAllRecords{
    return SEARCH_QUERY_FOR_ALL_RECORDS;
}

@end
