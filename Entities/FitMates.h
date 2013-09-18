//
//  NSObject+FitMates.h
//  BodyGraph
//
//  Created by Kodemint on 25/07/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  FitMates : NSObject
@property (nonatomic, strong) NSMutableArray *fitmatesPhone;
@property (nonatomic, strong) NSMutableArray *fitmatesFacebook;
@property (nonatomic, strong) NSMutableArray *fitmatesTwitter;

@property (nonatomic, assign) NSInteger phoneCount;
@property (nonatomic, assign) NSInteger fbCount;
@property (nonatomic, assign) NSInteger twitterCount;

@end
