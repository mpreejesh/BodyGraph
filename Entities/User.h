//
//  User.h
//  FaceCap
//
//  Created by Nelson Chicas on 4/8/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Campaign.h"

@interface User : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* gender;
@property (nonatomic, copy) NSString* pictureUrl;
@property (nonatomic, strong) Campaign *activeCampaign;
@property (nonatomic, strong) NSMutableArray *campaigns;
@property (nonatomic, strong) NSMutableArray *friends;

+ (User *)fromDictionary:(NSDictionary *)dict;

@end
