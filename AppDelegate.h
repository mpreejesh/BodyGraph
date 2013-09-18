//
//  AppDelegate.h
//  BodyGraph
//
//  Created by Cai DaRong on 2/13/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "TestFlight.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) User *localUser;

+ (AppDelegate *)sharedDelegate;

@end
