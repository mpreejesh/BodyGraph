//
//  NSObject+FitmatesForAdd.h
//  BodyGraph
//
//  Created by Kodemint on 25/07/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface  FitmatesForAdd : NSObject
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* campaign;
@property (nonatomic, copy) NSString* common;
@property (nonatomic, copy) NSString* picture_url;
@property (nonatomic, assign) NSInteger login_source;
@property (nonatomic, copy) NSString* action;
@property (nonatomic, assign) NSInteger notificationId;
@end
