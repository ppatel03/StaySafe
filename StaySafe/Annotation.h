//
//  Annotation.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 11/25/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject<MKAnnotation>
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* subtitle;
@end
