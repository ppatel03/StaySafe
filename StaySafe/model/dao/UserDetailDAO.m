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


//default constructor
- (id) init
{
    if ( self = [super init] )
    {
        // do nothing
    }
    return self;
}


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
    
    
    NSString* query = [self.jsonModel getJSONQueryForFetchingAllRecords];
    
    //calling the REST API layer
    NSString* jsonString = [self.restAPIDAO makeRESTAPIcallForSearch:query table:USER_DETAILS_DB_NAME];
    
    //parse the json string into dicitonary
    NSMutableDictionary *jsonDictionary = [self.jsonModel getUsersDictionaryFromJson:jsonString];
    
    //using dictionary to store user details of the form --- id : UserDetailVo
    if ([jsonDictionary isKindOfClass:[NSMutableDictionary class]]){
        NSArray *userDictionaryArray = jsonDictionary[@"documents"];
        if ([userDictionaryArray isKindOfClass:[NSArray class]]){
            for (NSDictionary *dictionary in userDictionaryArray) {
                UserDetailVO *user = [[UserDetailVO alloc] init];
                user.suid = [dictionary objectForKey:@"id"];
                user.name = [dictionary objectForKey:@"name"];
                user.email = [dictionary objectForKey:@"email"];
                user.phone = [dictionary objectForKey:@"phone"];
                user.latitude =  [[dictionary objectForKey:@"latitude"] doubleValue];
                user.longitude =  [[dictionary objectForKey:@"longitude"] doubleValue];
                
                //Do this for all property
                [users setObject:user forKey:user.suid];
            }
        }
    }
    
    return users;
}

//  asynchronous update to user location
- (void) updateUserLocation : (UserDetailVO*) user{
    
    //fetches the json Query required for the cluster point server
    NSString* query = [self.jsonModel getJSONQueryForLocationUpdate:user.suid lat:user.latitude long:user.longitude];
    
    //call the rest api to perform asynchronous insert operation
    [self.restAPIDAO makeRESTAPIcallToUpdaterUserLocation:query table:USER_DETAILS_DB_NAME];
}


// aynchronous sending of SMSes to the list of users
- (void) sendSMSToUsers : (NSMutableDictionary*) users sms : (NSString*) message {
    
    //looping through the dictionary in iOS
    for (id key in users) {
        UserDetailVO *user = users[key];
        
        //Adding the neraby user's name in the sms message text
        NSString* messageWithSalutation = [@[@"Hi", user.name, @".", message] componentsJoinedByString:@" "];
        
        //fetches the json Query required for the sending sms to a phone number with message body
        NSString* query = [self.jsonModel getQueryForSendingTextSMS:user.phone sms:messageWithSalutation];
        
        //call the REST api to send sms asynchronously
        [self.restAPIDAO makeRESTAPIcallToSendSMS:query];
    }
    
}

@end
