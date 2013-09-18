//
//  JournalService.h
//  BodyGraph
//
//  Created by Nelson Chicas on 5/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"
#import "Journal.h"

@interface JournalService : Service

+ (JournalService *)sharedService;

- (void)getJournalsByUser:(NSInteger)userId
             onCompletion:(void (^)(NSArray *))completionHandler
                  onError:(void (^)(NSError *))errorHandler;

- (void)getJournalsByCampaign:(NSInteger)CampaignId
                 onCompletion:(void (^)(NSArray *))completionHandler
                      onError:(void (^)(NSError *))errorHandler;

- (void)createJournal:(NSDictionary *)params
              forCampaign:(NSInteger)campaignId
         onCompletion:(void (^)(Journal *))completionHandler
              onError:(void (^)(NSError *))errorHandler;

- (void)updateJournal:(NSInteger)JournalId
              forUser:(NSInteger)userId
           withParams:(NSDictionary *)params
         onCompletion:(void (^)(NSDictionary *))completionHandler
              onError:(void (^)(NSError *))errorHandler;

- (void)deleteJournal:(NSInteger)JournalId
               forUser:(NSInteger)userId
          onCompletion:(void (^)(NSDictionary *))completionHandler
               onError:(void (^)(NSError *))errorHandler;

@end
