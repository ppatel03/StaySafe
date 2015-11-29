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
#import "InitModel.h"

@interface RepositoryModel ()
@property (strong,nonatomic) InitModel* defaults;


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

// We override the default auto-generated getter for property model (which just
// returns the current value of ivar _model;), so we can do LAZY INSTANTIATION
// of our model object of class Model; doing lazy instantiation in getters
// is good practice, as objects won't be created until they are needed).  Note
// that we must use ivar _model here (using self.model would cause recursive call!)
- (InitModel *) defaults
{
    if (!_defaults)
        _defaults = [[InitModel alloc] init];
    
    return _defaults;
}

-(void) storeDefaultLatitudeAndLongitude{
    self.defaultLatitude = self.defaults.getDefaultLatitude;
    self.defaultLongitude = self.defaults.getDefaultLongitude;
}


@end
