//
//  RESTApiDAO.h 
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/1/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
//  contains declaration of methods reponsible for the query the servers through REST APIs
//  Two APIs are used :- SMS API : textbelt.com/ and Database API : https://cloud-us.clusterpoint.com/
//

#import <Foundation/Foundation.h>
#import "Constants.h"


@interface RESTApiDAO : NSObject

//fetches the data from the Cluster point DB based on Search/Retrieve query
-(NSString*) makeRESTAPIcallForSearch:(NSString*)  query table : (NSString*) tableName operation: (NSString*) operationName ;

// asynchronous update on the user' details
-(void) makeRESTAPIcallToUpdateUser : (NSString*) query table : (NSString*) tableName;

// asynchronous sms sending to the user
-(void) makeRESTAPIcallToSendSMS : (NSString*) query ;

// asynchronous insert into db
-(void) makeRESTAPIcallToInsertData : (NSString*) query table : (NSString*) tableName;



@end
