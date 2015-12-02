//
//  UserDetailDAO.h - contains the declaration of all the methods used to perform DB operations on
//  user data via REST API using RestApiDAO
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/1/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RESTApiDAO.h"
#import "JSONQueryModel.h"

@interface UserDetailDAO : NSObject

//HAS-A relationship for fetching json POST string and processing JSON
@property (strong,nonatomic) JSONQueryModel* jsonModel;

// contains the handle to RestApiDAO
//operating on the data on the database servers using REST APIs
@property (strong,nonatomic) RESTApiDAO* restAPIDAO;

//  retrieves all the records from the user_detail database
- (NSMutableDictionary*) getAllUserDetails ;

@end