//
//  CampaignService.m
//  BodyGraph
//
//  Created by Nelson Chicas on 5/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import "CampaignService.h"
#import <RestKit/RestKit.h>
#import "Journal.h"
#import "Campaign.h"

static CampaignService *sharedService = nil;

@interface CampaignService ()

- (RKResponseDescriptor *)getResponseDescriptor;

@end

@implementation CampaignService

- (id)init
{
	if( ( self = [super init] ) ) {
        self.baseUrl = kBaseUrl;
	}
	return self;
}

+ (CampaignService *)sharedService
{
    if (sharedService == nil) {
        sharedService = [[CampaignService alloc] init];
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
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:campaignMapping
                                                pathPattern:nil
                                                keyPath:nil
                                                statusCodes:statusCodes];
    
    return responseDescriptor;
}

- (void)getCampaignsByUser:(NSInteger)userId
              onCompletion:(void (^)(NSArray *))completionHandler
                   onError:(void (^)(NSError *))errorHandler;
{
    RKResponseDescriptor *descriptor = [self getResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kUCampaignsUrl, userId];
    [self getCollectionFromUrl:url
                    HTTPMethod:@"GET"
                        params:nil
                    descriptor:descriptor
                  onCompletion:completionHandler
                       onError:errorHandler];
    
}

- (void)createCampaign:(NSDictionary *)params
               forUser:(NSInteger)userId
          onCompletion:(void (^)(Campaign *))completionHandler
               onError:(void (^)(NSError *))errorHandler
{
    RKResponseDescriptor *descriptor = [self getResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kUCampaignsUrl, userId];
    [self getObjectFromUrl:url
                HTTPMethod:@"POST"
                    params:params
                descriptor:descriptor
              onCompletion:completionHandler
                   onError:errorHandler];
}

- (void)updateCampaign:(NSInteger)CampaignId
               forUser:(NSInteger)userId
            withParams:(NSDictionary *)params
          onCompletion:(void (^)(NSDictionary *))completionHandler
               onError:(void (^)(NSError *))errorHandler
{
    NSString *url = [NSString stringWithFormat:kCampaignsUrl, userId, CampaignId];
    [self requestWithUrl:url
              HTTPMethod:@"PUT"
                  params:params
            onCompletion:completionHandler
                 onError:errorHandler];
}

- (void)finishCampaign:(NSInteger)CampaignId
          onCompletion:(void (^)(NSDictionary *))completionHandler
               onError:(void (^)(NSError *))errorHandler
{
    NSString *url = [NSString stringWithFormat:kUFinishCampaignUrl, CampaignId];
    [self requestWithUrl:url
              HTTPMethod:@"POST"
                  params:nil
            onCompletion:completionHandler
                 onError:errorHandler];
}

- (void)deleteCampaign:(NSInteger)CampaignId
               forUser:(NSInteger)userId
          onCompletion:(void (^)(NSDictionary *))completionHandler
               onError:(void (^)(NSError *))errorHandler
{
    NSString *url = [NSString stringWithFormat:kCampaignsUrl, userId, CampaignId];
    [self requestWithUrl:url
              HTTPMethod:@"DELETE"
                  params:nil
            onCompletion:completionHandler
                 onError:errorHandler];
}

- (void)addJournal:(NSInteger)JournalId
        toCampaign:(NSInteger)CampaignId
      onCompletion:(void (^)(NSDictionary *))completionHandler
           onError:(void (^)(NSError *))errorHandler
{
    NSString *url = [NSString stringWithFormat:kCJournalsUrl, CampaignId, JournalId];
    [self requestWithUrl:url
              HTTPMethod:@"POST"
                  params:nil
            onCompletion:completionHandler
                 onError:errorHandler];
}

- (void)removeJournal:(NSInteger)JournalId
         fromCampaign:(NSInteger)CampaignId
         onCompletion:(void (^)(NSDictionary *))completionHandler
              onError:(void (^)(NSError *))errorHandler
{
    NSString *url = [NSString stringWithFormat:kCJournalsUrl, CampaignId, JournalId];
    [self requestWithUrl:url
              HTTPMethod:@"DELETE"
                  params:nil
            onCompletion:completionHandler
                 onError:errorHandler];
}

@end
