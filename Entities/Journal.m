//
//  Journal.m
//  BodyGraph
//
//  Created by Nelson Chicas on 4/8/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import "Journal.h"
#import <RestKit/RestKit.h>

@implementation Journal

+ (Journal *)fromDictionary:(NSDictionary *)dict
{
    Journal *journal = [[Journal alloc] init];
    journal.journalId = [[dict objectForKey:@"journal_id"] integerValue];
    journal.weight = [[dict objectForKey:@"weight"] floatValue];
    journal.date = (NSDate *)[dict objectForKey:@"date"];
    journal.frontImageUrl = (NSString *)[dict objectForKey:@"front_image_url"];
    journal.sideImageUrl = (NSString *)[dict objectForKey:@"side_image_url"];
    journal.description = (NSString *)[dict objectForKey:@"description"];
    if([dict objectForKey:@"Duration"] != nil)
        journal.Duration = (NSString *)[dict objectForKey:@"Duration"];
    if([dict objectForKey:@"comments_count"] != nil)
        journal.comments_count = (NSString *)[dict objectForKey:@"comments_count"];
    if([dict objectForKey:@"likes_count"] != nil)
        journal.likes_count = (NSString *)[dict objectForKey:@"likes_count"];
    return journal;
}

@end
