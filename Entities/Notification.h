//
//  NSObject+Notification.h
//  BodyGraph
//
//  Created by Kodemint on 11/09/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Notification : NSObject

@property (nonatomic, assign) NSInteger notificationId;
@property (nonatomic, assign) NSInteger journalId;
@property (nonatomic, assign) NSInteger postId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString* description;
@property (nonatomic, copy) NSDate* date;
@property (nonatomic, copy) NSString* duration;
@property (nonatomic, strong) User *user;

+ (Notification *)fromDictionary:(NSDictionary *)dict;

@end
