//
//  JournalService.m
//  BodyGraph
//
//  Created by Nelson Chicas on 5/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import "JournalService.h"
#import <RestKit/RestKit.h>
#import "Journal.h"

static JournalService *sharedService = nil;

@interface JournalService ()

- (RKResponseDescriptor *)getResponseDescriptor;

@end

@implementation JournalService

- (id)init
{
	if( ( self = [super init] ) ) {
        self.baseUrl = kBaseUrl;
	}
	return self;
}

+ (JournalService *)sharedService
{
    if (sharedService == nil) {
        sharedService = [[JournalService alloc] init];
    }
    return sharedService;
}

- (RKResponseDescriptor *)getResponseDescriptor
{
    RKObjectMapping *journalMapping = [RKObjectMapping mappingForClass:[Journal class]];
    [journalMapping addAttributeMappingsFromDictionary:@{
        @"journal_id": @"journalId",
        @"Duration": @"Duration",
        @"comments_count": @"comments_count",
        @"likes_count": @"likes_count",
        @"weight": @"weight",
        @"date": @"date",
        @"front_image_url": @"frontImageUrl",
        @"side_image_url": @"sideImageUrl",
        @"description": @"description"
     }];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:journalMapping
                                                pathPattern:nil
                                                keyPath:nil
                                                statusCodes:statusCodes];
    
    return responseDescriptor;
}

- (void)getJournalsByUser:(NSInteger)userId
             onCompletion:(void (^)(NSArray *))completionHandler
                  onError:(void (^)(NSError *))errorHandler;
{
    RKResponseDescriptor *descriptor = [self getResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kUJournalsUrl, userId];
    [self getCollectionFromUrl:url
                    HTTPMethod:@"GET"
                        params:nil
                    descriptor:descriptor
                  onCompletion:completionHandler
                       onError:errorHandler];
}

- (void)getJournalsByCampaign:(NSInteger)CampaignId
                 onCompletion:(void (^)(NSArray *))completionHandler
                      onError:(void (^)(NSError *))errorHandler;
{
    RKResponseDescriptor *descriptor = [self getResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kCJournalsUrl, CampaignId];
    [self getCollectionFromUrl:url
                    HTTPMethod:@"GET"
                        params:nil
                    descriptor:descriptor
                  onCompletion:completionHandler
                       onError:errorHandler];
}

- (void)createJournal:(NSDictionary *)params
              forCampaign:(NSInteger)campaignId
         onCompletion:(void (^)(Journal *))completionHandler
              onError:(void (^)(NSError *))errorHandler
{
    RKResponseDescriptor *descriptor = [self getResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kUJournalsUrl, campaignId];
    [self getObjectFromUrl:url
                HTTPMethod:@"POST"
                    params:params
                descriptor:descriptor
              onCompletion:completionHandler
                   onError:errorHandler];
}

- (void)updateJournal:(NSInteger)JournalId
              forUser:(NSInteger)userId
           withParams:(NSDictionary *)params
         onCompletion:(void (^)(NSDictionary *))completionHandler
              onError:(void (^)(NSError *))errorHandler
{
    //NSString *url = [NSString stringWithFormat:kJournalsUrl, userId, JournalId]; //shinu
    NSString *url = [NSString stringWithFormat:kJournalsUrl, userId, JournalId]; //shinu
    [self requestWithUrl:url
              HTTPMethod:@"PUT"
                  params:params
            onCompletion:completionHandler
                 onError:errorHandler];
}

- (void)deleteJournal:(NSInteger)JournalId
              forUser:(NSInteger)userId
         onCompletion:(void (^)(NSDictionary *))completionHandler
              onError:(void (^)(NSError *))errorHandler
{
    NSString *url = [NSString stringWithFormat:kJournalsUrl, userId, JournalId];
    [self requestWithUrl:url
              HTTPMethod:@"DELETE"
                  params:nil
            onCompletion:completionHandler
                 onError:errorHandler];
}

@end
