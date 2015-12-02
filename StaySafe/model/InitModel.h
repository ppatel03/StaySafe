//
//  InitModel.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/29/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InitModel : NSObject
//default coordinates
#define SU_LATITUDE 43.0469444444
#define SU_LONGITUDE -76.2777777777

//gets the default latitude
-(double) getDefaultLatitude;

//gets the default Longitude
-(double) getDefaultLongitude;
@end
