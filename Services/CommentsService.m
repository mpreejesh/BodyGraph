//
//  NSObject+CommentsService.m
//  BodyGraph
//
//  Created by Kodemint on 06/08/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "CommentsService.h"
#import "Comment.h"
#import "Comments.h"
#import "Constants.h"

static CommentsService *sharedService = nil;

@interface CommentsService ()

- (RKResponseDescriptor *)getResponseDescriptor;

@end

@implementation CommentsService

- (id)init
{
	if( ( self = [super init] ) ) {
        self.baseUrl = kBaseUrl;
	}
	return self;
}

+ (CommentsService *)sharedService
{
    if (sharedService == nil) {
        sharedService = [[CommentsService alloc] init];
    }
    return sharedService;
}

- (RKResponseDescriptor *)getResponseDescriptor
{
    RKObjectMapping *CommentsForjournalMapping = [RKObjectMapping mappingForClass:[Comment class]];
    [CommentsForjournalMapping addAttributeMappingsFromDictionary:@{
     @"comment_id": @"comment_id",
     @"post_id": @"post_id",
     @"journal_id": @"journal_id",
     @"comment": @"comment"
     }];
    
  
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:CommentsForjournalMapping
                                                pathPattern:nil
                                                keyPath:nil
                                                statusCodes:statusCodes];
    
    return responseDescriptor;
}

- (RKResponseDescriptor *)getCommentsOfJournalResponseDescriptor
{
    RKObjectMapping *commentMapping = [RKObjectMapping mappingForClass:[Comment class]];
    [commentMapping addAttributeMappingsFromDictionary:@{
     @"comment_id": @"comment_id",
     @"journal_id": @"journal_id",
     @"post_id": @"post_id",
     @"comments": @"comment"
     }];
    
//    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:commentMapping pathPattern:nil keyPath:@"comments" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKObjectMapping *CommentsMapping = [RKObjectMapping mappingForClass:[Comments class]];
    [CommentsMapping addAttributeMappingsFromDictionary:@{
          }];
    
    [CommentsMapping addPropertyMapping:[RKRelationshipMapping
                                         relationshipMappingFromKeyPath:@"comments"
                                         toKeyPath:@"comments"
                                         withMapping:commentMapping]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:CommentsMapping
                                                pathPattern:nil
                                                keyPath:nil
                                                statusCodes:statusCodes];

    return responseDescriptor;
}

- (void) createJournalComment:(NSDictionary *)params
                   forJournal:(NSInteger)journalId
                 onCompletion:(void (^)(Comment *))completionHandler
                      onError:(void (^)(NSError *))errorHandler
{
    RKResponseDescriptor *descriptor = [self getResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kUCommentsForJournalUrl, journalId];
    [self getObjectFromUrl:url
                HTTPMethod:@"POST"
                    params:params
                descriptor:descriptor
              onCompletion:completionHandler
                   onError:errorHandler];
}

- (void) getCommentsOfJournal:(NSInteger)journalId
                   withParams:(NSDictionary *)params
                 onCompletion:(void (^)(Comments *))completionHandler
                      onError:(void (^)(NSError *))errorHandler
{
    RKResponseDescriptor *descriptor = [self getCommentsOfJournalResponseDescriptor];
    NSString *url = [NSString stringWithFormat:kUCommentsForJournalUrl, journalId];
    [self getObjectFromUrl:url
                HTTPMethod:@"GET"
                params:params descriptor:descriptor
              onCompletion:completionHandler
                   onError:errorHandler];
}
     
@end
