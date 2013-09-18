//
//  Service+NotificationService.m
//  BodyGraph
//
//  Created by Kodemint on 06/09/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "NotificationService.h"
#import "Notification.h"
#import "Constants.h"

static NotificationService *sharedService = nil;

@implementation NotificationService

- (id)init
{
	if( ( self = [super init] ) ) {
        self.baseUrl = kBaseUrl;
	}
	return self;
}

+(NotificationService *)sharedService
{
    if (sharedService == nil) {
        sharedService = [[NotificationService alloc] init];
    }
    return sharedService;
}
-(void)createNotification:(NSDictionary *)params
             onCompletion:(void (^)(NSDictionary *))completionHandler
                  onError:(void (^)(NSError *))errorHandler
{
    [self requestWithUrl:kNotificationUrl
              HTTPMethod:@"POST"
                  params:params
            onCompletion:completionHandler
                 onError:errorHandler];
}
-(void)updateNotification:(NSInteger)notificationId
             onCompletion:(void (^)(NSDictionary *))completionHandler
                  onError:(void (^)(NSError *))errorHandler
{
    
}

-(void)deleteNotification:(NSInteger)notificationId
             onCompletion:(void (^)(NSDictionary *))completionHandler
                  onError:(void (^)(NSError *))errorHandler
{
    NSString *url = [NSString stringWithFormat:kUNotificationUrl, notificationId];
    [self requestWithUrl:url
              HTTPMethod:@"DELETE"
                  params:nil
            onCompletion:completionHandler
                 onError:errorHandler];
}

-(void)getNotificationCount:(NSInteger)userId
               onCompletion:(void (^)(NSDictionary *))completionHandler
               onError:(void (^)(NSError *))errorHandler
{
    NSString *url = [NSString stringWithFormat:kUNotificationCountUrl, userId];
    [self requestWithUrl:url
              HTTPMethod:@"GET"
                  params:nil
            onCompletion:completionHandler
                 onError:errorHandler];
}

- (RKResponseDescriptor *)getResponseDescriptor
{
    
    RKObjectMapping *notificationMapping = [RKObjectMapping mappingForClass:[Notification class]];
    [notificationMapping addAttributeMappingsFromDictionary:@{
     @"notification_id": @"notificationId",
     @"journal_id": @"journalId",
     @"post_id": @"postId",
     @"type": @"type",
     @"description": @"description",
     @"date": @"date",
     @"duration": @"duration"
     }];

    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping addAttributeMappingsFromDictionary:@{
     @"user_id": @"userId",
     @"email": @"email",
     @"nickname": @"nickname",
     @"gender": @"gender",
     @"picture_url": @"pictureUrl"
     }];


    [notificationMapping addPropertyMapping:[RKRelationshipMapping  relationshipMappingFromKeyPath:@"User"
                                                                                     toKeyPath:@"user"
                                                                                    withMapping:userMapping] ];
    
    RKObjectMapping *notificationsMapping = [RKObjectMapping mappingForClass:[Notifications class]];
    [notificationsMapping addAttributeMappingsFromDictionary:@{
     }];
    
    [notificationsMapping addPropertyMapping:[RKRelationshipMapping
                                         relationshipMappingFromKeyPath:@"notifications"
                                         toKeyPath:@"notifications"
                                         withMapping:notificationMapping]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:notificationsMapping
                                                pathPattern:nil
                                                keyPath:nil
                                                statusCodes:statusCodes];
    
    return responseDescriptor;
}

- (void)getNotificationData:(NSInteger)userId
         withParams:(NSDictionary *)params
       onCompletion:(void (^)(Notifications *))completionHandler
            onError:(void (^)(NSError *))errorHandler
{
    RKResponseDescriptor *descriptor = [self getResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kUNotificationUrl, userId];
    [self getObjectFromUrl:url
                HTTPMethod:@"GET"
                    params:params
                descriptor:descriptor
              onCompletion:completionHandler
                   onError:errorHandler];
}
@end
