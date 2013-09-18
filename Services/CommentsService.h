//
//  CommentsService.h
//  BodyGraph
//
//  Created by Kodemint on 06/08/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"
#import "Comment.h"
#import "Comments.h"

@interface CommentsService : Service

+ (CommentsService *)sharedService;

- (void)createJournalComment:(NSDictionary *)params
               forJournal:(NSInteger)journalId
          onCompletion:(void (^)(Comment *))completionHandler
               onError:(void (^)(NSError *))errorHandler;

- (void)getCommentsOfJournal:(NSInteger)journalId
                   withParams:(NSDictionary *)params
                 onCompletion:(void (^)(Comments *))completionHandler
                      onError:(void (^)(NSError *))errorHandler;
@end
