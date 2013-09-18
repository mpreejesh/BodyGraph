//
//  Campaign.h
//  BodyGraph
//
//  Created by Nelson Chicas on 4/8/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface Campaign : NSObject

@property (nonatomic, assign) NSInteger campaignId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) float initialWeight;
@property (nonatomic, assign) float finalWeight;
@property (nonatomic, assign) BOOL isPublic;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, strong) NSMutableArray *journals;

+ (Campaign *)fromDictionary:(NSDictionary *)dict;

@end
