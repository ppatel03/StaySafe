//
//  RESTApiDAO.h - contains the declaration for the methods which provides the REST API call to cluster point database
//  - https://cloud-us.clusterpoint.com
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/1/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"


@interface RESTApiDAO : NSObject

//fetches the data from the Cluster point DB based on Search query
-(NSString*) makeRESTAPIcallForSearch:(NSString*)  query table : (NSString*) tableName ;

// asynchronous update on the user location
-(void) makeRESTAPIcallToUpdaterUserLocation : (NSString*) query table : (NSString*) tableName;

// asynchronous sms sending to the user
-(void) makeRESTAPIcallToSendSMS : (NSString*) query ;

// asynchronous insert for safewalk db
-(void) makeRESTAPIcallToInsertUserSafeWalkData : (NSString*) query table : (NSString*) tableName;

@end
