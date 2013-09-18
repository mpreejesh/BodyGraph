//
//  FriendsService.m
//  BodyGraph
//
//  Created by Nelson Chicas on 5/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import "FriendsService.h"
#import <RestKit/RestKit.h>
#import "Friend.h"

static FriendsService *sharedService = nil;

@interface FriendsService ()

- (RKResponseDescriptor *)getResponseDescriptor;

@end

@implementation FriendsService

- (id)init
{
	if( ( self = [super init] ) ) {
        self.baseUrl = kBaseUrl;
	}
	return self;
}

+ (FriendsService *)sharedService
{
    if (sharedService == nil) {
        sharedService = [[FriendsService alloc] init];
    }
    return sharedService;
}

- (RKResponseDescriptor *)getResponseDescriptor
{
    RKObjectMapping *friendMapping = [RKObjectMapping mappingForClass:[Friend class]];
    [friendMapping addAttributeMappingsFromDictionary:@{
        @"user_id": @"userId",
        @"email": @"email",
        @"nickname": @"nickname",
        @"gender": @"gender",
        @"picture_url": @"pictureUrl",
    }];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:friendMapping
                                                pathPattern:nil
                                                keyPath:nil
                                                statusCodes:statusCodes];
    
    return responseDescriptor;
}

- (void)getFriendsFromContacts:(NSInteger)userId
                        emails:(NSArray *)friendEmails
                  onCompletion:(void (^)(NSArray *))completionHandler
                       onError:(void (^)(NSError *))errorHandler
{
    RKResponseDescriptor *descriptor = [self getResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kFriendsUrl, userId];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [friendEmails componentsJoinedByString:@","], @"emails", nil];
    [self getCollectionFromUrl:url
                    HTTPMethod:@"POST"
                        params:params
                    descriptor:descriptor
                  onCompletion:completionHandler
                       onError:errorHandler];
}

- (void)getFriendsFromFacebook:(NSInteger)userId
                         fbids:(NSArray *)friendFbids
                  onCompletion:(void (^)(NSArray *))completionHandler
                       onError:(void (^)(NSError *))errorHandler
{
    RKResponseDescriptor *descriptor = [self getResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kFriendsUrl, userId];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [friendFbids componentsJoinedByString:@","], @"fbids", nil];
    [self getCollectionFromUrl:url
                    HTTPMethod:@"POST"
                        params:params
                    descriptor:descriptor
                  onCompletion:completionHandler
                       onError:errorHandler];
}

- (void)getFriendsFromTwitter:(NSInteger)userId
                        twids:(NSArray *)friendTwids
                 onCompletion:(void (^)(NSArray *))completionHandler
                      onError:(void (^)(NSError *))errorHandler
{
    RKResponseDescriptor *descriptor = [self getResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kFriendsUrl, userId];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [friendTwids componentsJoinedByString:@","], @"twids", nil];
    [self getCollectionFromUrl:url
                    HTTPMethod:@"POST"
                        params:params
                    descriptor:descriptor
                  onCompletion:completionHandler
                       onError:errorHandler];
}

- (void)addFriend:(NSInteger)userId
            param:(NSDictionary *)params
     onCompletion:(void (^)(NSDictionary *))completionHandler
          onError:(void (^)(NSError *))errorHandler
{
    NSString *url = [NSString stringWithFormat:kFriendsUrl, userId];
    [self requestWithUrl:url
              HTTPMethod:@"POST"
                  params:params
            onCompletion:completionHandler
                 onError:errorHandler];
}

- (void)removeFriend:(NSInteger)friendId
             forUser:(NSUInteger)userId
        onCompletion:(void (^)(NSDictionary *))completionHandler
             onError:(void (^)(NSError *))errorHandler
{
    NSString *url = [NSString stringWithFormat:kFriendsUrl, userId];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithInteger:friendId], @"friend", nil];
    [self requestWithUrl:url
              HTTPMethod:@"DELETE"
                  params:params
            onCompletion:completionHandler
                 onError:errorHandler];
}

- (void)getFriendRequestsForUser:(NSInteger)userId
                    onCompletion:(void (^)(NSArray *))completionHandler
                         onError:(void (^)(NSError *))errorHandler
{
    RKResponseDescriptor *descriptor = [self getResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kFriendsUrl, userId];
    [self getCollectionFromUrl:url
                    HTTPMethod:@"GET"
                        params:nil
                    descriptor:descriptor
                  onCompletion:completionHandler
                       onError:errorHandler];
}

@end
