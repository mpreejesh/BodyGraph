//
//  Service.h
//  BodyGraph
//
//  Created by Nelson Chicas on 5/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface Service : NSObject

@property (nonatomic, strong) NSString *baseUrl;

- (void)requestWithUrl:(NSString *)url
            HTTPMethod:(NSString *)method
                params:(NSDictionary *)params
          onCompletion:(void (^)(NSDictionary *))completionHandler
               onError:(void (^)(NSError *))errorHandler;

- (void)getObjectFromUrl:(NSString *)url
              HTTPMethod:(NSString *)method
                  params:(NSDictionary *)params
              descriptor:(RKResponseDescriptor *)descriptor
            onCompletion:(void (^)(id))completionHandler
                 onError:(void (^)(NSError *))errorHandler;

- (void)getObjectFromUrl_:(NSString *)url
              HTTPMethod:(NSString *)method
                  params:(NSDictionary *)params
              descriptor:(RKObjectManager *)descriptor
            onCompletion:(void (^)(id))completionHandler
                 onError:(void (^)(NSError *))errorHandler;


- (void)getCollectionFromUrl:(NSString *)url
                  HTTPMethod:(NSString *)method
                      params:(NSDictionary *)params
                  descriptor:(RKResponseDescriptor *)descriptor
                onCompletion:(void (^)(NSArray *))completionHandler
                     onError:(void (^)(NSError *))errorHandler;

@end
