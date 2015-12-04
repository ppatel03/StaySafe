//
//  RepositoryModel.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/29/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
// It contains the declaration of methods  querying the data layer and storing the required data
// to map the business entities
//
// Its  a Repository pattern based on the idea of to separate the logic that retrieves the data and
// maps it to the entity model from the business logic that acts on the model.
// Refer https://msdn.microsoft.com/en-us/library/ff649690.aspx for Repository pattern

#import "RepositoryModel.h"


@interface RepositoryModel ()
@end

@implementation RepositoryModel

//getters and setters generators in objective-c
@synthesize defaultLatitude;
@synthesize defaultLongitude;

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
//1. defaults
- (InitModel *) defaults
{
    if (!_defaults)
        _defaults = [[InitModel alloc] init];
    
    return _defaults;
}



//3. userDetailDAO
- (UserDetailDAO *) userDetailDAO
{
    if (!_userDetailDAO)
        _userDetailDAO = [[UserDetailDAO alloc] init];
    
    return _userDetailDAO;
}

/* =========== LOGIC of OVERRIDDING default auto-generated getter ENDS HERE =============== */


//stores default latitude and longitude
-(void) storeDefaultLatitudeAndLongitude{
    self.defaultLatitude = self.defaults.getDefaultLatitude;
    self.defaultLongitude = self.defaults.getDefaultLongitude;
}

//retreives all the users details from the database
-(NSMutableDictionary*) getAllUserDetails{
    
    //calling the REST API layer
    self.users = [self.userDetailDAO getAllUserDetails];
    
    return self.users;
}

//update the user location
-(void) updateUserLocation : (UserDetailVO*) user {
    NSString* userId = user.id;
    UserDetailVO *updatedUser = self.users[userId];
    
    if(updatedUser != nil){
        //aynchronous call to update the user location
        
        // update the user location in the repository
        [self.users setObject:updatedUser forKey:userId];
    } else{
        NSLog(@"user not found to update the location");
    }
}


@end
