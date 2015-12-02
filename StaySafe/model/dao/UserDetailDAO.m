//
//  UserDetailDAO.m - contains the implementation of all the methods used to perform DB operations on
//  user data via REST API using RestApiDAO
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/1/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import "UserDetailDAO.h"

@implementation UserDetailDAO




/* =========== LOGIC of OVERRIDDING default auto-generated getter STARTS HERE =============== */

// We override the default auto-generated getter for property model (which just
// returns the current value of ivar _model;), so we can do LAZY INSTANTIATION
// of our model object of class Model; doing lazy instantiation in getters
// is good practice, as objects won't be created until they are needed).  Note
// that we must use ivar _model here (using self.model would cause recursive call!)
//1. jsonModel
- (JSONQueryModel *) jsonModel
{
    if (!_jsonModel)
        _jsonModel = [[JSONQueryModel alloc] init];
    
    return _jsonModel;
}

//2. restAPIDAO
- (RESTApiDAO *) restAPIDAO
{
    if (!_restAPIDAO)
        _restAPIDAO = [[RESTApiDAO alloc] init];
    
    return _restAPIDAO;
}

/* =========== LOGIC of OVERRIDDING default auto-generated getter ENDS HERE =============== */



//  retrieves all the records from the user_detail database
- (NSMutableDictionary*) getAllUserDetails  {
    
    // Create an empty mutable dictionary
    NSMutableDictionary *users = [NSMutableDictionary dictionary];
    
    //calling the REST API layer
    [self.restAPIDAO makeRESTAPIcallForSearch:SEARCH_QUERY_FOR_ALL_RECORDS table:USER_DETAILS_DB_NAME];
    
    return users;
}

@end
