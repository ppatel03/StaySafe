//
//  UserDetailVO.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/1/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//
//  Value Object : holds the the app user data

#import <Foundation/Foundation.h>

@interface UserDetailVO : NSObject

@property NSString* suid;
@property NSString* name;
@property NSString* email;
@property NSString* phone;
@property double latitude;
@property double longitude;
@property NSNumber* distanceFromUser;
@property NSMutableArray* coordinates;

@end
