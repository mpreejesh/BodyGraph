//
//  NSObject+FitMatesService.h
//  BodyGraph
//
//  Created by Kodemint on 25/07/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"
#import "FitMates.h"

@interface FitMatesService : Service

+ (FitMatesService *)sharedService;

- (void)getFitmatesForAddData:(NSInteger)userId
         withParams:(NSDictionary *)params
       onCompletion:(void (^)(FitMates *))completionHandler
            onError:(void (^)(NSError *))errorHandler;
@end
