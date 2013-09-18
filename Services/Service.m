//
//  Service.m
//  BodyGraph
//
//  Created by Nelson Chicas on 5/5/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import "Service.h"
#import <RestKit/RestKit.h>

@interface Service ()

- (NSURLRequest *)createRequestWithUrl:(NSString *)url
                                params:(NSDictionary *)params
                            HTTPMethod:(NSString *)method;

@end

@implementation Service

- (NSURLRequest *)createRequestWithUrl:(NSString *)url
                                params:(NSDictionary *)params
                            HTTPMethod:(NSString *)method
{
    NSURL *URL = [[NSURL alloc] initWithString:self.baseUrl];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:URL];
    
    NSMutableURLRequest *request = [client requestWithMethod:method
                                                        path:url
                                                  parameters:params];
    
    return request;
}

- (void)requestWithUrl:(NSString *)url
            HTTPMethod:(NSString *)method
                params:(NSDictionary *)params
          onCompletion:(void (^)(NSDictionary *))completionHandler
               onError:(void (^)(NSError *))errorHandler
{
    NSURLRequest *request = [self createRequestWithUrl:url params:params HTTPMethod:method];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        NSDictionary *dict = (NSDictionary *)json;
        
        if( completionHandler ) {
            completionHandler( dict );
        }
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
        NSDictionary *dict = (NSDictionary *)json;
        if( dict && [dict objectForKey:@"error"] ) {
            NSDictionary *dict = (NSDictionary *)json;
            NSInteger code = (NSInteger)[dict objectForKey:@"code"];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setValue:[dict objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *e = [[NSError alloc] initWithDomain:@"App" code:code userInfo:userInfo];
            error = e;
        }
        
        if( errorHandler ) {
            errorHandler( error );
        }
    }];
    
    [operation setJSONReadingOptions:NSJSONReadingAllowFragments];
    [operation start];
}

- (void)getObjectFromUrl:(NSString *)url
              HTTPMethod:(NSString *)method
                  params:(NSDictionary *)params
              descriptor:(RKResponseDescriptor *)descriptor
            onCompletion:(void (^)(id))completionHandler
                 onError:(void (^)(NSError *))errorHandler
{
    NSURLRequest *request = [self createRequestWithUrl:url params:params HTTPMethod:method];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc]
                                                        initWithRequest:request
                                                        responseDescriptors:@[ descriptor ]];
    [objectRequestOperation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         if( completionHandler ) {
             completionHandler( mappingResult.firstObject );
         }
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error) {
         if( errorHandler ) {
             errorHandler( error );
         }
     }];
    
    [objectRequestOperation start];
}

- (void)getObjectFromUrl_:(NSString *)url
              HTTPMethod:(NSString *)method
                  params:(NSDictionary *)params
              descriptor:(RKObjectManager *)descriptor
            onCompletion:(void (^)(id))completionHandler
                 onError:(void (^)(NSError *))errorHandler
{
    NSURLRequest *request = [self createRequestWithUrl:url params:params HTTPMethod:method];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc]
                                                        initWithRequest:request
                                                        responseDescriptors:@[ descriptor ]];
    [objectRequestOperation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         if( completionHandler ) {
             completionHandler( mappingResult.firstObject );
         }
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error) {
         if( errorHandler ) {
             errorHandler( error );
         }
     }];
    
    [objectRequestOperation start];
}

- (void)getCollectionFromUrl:(NSString *)url
                  HTTPMethod:(NSString *)method
                      params:(NSDictionary *)params
                  descriptor:(RKResponseDescriptor *)descriptor
                onCompletion:(void (^)(NSArray *))completionHandler
                     onError:(void (^)(NSError *))errorHandler
{
    NSURLRequest *request = [self createRequestWithUrl:url params:params HTTPMethod:method];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc]
                                                        initWithRequest:request
                                                        responseDescriptors:@[ descriptor ]];
    [objectRequestOperation
     setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         if( completionHandler ) {
             completionHandler( mappingResult.array );
         }
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error) {
         if( errorHandler ) {
             errorHandler( error );
         }
     }];
    
    [objectRequestOperation start];
}

@end
