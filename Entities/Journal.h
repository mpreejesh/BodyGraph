//
//  Journal.h
//  BodyGraph
//
//  Created by Nelson Chicas on 4/8/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface Journal : NSObject

@property (nonatomic, assign) NSInteger journalId;
@property (nonatomic, assign) float weight;
@property (nonatomic, copy) NSDate* date;
@property (nonatomic, copy) NSString* frontImageUrl;
@property (nonatomic, copy) NSString* sideImageUrl;
@property (nonatomic, copy) NSString* description;
@property (nonatomic, copy) NSString* Duration;
@property (nonatomic, assign) NSInteger comments_count;
@property (nonatomic, assign) NSInteger likes_count;

+ (Journal *)fromDictionary:(NSDictionary *)dict;

@end
