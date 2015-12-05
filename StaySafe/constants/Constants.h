//
//  Constants.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/1/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

//domain url
#define DOMAIN_URL @"https://api-us.clusterpoint.com"

//sms api url
#define SMS_API_URL @"http://textbelt.com/text/"

//url path delimiter
#define URL_DELIMITER @"/"

//user details db
#define USER_DETAILS_DB_NAME @"user_detail"

//user details db
#define USER_LOCATION_DB_NAME @"user_location"

//account number
#define USER_ACCOUNT_NUMBER @"102990"

//operation-search
#define SEARCH_OPERATION @"_search.json"

//partial-replace
#define PARTIAL_REPLACE_OPERATION @"_partial_replace.json"

//json extension appender
#define JSON_EXTENSION @".json"

//credentials
#define USER_CREDENTIALS @"pp231189@gmail.com:123ABCabc$"

//credentials type
#define USER_CREDENTIALS_TYPE @"Basic "

//post method
#define METHOD_POST @"POST"

//post method
#define METHOD_PUT @"PUT"

//authorization header field
#define AUTHORIZATION_HEADER_FIELD @"Authorization"

//content length header field
#define CONTENT_LENGTH_HEADER_FIELD @"Content-Length"

//maximum distance to determin if a registered user is nearby - current set to 5 miles
#define MAX_NEARBY_DISTANCE 11000

//default broadcast alert message
#define DEFAULT_ALERT_MESSAGE @"Alert from Stay Safe App. You are getting this SMS probably because of your location near to Testing device."

@end
