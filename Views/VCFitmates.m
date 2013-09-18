//
//  VCFitmates.m
//  BodyGraph
//
//  Created by Rony Vasquez on 10/05/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "VCFitmates.h"
#import "VCSettings.h"
#import "VCAddFitMates.h"
#import "VCInspire.h"
#import "VCNotifications.h"
#import "MKNumberBadgeView.h"
#import <QuartzCore/QuartzCore.h>
#import "VCNotifications.h"
#import "NotificationService.h"

@interface VCFitmates ()

@end

@implementation VCFitmates

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(self){
        self.tabBarItem.title = @"My Fitmates";
        
        for (UIView *view in self.view.subviews)
        {
            if ( [view isKindOfClass:[UILabel class]] )
            {
                UILabel *label = (UILabel *)view;
                [label setFont:[UIFont fontWithName:@"Capsuula" size:label.font.pointSize]];
            }
        }

        
        
        /// back button
        UIImage *imgBack = [UIImage imageNamed:@"backBtn.png"];
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setBackgroundImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateHighlighted];
        [backButton setFrame:CGRectMake(0, 0, imgBack.size.width, imgBack.size.height)];
        [backButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        
        /// menu btn
        UIImage *menuImage = [UIImage imageNamed:@"menuBtn.png"];
        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuBtn.png"] forState:UIControlStateNormal];
        [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuBtn.png"] forState:UIControlStateHighlighted];
        [menuBtn setFrame:CGRectMake(0, 0, menuImage.size.width, menuImage.size.height)];
        [menuBtn addTarget:self action:@selector(menuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        /// menu btn
        UIImage *notificationImage = [UIImage imageNamed:@"notification.png"];
        UIButton *notificationBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [notificationBtn setFrame:CGRectMake(0, 0, notificationImage.size.width-8, notificationImage.size.height-8)];
        notificationBtn.layer.cornerRadius = 10;
        [notificationBtn setBackgroundImage:[UIImage imageNamed:@"notification.png"] forState:UIControlStateNormal];
        [notificationBtn setBackgroundImage:[UIImage imageNamed:@"notification.png"] forState:UIControlStateHighlighted];
        [notificationBtn addTarget:self action:@selector(notificationBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
        UIBarButtonItem *notificationButton = [[UIBarButtonItem alloc] initWithCustomView:notificationBtn];
        
        NSInteger userId = [[NSUserDefaults standardUserDefaults] integerForKey:kUserIdKey];
        [[NotificationService sharedService] getNotificationCount:userId
        onCompletion:^(NSDictionary *dict)
        {
            if(dict != nil)
            {
                NSInteger count = [(NSString *) [dict objectForKey:@"count"] intValue];
                if(count != 0)
                {
                    MKNumberBadgeView *number = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(25, -4, 33,25)];
                    number.value = count;
                    [notificationBtn addSubview:number];
                }
            }
        } onError:^(NSError *error)
        {
            
        }];
       

        
        self.navigationItem.rightBarButtonItems = @[menuButtonItem, notificationButton];
        
        for (UIView *view in self.view.subviews)
        {
            if ( [view isKindOfClass:[UILabel class]] )
            {
                UILabel *label = (UILabel *)view;
                [label setFont:[UIFont fontWithName:@"Capsuula" size:label.font.pointSize]];
            }
        }
        
        self.navigationItem.title = @"My Fitmates";
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnAdd:nil];
    [self setBtnPicture:nil];
    [self setBtnStatus:nil];
    [super viewDidUnload];
}
- (void) backBtnClicked
{
    UIViewController *viewController = [[NSClassFromString(@"VCInspire") alloc] initWithNibName:@"VCInspire" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
	//[self.navigationController popViewControllerAnimated:YES];
}

- (void) menuBtnClicked
{
	VCSettings *vc = [[VCSettings alloc] initWithNibName:@"VCSettings" bundle:nil];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	[self presentModalViewController:nav animated:YES];
}

- (void) notificationBtnClicked
{
	VCNotifications *vc = [[VCNotifications alloc] initWithNibName:@"VCNotifications" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnAddFitmates:(id *)sender {
    VCAddFitMates *vc = [[VCAddFitMates alloc] initWithNibName:@"VCAddFitMates" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)notificationBtnClicked:(id*)sender
{
    VCNotifications *vc = [[VCNotifications alloc] initWithNibName:@"VCNotifications" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
