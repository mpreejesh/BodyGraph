//
//  AuthService.h
//  BodyGraph
//
//  Created by Nelson Chicas on 4/19/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"
#import "User.h"

@interface AuthService : Service

+ (AuthService *)sharedServiceWithContext:(NSString *)context;

- (void)registerWithParams:(NSDictionary *)params
              onCompletion:(void (^)(User *))completionHandler
                   onError:(void (^)(NSError *))errorHandler;

- (void)loginWithParams:(NSDictionary *)params
               onCompletion:(void (^)(User *))completionHandler
                    onError:(void (^)(NSError *))errorHandler;

- (void)logout;

- (NSString *)getUsername;

- (NSString *)getPassword;

- (NSString *)getAccessToken;

@end
