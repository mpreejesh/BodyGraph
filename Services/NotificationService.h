//
//  Service+NotificationService.h
//  BodyGraph
//
//  Created by Kodemint on 06/09/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"
#import "Notifications.h"

@interface NotificationService : Service

+ (NotificationService *)sharedService;

-(void)createNotification:(NSDictionary *)params
                onCompletion:(void (^)(NSDictionary *)) completionHandler
                onError:(void (^)(NSError *)) errorHandler;

-(void)updateNotification:(NSInteger)notificationId
                onCompletion:(void (^)(NSDictionary *)) completionHandler
                onError:(void (^)(NSError *)) errorHandler;

-(void)deleteNotification:(NSInteger)notificationId
             onCompletion:(void (^)(NSDictionary *)) completionHandler
                  onError:(void (^)(NSError *)) errorHandler;

- (void)getNotificationData:(NSInteger)userId
         withParams:(NSDictionary *)params
       onCompletion:(void (^)(Notifications *))completionHandler
            onError:(void (^)(NSError *))errorHandler;

-(void)getNotificationCount:(NSInteger)userId
             onCompletion:(void (^)(NSDictionary *)) completionHandler
                  onError:(void (^)(NSError *)) errorHandler;
@end
