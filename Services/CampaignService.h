//
//  CampaignService.h
//  BodyGraph
//
//  Created by Nelson Chicas on 5/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"
#import "Campaign.h"

@interface CampaignService : Service

+ (CampaignService *)sharedService;

- (void)getCampaignsByUser:(NSInteger)userId
              onCompletion:(void (^)(NSArray *))completionHandler
                   onError:(void (^)(NSError *))errorHandler;

- (void)createCampaign:(NSDictionary *)params
               forUser:(NSInteger)userId
          onCompletion:(void (^)(Campaign *))completionHandler
               onError:(void (^)(NSError *))errorHandler;

- (void)updateCampaign:(NSInteger)campaignId
               forUser:(NSInteger)userId
            withParams:(NSDictionary *)params
          onCompletion:(void (^)(NSDictionary *))completionHandler
               onError:(void (^)(NSError *))errorHandler;

- (void)deleteCampaign:(NSInteger)campaignId
               forUser:(NSInteger)userId
          onCompletion:(void (^)(NSDictionary *))completionHandler
               onError:(void (^)(NSError *))errorHandler;

- (void)addJournal:(NSInteger)journalId
        toCampaign:(NSInteger)campaignId
      onCompletion:(void (^)(NSDictionary *))completionHandler
           onError:(void (^)(NSError *))errorHandler;

- (void)removeJournal:(NSInteger)journalId
         fromCampaign:(NSInteger)campaignId
         onCompletion:(void (^)(NSDictionary *))completionHandler
              onError:(void (^)(NSError *))errorHandler;

- (void)finishCampaign:(NSInteger)campaignId
          onCompletion:(void (^)(NSDictionary *))completionHandler
               onError:(void (^)(NSError *))errorHandler;
@end
