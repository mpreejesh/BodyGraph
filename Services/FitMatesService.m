//
//  NSObject+FitMatesService.m
//  BodyGraph
//
//  Created by Kodemint on 25/07/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "FitMatesService.h"
#import "FitMates.h"
#import "FitmatesForAdd.h"
#import "Constants.h"

static FitMatesService *sharedService = nil;

@interface FitMatesService ()

- (RKResponseDescriptor *)getResponseDescriptor;

@end

@implementation  FitMatesService

- (id)init
{
	if( ( self = [super init] ) ) {
        self.baseUrl = kBaseUrl;
	}
	return self;
}

+ (FitMatesService *)sharedService
{
    if (sharedService == nil) {
        sharedService = [[FitMatesService alloc] init];
    }
    return sharedService;
}

- (RKResponseDescriptor *)getAddFitmatesResponseDescriptor
{
    RKObjectMapping *fitmatesforAddMapping = [RKObjectMapping mappingForClass:[FitmatesForAdd class]];
    [fitmatesforAddMapping addAttributeMappingsFromDictionary:@{
     @"user_id": @"userId",
     @"nickname": @"nickname",
     @"campaign": @"campaign",
     @"picture_url": @"picture_url",
     @"login_source": @"login_source",
     @"action": @"action",
     @"notificationId": @"notificationId"
     }];
    
    RKObjectMapping *FitmatesMapping = [RKObjectMapping mappingForClass:[FitMates class]];
    [FitmatesMapping addAttributeMappingsFromDictionary:@{
      @"phoneCount":@"phoneCount",
      @"fbCount":@"fbCount",
      @"twitterCount":@"twitterCount"
     }];
    
    [FitmatesMapping addPropertyMapping:[RKRelationshipMapping
                                         relationshipMappingFromKeyPath:@"fitmatesPhone"
                                         toKeyPath:@"fitmatesPhone"
                                         withMapping:fitmatesforAddMapping]];
    
    [FitmatesMapping addPropertyMapping:[RKRelationshipMapping
                                         relationshipMappingFromKeyPath:@"fitmatesFacebook"
                                         toKeyPath:@"fitmatesFacebook"
                                         withMapping:fitmatesforAddMapping]];
    
    [FitmatesMapping addPropertyMapping:[RKRelationshipMapping
                                         relationshipMappingFromKeyPath:@"fitmatesTwitter"
                                         toKeyPath:@"fitmatesTwitter"
                                         withMapping:fitmatesforAddMapping]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:FitmatesMapping
                                                pathPattern:nil
                                                keyPath:nil
                                                statusCodes:statusCodes];
    return responseDescriptor;
}

- (void)getFitmatesForAddData:(NSInteger)userId
         withParams:(NSDictionary *)params
       onCompletion:(void (^)(FitMates *))completionHandler
            onError:(void (^)(NSError *))errorHandler
{
    RKResponseDescriptor *descriptor = [self getAddFitmatesResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kAddFitMatesUrl, userId];
    [self getObjectFromUrl:url
                HTTPMethod:@"GET"
                    params:params
                descriptor:descriptor
              onCompletion:completionHandler
                   onError:errorHandler];
}
@end
