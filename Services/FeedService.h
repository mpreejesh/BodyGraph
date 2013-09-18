//
//  FeedService.h
//  BodyGraph
//
//  Created by Nelson Chicas on 5/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"

@interface FeedService : Service

+ (FeedService *)sharedService;

- (void)getFeedForUser:(NSInteger)userId
        withPagination:(NSInteger)pagination
          onCompletion:(void (^)(NSArray *))completionHandler
               onError:(void (^)(NSError *))errorHandler;

@end
