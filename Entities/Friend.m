//
//  Friend.m
//  FaceCap
//
//  Created by Nelson Chicas on 5/20/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import "Friend.h"
#import "Campaign.h"

@implementation Friend

+ (Friend *)fromDictionary:(NSDictionary *)dict
{
    Friend *friend = [[Friend alloc] init];
    friend.userId = (NSNumber *)[dict objectForKey:@"friend_id"];
    friend.email = (NSString *)[dict objectForKey:@"email"];
    friend.nickname = (NSString *)[dict objectForKey:@"nickname"];
    friend.gender = (NSString *)[dict objectForKey:@"gender"];
    friend.pictureUrl = (NSString *)[dict objectForKey:@"picture_url"];
    //friend.isFollowed = [[dict objectForKey:@"is_followed"] boolValue];
    
    NSMutableArray *campaigns = [[NSMutableArray alloc] init];
    if( [dict objectForKey:@"campaigns"] )
        for( NSDictionary* campaignDict in (NSArray *)[dict objectForKey:@"campaigns"] ) {
            Campaign *campaign = [Campaign fromDictionary:campaignDict];
            [campaigns addObject:campaign];
        }
    
    NSMutableArray *friends = [[NSMutableArray alloc] init];
    if( [dict objectForKey:@"friends"] )
        for( NSDictionary* friendDict in (NSArray *)[dict objectForKey:@"friends"] ) {
            User *friend = [User fromDictionary:friendDict];
            [friends addObject:friend];
        }
    
    friend.campaigns = [[NSSet alloc] initWithArray:campaigns];
    friend.friends = [[NSSet alloc] initWithArray:friends];
    
    return friend;
}

@end
