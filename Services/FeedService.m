//
//  FeedService.m
//  BodyGraph
//
//  Created by Nelson Chicas on 5/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import "FeedService.h"
#import <RestKit/RestKit.h>
#import "Action.h"
#import "User.h"

static FeedService *sharedService = nil;

@interface FeedService ()

- (RKResponseDescriptor *)getResponseDescriptor;

@end

@implementation FeedService

- (id)init
{
	if( ( self = [super init] ) ) {
        self.baseUrl = kBaseUrl;
	}
	return self;
}

+ (FeedService *)sharedService
{
    if (sharedService == nil) {
        sharedService = [[FeedService alloc] init];
    }
    return sharedService;
}

- (RKResponseDescriptor *)getResponseDescriptor
{
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping addAttributeMappingsFromDictionary:@{
        @"user_id": @"userId",
        @"email": @"email",
        @"nickname": @"nickname",
        @"gender": @"gender",
        @"picture_url": @"pictureUrl"
    }];
    
    RKObjectMapping *actionMapping = [RKObjectMapping mappingForClass:[Action class]];
    [actionMapping addAttributeMappingsFromDictionary:@{
        @"action_id": @"actionId",
        @"action": @"action",
        @"time": @"time"
    }];
    
    [actionMapping addPropertyMapping:[RKRelationshipMapping
                                       relationshipMappingFromKeyPath:@"following"
                                                            toKeyPath:@"user"
                                                          withMapping:userMapping]];
    
    [actionMapping addPropertyMapping:[RKRelationshipMapping
                                       relationshipMappingFromKeyPath:@"target_user"
                                                            toKeyPath:@"targetUser"
                                                          withMapping:userMapping]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:actionMapping
                                                pathPattern:nil
                                                keyPath:nil
                                                statusCodes:statusCodes];
    
    return responseDescriptor;
}

- (void)getFeedForUser:(NSInteger)userId
        withPagination:(NSInteger)pagination
          onCompletion:(void (^)(NSArray *))completionHandler
               onError:(void (^)(NSError *))errorHandler
{
    RKResponseDescriptor *descriptor = [self getResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kFeedUrl, userId];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithInteger:pagination], @"offset", nil];
    [self getCollectionFromUrl:url
                    HTTPMethod:@"GET"
                        params:params
                    descriptor:descriptor
                  onCompletion:completionHandler
                       onError:errorHandler];
}

@end