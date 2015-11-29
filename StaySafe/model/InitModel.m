//
//  InitModel.m
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/29/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import "InitModel.h"

// class extension ("empty category") for private properties and methods
@interface InitModel ()

@end

@implementation InitModel

//default coordinates
#define SU_LATITUDE 43.0469444444
#define SU_LONGITUDE -76.2777777777

//default constructor
- (id) init
{
    if ( self = [super init] )
    {
        // do nothing        
    }
    return self;
}

//gets the default latitude
-(double) getDefaultLatitude{
    return SU_LATITUDE;
}

//gets the default Longitude
-(double) getDefaultLongitude{
    return SU_LONGITUDE;
}



@end
