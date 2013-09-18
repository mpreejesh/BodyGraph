//
//  UserService.m
//  BodyGraph
//
//  Created by Nelson Chicas on 5/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import "UserService.h"
#import <RestKit/RestKit.h>
#import "User.h"
#import "Journal.h"
#import "Campaign.h"
#import "Constants.h"

static UserService *sharedService = nil;

@interface UserService ()

- (RKResponseDescriptor *)getResponseDescriptor;

@end

@implementation UserService

- (id)init
{
	if( ( self = [super init] ) ) {
        self.baseUrl = kBaseUrl;
	}
	return self;
}

+ (UserService *)sharedService
{
    if (sharedService == nil) {
        sharedService = [[UserService alloc] init];
    }
    return sharedService;
}

- (RKResponseDescriptor *)getResponseDescriptor
{
    RKObjectMapping *journalMapping = [RKObjectMapping mappingForClass:[Journal class]];
    [journalMapping addAttributeMappingsFromDictionary:@{
     @"journal_id": @"journalId",
     @"weight": @"weight",
     @"date": @"date",
     @"front_image_url": @"frontImageUrl",
     @"side_image_url": @"sideImageUrl",
     @"Duration": @"Duration",
     @"comments_count": @"comments_count",
     @"likes_count": @"likes_count",
     @"description": @"description"
     }];
    
    RKObjectMapping *campaignMapping = [RKObjectMapping mappingForClass:[Campaign class]];
    [campaignMapping addAttributeMappingsFromDictionary:@{
     @"campaign_id": @"campaignId",
     @"name": @"name",
     @"public": @"isPublic",
     @"active": @"isActive",
     @"initial_weight": @"initialWeight",
     @"start_date": @"startDate",
     @"final_weight": @"finalWeight",
     @"end_date": @"endDate"
     }];

    
    [campaignMapping addPropertyMapping:[RKRelationshipMapping
                                         relationshipMappingFromKeyPath:@"journals"
                                         toKeyPath:@"journals"
                                         withMapping:journalMapping]];
    
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping addAttributeMappingsFromDictionary:@{
     @"user_id": @"userId",
     @"email": @"email",
     @"nickname": @"nickname",
     @"gender": @"gender",
     @"picture_url": @"pictureUrl"
     }];
    
    
    [userMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"active_campaign"
                                                                                toKeyPath:@"activeCampaign"
                                                                              withMapping:campaignMapping] ];
    
  
    [userMapping addPropertyMapping:[RKRelationshipMapping
                                     relationshipMappingFromKeyPath:@"campaigns"
                                     toKeyPath:@"campaigns"
                                     withMapping:campaignMapping]];
    
    [userMapping addPropertyMapping:[RKRelationshipMapping
                                     relationshipMappingFromKeyPath:@"friends"
                                     toKeyPath:@"friends"
                                     withMapping:userMapping]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:userMapping
                                                pathPattern:nil
                                                keyPath:nil
                                                statusCodes:statusCodes];
    
    return responseDescriptor;
}

- (RKResponseDescriptor *)getJournalActivitiesResponseDescriptor
{
    RKObjectMapping *journalMapping = [RKObjectMapping mappingForClass:[Journal class]];
    [journalMapping addAttributeMappingsFromDictionary:@{
     @"journal_id": @"journalId",
     @"Duration": @"Duration",
     @"comments_count": @"comments_count",
     @"likes_count": @"likes_count"
     }];
    
    RKObjectMapping *campaignMapping = [RKObjectMapping mappingForClass:[Campaign class]];
    [campaignMapping addAttributeMappingsFromDictionary:@{
     @"campaign_id": @"campaignId"
    
     }];
    
    [campaignMapping addPropertyMapping:[RKRelationshipMapping
                                         relationshipMappingFromKeyPath:@"journals"
                                         toKeyPath:@"journals"
                                         withMapping:journalMapping]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:campaignMapping
                                                pathPattern:nil
                                                keyPath:nil
                                                statusCodes:statusCodes];
    return responseDescriptor;
}
- (void)getUserData:(NSInteger)userId
         withParams:(NSDictionary *)params
       onCompletion:(void (^)(User *))completionHandler
            onError:(void (^)(NSError *))errorHandler
{
    RKResponseDescriptor *descriptor = [self getResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kUsersUrl, userId];
    [self getObjectFromUrl:url
                HTTPMethod:@"GET"
                    params:params
                descriptor:descriptor
              onCompletion:completionHandler
                   onError:errorHandler];
}

- (void)updateUser:(NSInteger)userId
        withParams:(NSDictionary *)params
      onCompletion:(void (^)(NSDictionary *))completionHandler
           onError:(void (^)(NSError *))errorHandler
{
    NSString *url = [NSString stringWithFormat:kUsersUrl, userId];
    [self requestWithUrl:url
              HTTPMethod:@"PUT"
                  params:params
            onCompletion:completionHandler
                 onError:errorHandler];
}

- (void)deleteUser:(NSInteger)userId
      onCompletion:(void (^)(NSDictionary *))completionHandler
           onError:(void (^)(NSError *))errorHandler
{
    NSString *url = [NSString stringWithFormat:kUsersUrl, userId];
    [self requestWithUrl:url
              HTTPMethod:@"DELETE"
                  params:nil
            onCompletion:completionHandler
                 onError:errorHandler];
}

- (void)getJournalActivitiesByCampaign:(NSInteger)campaignId
        withParams:(NSDictionary *)params
      onCompletion:(void (^)(Campaign *))completionHandler
           onError:(void (^)(NSError *))errorHandler
{
    RKResponseDescriptor *descriptor = [self getJournalActivitiesResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kGetournalsActivitiesByCampaignUrl, campaignId];
    [self getObjectFromUrl:url
              HTTPMethod:@"GET"
                  params:params
              descriptor:descriptor
            onCompletion:completionHandler
                 onError:errorHandler];
}

@end
