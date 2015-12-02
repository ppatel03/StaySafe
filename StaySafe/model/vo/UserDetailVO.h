//
//  UserDetailVO.h
//  StaySafe
//
//  Created by Prashant Mahesh Patel on 12/1/15.
//  Copyright © 2015 Prashant Mahesh Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetailVO : NSObject

@property NSString* id;
@property NSString* suid;
@property NSString* name;
@property NSString* email;
@property NSNumber* phone;
@property double latitude;
@property double longitude;

@end
