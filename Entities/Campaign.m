//
//  Campaign.m
//  FaceCap
//
//  Created by Nelson Chicas on 4/8/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import "Campaign.h"
#import "Journal.h"

@implementation Campaign

+ (Campaign *)fromDictionary:(NSDictionary *)dict
{
    Campaign *campaign = [[Campaign alloc] init];
    campaign.campaignId = [(NSString *) [dict objectForKey:@"campaign_id"] intValue];//(NSInteger)[dict objectForKey:@"campaign_id"];
    campaign.name = (NSString *)[dict objectForKey:@"name"];//[[dict objectForKey:@"name"] integerValue];
    campaign.isPublic = [[dict objectForKey:@"public"] boolValue];
    campaign.isActive = [[dict objectForKey:@"active"] boolValue];
    campaign.initialWeight = [[dict objectForKey:@"initial_weight"] floatValue];
    campaign.finalWeight = [[dict objectForKey:@"final_weight"] floatValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    campaign.startDate = ([(NSString *)[dict objectForKey:@"start_date"] intValue] == 0) ? 0 : [dateFormatter dateFromString:(NSString *)[dict objectForKey:@"start_date"]];
    campaign.endDate = ([(NSString *)[dict objectForKey:@"end_date"] intValue] == 0) ? 0 : [dateFormatter dateFromString:(NSString *)[dict objectForKey:@"end_date"]]; //(NSDate *)[dict objectForKey:@"end_date"];
    
    NSMutableArray *journals = [[NSMutableArray alloc] init];
    if( [dict objectForKey:@"journals"] )
        for( NSDictionary *journalDict in (NSArray *)[dict objectForKey:@"journals"] ) {
            Journal *journal = [Journal fromDictionary:journalDict];
            [journals addObject:journal];
        }
    
    campaign.journals = journals;// [[NSSet alloc] initWithArray:journals];
    
    return campaign;
}


@end
