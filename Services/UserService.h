//
//  UserService.h
//  BodyGraph
//
//  Created by Nelson Chicas on 5/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"
#import "User.h"
#import "Journal.h"

@interface UserService : Service

+ (UserService *)sharedService;

- (void)getUserData:(NSInteger)userId
         withParams:(NSDictionary *)params
       onCompletion:(void (^)(User *))completionHandler
            onError:(void (^)(NSError *))errorHandler;

- (void)updateUser:(NSInteger)userId
        withParams:(NSDictionary *)params
      onCompletion:(void (^)(NSDictionary *))completionHandler
           onError:(void (^)(NSError *))errorHandler;

- (void)deleteUser:(NSInteger)userId
      onCompletion:(void (^)(NSDictionary *))completionHandler
           onError:(void (^)(NSError *))errorHandler;

- (void) getJournalActivitiesByCampaign:(NSInteger)campaignId
      withParams:(NSDictionary *)params
    onCompletion:(void (^)(Campaign *)) completeHandler
         onError:(void (^)(NSError *)) errorHandler;
@end
