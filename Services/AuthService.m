//
//  AuthService.m
//  BodyGraph
//
//  Created by Nelson Chicas on 4/19/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import "AuthService.h"
#import <RestKit/RestKit.h>
#import <Security/Security.h>
#import "KeychainItemWrapper.h"

static NSMutableDictionary *sharedInstances = nil;

@interface AuthService()

@property (nonatomic, strong) KeychainItemWrapper *keychain;

@end

@implementation AuthService

// Get the shared instance and create it if necessary.
+ (AuthService *)sharedServiceWithContext:(NSString *)context {
    if( sharedInstances == nil ) {
        sharedInstances = [[NSMutableDictionary alloc] init];
    }
    
    AuthService *instance = (AuthService *)[sharedInstances objectForKey:context];
    
    if (instance == nil) {
        instance = [[AuthService alloc] initWithContext:context];
        instance.baseUrl = kBaseUrl;
        [sharedInstances setObject:instance forKey:context];
    }
    
    return instance;
}

#pragma mark NSObject

- (id)init
{
	if( ( self = [super init] ) ) {
        self.baseUrl = kBaseUrl;
	}
	return self;
}

- (id)initWithContext:(NSString *)context
{
	if( ( self = [super init] ) ) {
        self.keychain = [[KeychainItemWrapper alloc] initWithIdentifier:context accessGroup:nil]; //shinu
        [self.keychain setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible]; //shinu
        
        //[self.keychain resetKeychainItem]; //shinu remove this line
	}
	return self;
}

#pragma mark - Facebook SDK

- (void)registerWithParams:(NSDictionary *)params
              onCompletion:(void (^)(User *))completionHandler
                   onError:(void (^)(NSError *))errorHandler
{
    NSString *email = [params objectForKey:@"email"];
    NSString *password = [params objectForKey:@"password"];
    
    [self requestWithUrl:kRegisterUrl
              HTTPMethod:@"POST"
                  params:params
    onCompletion:^(NSDictionary *result) {
        [self.keychain setObject:email forKey:(__bridge id)kSecAttrAccount];
        [self.keychain setObject:password forKey:(__bridge id)kSecValueData];
        [self.keychain setObject:[result objectForKey:@"token"] forKey:(__bridge id)kSecAttrService];
        
        User *user = [User fromDictionary:(NSDictionary *)[result objectForKey:@"user"]];
        completionHandler(user);
    }
    onError:errorHandler];    
    
}

- (void)loginWithParams:(NSDictionary *)params
           onCompletion:(void (^)(User *user))completionHandler
                onError:(void (^)(NSError *))errorHandler
{
    NSString *email = [params objectForKey:@"email"];
    NSString *password = [params objectForKey:@"password"];
    //NSString *abc = kLoginUrl;
    
    [self requestWithUrl:kLoginUrl
              HTTPMethod:@"POST"
                  params:params
    onCompletion:^(NSDictionary *result) {
        [self.keychain setObject:email forKey:(__bridge id)kSecAttrAccount];
        [self.keychain setObject:password forKey:(__bridge id)kSecValueData];
        [self.keychain setObject:[result objectForKey:@"token"] forKey:(__bridge id)kSecAttrService];
        
        User *user = [User fromDictionary:(NSDictionary *)[result objectForKey:@"user"]];
        completionHandler(user);
    }
    onError:errorHandler];
}

- (void)logout
{
    [self.keychain resetKeychainItem];
}

- (NSString *)getUsername
{
    return (NSString *)[self.keychain objectForKey:(__bridge id)kSecAttrAccount];
}

- (NSString *)getPassword
{
    return (NSString *)[self.keychain objectForKey:(__bridge id)kSecValueData];
}

- (NSString *)getAccessToken
{
    return (NSString *)[self.keychain objectForKey:(__bridge id)kSecAttrService];
}

@end

