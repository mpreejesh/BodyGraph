//
//  FriendsService.h
//  BodyGraph
//
//  Created by Nelson Chicas on 5/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"

@interface FriendsService : Service

+ (FriendsService *)sharedService;

- (void)getFriendsFromContacts:(NSInteger)userId
                        emails:(NSArray *)friendEmails
                  onCompletion:(void (^)(NSArray *))completionHandler
                       onError:(void (^)(NSError *))errorHandler;

- (void)getFriendsFromFacebook:(NSInteger)userId
                         fbids:(NSArray *)friendFbids
                  onCompletion:(void (^)(NSArray *))completionHandler
                       onError:(void (^)(NSError *))errorHandler;

- (void)getFriendsFromTwitter:(NSInteger)userId
                        twids:(NSArray *)friendTwids
                 onCompletion:(void (^)(NSArray *))completionHandler
                      onError:(void (^)(NSError *))errorHandler;

- (void)addFriend:(NSInteger)userId
            param:(NSDictionary *)params
     onCompletion:(void (^)(NSDictionary *))completionHandler
          onError:(void (^)(NSError *))errorHandler;

- (void)removeFriend:(NSInteger)friendId
             forUser:(NSUInteger)userId
        onCompletion:(void (^)(NSDictionary *))completionHandler
             onError:(void (^)(NSError *))errorHandler;

- (void)getFriendRequestsForUser:(NSInteger)userId
                    onCompletion:(void (^)(NSArray *))completionHandler
                         onError:(void (^)(NSError *))errorHandler;

@end
