//
//  User.m
//  FaceCap
//
//  Created by Nelson Chicas on 4/8/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import "User.h"
#import "Campaign.h"

@implementation User

+ (User *)fromDictionary:(NSDictionary *)dict
{
    User *user = [[User alloc] init];
    user.userId = [(NSString *) [dict objectForKey:@"user_id"] intValue];//(NSNumber *)[dict objectForKey:@"user_id"];
    user.email = (NSString *)[dict objectForKey:@"email"];
    user.nickname = (NSString *)[dict objectForKey:@"nickname"];
    user.gender = (NSString *)[dict objectForKey:@"gender"];
    user.pictureUrl = (NSString *)[dict objectForKey:@"picture_url"];
    //User *user = [User fromDictionary:(NSDictionary *)[result objectForKey:@"user"]];
    user.activeCampaign = [Campaign fromDictionary:(NSDictionary *)[dict objectForKey:@"active_campaign"]];//(Campaign *)[dict objectForKey:@"active_campaign"];
    
    
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

    user.campaigns = campaigns;//[[NSSet alloc] initWithArray:campaigns];
    user.friends = friends;//[[NSSet alloc] initWithArray:friends];
    
    return user;
}

@end
