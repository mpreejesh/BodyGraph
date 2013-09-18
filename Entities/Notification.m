//
//  NSObject+Notification.m
//  BodyGraph
//
//  Created by Kodemint on 11/09/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "Notification.h"

@implementation Notification

+ (Notification *)fromDictionary:(NSDictionary *)dict
{
    Notification *notification = [[Notification alloc] init];
    notification.notificationId = [(NSString *) [dict objectForKey:@"notification_id"] intValue];
    notification.journalId = [(NSString *) [dict objectForKey:@"journal_id"] intValue];
    notification.postId = [(NSString *) [dict objectForKey:@"post_id"] intValue];
    notification.type = (NSString *)[dict objectForKey:@"type"];
    notification.description = (NSString *)[dict objectForKey:@"description"];
    notification.date = (NSDate *)[dict objectForKey:@"date"];
    notification.duration = (NSString *)[dict objectForKey:@"duration"];

    notification.user = [User fromDictionary:(NSDictionary *)[dict objectForKey:@"User"]];
    
    return notification;
}

@end
