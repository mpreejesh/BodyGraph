//
//  AppDelegate.m
//  BodyGraph
//
//  Created by Cai DaRong on 2/13/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "AppDelegate.h"
#import "AuthService.h"

@implementation AppDelegate

+ (AppDelegate *)sharedDelegate
{
	return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // Checking for an authorized user (saved token)
    NSString *accessToken = [[AuthService sharedServiceWithContext:kSecurityContext] getAccessToken];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserIdKey];
    NSString *viewName = accessToken == nil || userId == nil ? @"VCLogin" : @"VCProfile";
    UIViewController *viewController = [[NSClassFromString(viewName) alloc] initWithNibName:viewName bundle:nil];
    
    // Changing UI appearance
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBkgnd.png"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *navBarTitleTextSetting = [NSDictionary dictionaryWithObjectsAndKeys:
											[UIColor colorWithRed:175.0f/256.0f green:219.0f/256.0f blue:74.0f/256.0f alpha:1.0f], UITextAttributeTextColor,
											[UIFont fontWithName:@"Capsuula" size:23.0f], UITextAttributeFont,
											nil];
	[[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextSetting];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    // start of your application:didFinishLaunchingWithOptions // ...
    [TestFlight takeOff:@"71d84dbb-8f4a-45c1-a7e1-cccab13b2c54"];
    // The rest of your application:didFinishLaunchingWithOptions method// ...
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
