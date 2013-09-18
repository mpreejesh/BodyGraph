//
//  Action.h
//  FaceCap
//
//  Created by Nelson Chicas on 4/8/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Action : NSObject

@property (nonatomic, assign) NSInteger *actionId;
@property (nonatomic, copy) NSDate *time;
@property (nonatomic, assign) NSInteger *action;
@property (nonatomic, strong) User *user;

@end
