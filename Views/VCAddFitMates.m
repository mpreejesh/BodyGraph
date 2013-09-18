//
//  VCAddFitMates.m
//  BodyGraph
//
//  Created by Kodemint on 24/07/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "VCAddFitMates.h"
#import "AppDelegate.h"
#import "VCFitmates.h"
#import "VCSettings.h"
#import "User.h"
#import "FitMatesService.h"
#import "VCLogin.h"
#include "HUDManager.h"
#include "AddFitmateCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Cache.h"
#import "NotificationService.h"
//#import "FitmatesForAdd.h"
#import "FriendsService.h"

#define kCellIdentifier @"AddFitmateCell"

@interface VCAddFitMates ()
@property (nonatomic, strong) User *user;
@property(nonatomic, strong) FitMates *fitmates;
@property(nonatomic, strong) NSMutableArray *sectionNames;
@property(nonatomic, strong) NSMutableArray *sectionCounts;
@end


@implementation VCAddFitMates


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.user = [AppDelegate sharedDelegate].localUser;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self)
        self.tabBarItem.title = @"Add Fitmates";
    
    _sectionNames = [NSMutableArray array];
    _sectionCounts = [NSMutableArray array];

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
	
	UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
	self.navigationItem.rightBarButtonItem = menuButtonItem;
    
	
//	for (UIView *view in self.view.subviews)
//	{
//		if ( [view isKindOfClass:[UILabel class]] )
//		{
//			UILabel *label = (UILabel *)view;
//			[label setFont:[UIFont fontWithName:@"Capsuula" size:label.font.pointSize]];
//		}
//	}
    
    [self loadUsers];

    self.navigationItem.title = @"Add Fitmates";

}

-(void)loadUsers
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    NSInteger userId = [[NSUserDefaults standardUserDefaults] integerForKey:kUserIdKey];
    [[FitMatesService sharedService] getFitmatesForAddData:userId withParams:nil
                                              onCompletion:^(FitMates *fitmates) {
                                                  self.fitmates = fitmates;
                                                  [_sectionNames removeAllObjects];
                                                  [_sectionCounts removeAllObjects];
                                                  [m_Users reloadData];
                                                  [hud hide:YES];
                                              }
                                                   onError:^(NSError *error) {
                                                       [hud hide:YES];
                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                                                                       message:[error localizedDescription]
                                                                                                      delegate:nil
                                                                                             cancelButtonTitle:@"OK"
                                                                                             otherButtonTitles:nil];
                                                       [alert show];
                                                       
                                                       VCLogin *vc = [[VCLogin alloc] initWithNibName:@"VCLogin" bundle:nil];
                                                       [vc forcelogin];
                                                       [self.navigationController pushViewController:vc animated:YES];
                                                       
                                                   }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backBtnClicked
{
    VCFitmates *vc= [[VCFitmates alloc] initWithNibName:@"VCFitmates" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void) menuBtnClicked
{
	VCSettings *vc = [[VCSettings alloc] initWithNibName:@"VCSettings" bundle:nil];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	[self presentModalViewController:nav animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 0;

    if(self.fitmates.phoneCount != 0)
    {
        [_sectionNames addObject:([NSString stringWithFormat:@"%@%d%@", @"From Phone(", self.fitmates.phoneCount,@")"])];
        [_sectionCounts addObject:[NSNumber numberWithInt:self.fitmates.phoneCount]];
        count++;
    }
    if(self.fitmates.fbCount != 0)
    {
        [_sectionNames addObject:([NSString stringWithFormat:@"%@%d%@", @"From Facebook(", self.fitmates.fbCount,@")"])];
        [_sectionCounts addObject:[NSNumber numberWithInt:self.fitmates.fbCount]];
        count++;
    }
    if(self.fitmates.twitterCount != 0)
    {
        [_sectionNames addObject:([NSString stringWithFormat:@"%@%d%@", @"From Twitter(", self.fitmates.twitterCount,@")"])];
        [_sectionCounts addObject:[NSNumber numberWithInt:self.fitmates.twitterCount]];
        count++;
    }
    
    return (count == 0) ? 0 : count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //if(section == 0)
        return (self.fitmates == nil) ? 0 : [(NSString *) [_sectionCounts objectAtIndex:section] intValue];
    //else if(section == 1)
    //    return (self.fitmates == nil) ? 0 : self.fitmates.fbCount;
    //else if(section == 2)
    //    return (self.fitmates == nil) ? 0 : self.fitmates.twitterCount;
    //else
    //    return (self.fitmates == nil) ? 0 : self.fitmates.fitmates.count;

    //return self.fitmates.fitmates.count;
}

-(FitmatesForAdd *)getFitmate:(NSIndexPath *)indexPath
{
    FitmatesForAdd *fitmate = nil;
    if([indexPath section] == 0)
    {
        if(self.fitmates.phoneCount != 0)
            fitmate = [[NSArray arrayWithArray:self.fitmates.fitmatesPhone] objectAtIndex:[indexPath row]];
        else if(self.fitmates.fbCount != 0)
            fitmate = [[NSArray arrayWithArray:self.fitmates.fitmatesFacebook] objectAtIndex:[indexPath row]];
        else if(self.fitmates.twitterCount != 0)
            fitmate = [[NSArray arrayWithArray:self.fitmates.fitmatesTwitter] objectAtIndex:[indexPath row]];
    }
    else if([indexPath section] == 1)
    {
        if(self.fitmates.fbCount != 0)
            fitmate = [[NSArray arrayWithArray:self.fitmates.fitmatesFacebook] objectAtIndex:[indexPath row]];
        else if(self.fitmates.twitterCount != 0)
            fitmate = [[NSArray arrayWithArray:self.fitmates.fitmatesTwitter] objectAtIndex:[indexPath row]];
    }
    else
    {
        fitmate = [[NSArray arrayWithArray:self.fitmates.fitmatesTwitter] objectAtIndex:[indexPath row]];
    }
    return fitmate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddFitmateCell *cell = (AddFitmateCell *)[m_Users dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:kCellIdentifier owner:self options:nil];
        cell = [nibs objectAtIndex:0];
    }
    
    FitmatesForAdd *fitmates = [self getFitmate:indexPath];
        
    cell.labelName.text = fitmates.nickname;
    cell.labelCampaign.text = fitmates.campaign;
    cell.labelCommom.text = fitmates.common;
        
    if([fitmates.action isEqual: @"null"]) // send friend request
    {
        UIImage *btnImage = [UIImage imageNamed:@"btnAddMates.png"];
        [cell.btnAddMate setBackgroundImage:btnImage forState:UIControlStateNormal];
    }
    else if([fitmates.action isEqual:@"0"]) // Cancel friend request
    {
        UIImage *btnImage = [UIImage imageNamed:@"btnCancelRequest.png"];
        [cell.btnAddMate setBackgroundImage:btnImage forState:UIControlStateNormal];
    }
    else //confirm friend request
    {
        UIImage *btnImage = [UIImage imageNamed:@"btnConfirmRequest.png"];
        [cell.btnAddMate setBackgroundImage:btnImage forState:UIControlStateNormal];
    }

    
    UIActivityIndicatorView *fitmateImageIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    fitmateImageIndicator.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    [fitmateImageIndicator setColor:[UIColor blackColor]];
    
    [fitmateImageIndicator removeFromSuperview];
    
    fitmateImageIndicator.center = CGPointMake(CGRectGetMidX(cell.fitmateImage.bounds), CGRectGetMidY(cell.fitmateImage.bounds));
    
    
    [cell.fitmateImage addSubview:fitmateImageIndicator];
    
    [fitmateImageIndicator startAnimating];
    
    
    [cell.fitmateImage setImageWithURL:[NSURL URLWithString:fitmates.picture_url] placeholderImage:[UIImage imageNamed:fitmates.picture_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [fitmateImageIndicator setHidden:YES];
        [fitmateImageIndicator stopAnimating];
        
    }];
    
    cell.btnAddMate.tag = fitmates.userId;
    [cell.btnAddMate addTarget:self action:@selector(AddFitmateCell_Clicked:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //if(section == 0)
        return (self.fitmates == nil) ? @"" : [_sectionNames objectAtIndex:section];// [NSString stringWithFormat:@"%@%d%@", @"From Phone(", self.fitmates.phoneCount,@")"];
    //else if(section == 1)
    //    return (self.fitmates == nil) ? @"" : [_sectionNames objectAtIndex:section];//[NSString stringWithFormat:@"%@%d%@", @"From Facebook(", self.fitmates.fbCount,@")"];
    //else if(section == 2)
    //    return (self.fitmates == nil) ? @"" : [_sectionNames objectAtIndex:section];//[NSString stringWithFormat:@"%@%d%@", @"From Twitter(", self.fitmates.twitterCount,@")"];
    //else
    //    return (self.fitmates == nil) ? @"" : @"All";

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}
- (IBAction)AddFitmateCell_Clicked:(UIButton*)button {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSString *desc = @"Add you as Fitmate";
    
    CGPoint buttonOriginInTableView = [button convertPoint:CGPointZero toView:m_Users];
    NSIndexPath *indexPath = [m_Users indexPathForRowAtPoint:buttonOriginInTableView];
    
    FitmatesForAdd *fitmates = [self getFitmate:indexPath];
    
    if([fitmates.action isEqual: @"null"]) // send friend request
    {
        hud.labelText = @"Sending Request...";
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSNumber numberWithInteger:self.user.userId], @"from_user_id",
                                [NSNumber numberWithInt:fitmates.userId], @"to_user_id",
                                [NSNumber numberWithInt:0], @"type",
                                desc, @"description",
                                [NSNumber numberWithInt:0], @"isread",
                                nil];
        
        [[NotificationService sharedService]  createNotification:params
            onCompletion:^(NSDictionary *dict) {
                if(dict != nil)
                {
                    NSString *result = (NSString *)[dict objectForKey:@"success"];
                    if(![result isEqual:@"false"])
                    {
                        UIImage *btnImage = [UIImage imageNamed:@"btnCancelRequest.png"];
                        [button setBackgroundImage:btnImage forState:UIControlStateNormal];
                        fitmates.notificationId = [(NSString *) result intValue];
                        fitmates.action = @"0";
                        [hud hide:YES];
                    }
                }
            } onError:^(NSError *error) {
                [hud hide:YES];
            }];
    }
    else if([fitmates.action isEqual:@"0"]) // Cancel friend request
    {
        hud.labelText = @"Cancel Request...";
       [[NotificationService sharedService] deleteNotification:fitmates.notificationId onCompletion:^(NSDictionary *dict)
        {
           NSString *result = (NSString *)[dict objectForKey:@"success"];
            if([result isEqual:@"true"])
            {
                UIImage *btnImage = [UIImage imageNamed:@"btnAddMates.png"];
                [button setBackgroundImage:btnImage forState:UIControlStateNormal];
                fitmates.notificationId = [(NSString *) @"0" intValue];
                fitmates.action = @"null";
                [hud hide:YES];
            }
        }
        onError:^(NSError *error)
        {
           [hud hide:YES];
        }];
    }
    else if([fitmates.action isEqual:@"1"]) //confirm friend request
    {
        hud.labelText = @"Accept Request...";
        [[NotificationService sharedService] deleteNotification:(NSInteger)fitmates.notificationId
                                                   onCompletion:^(NSDictionary *dictionary)
         {
             
             if(dictionary != nil)
             {
                 NSString *result = (NSString *)[dictionary objectForKey:@"success"];
                 if([result isEqual:@"true"])
                 {
                     NSInteger userId = [[NSUserDefaults standardUserDefaults] integerForKey:kUserIdKey];
                     NSString *desc = @"Accepted being your FitMate";
                     NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             [NSNumber numberWithInt:fitmates.userId], @"friendId",
                                             [NSNumber numberWithInt:3], @"type",
                                             desc, @"description",
                                             [NSNumber numberWithInt:0], @"isread",
                                             nil];
                     
                     [[FriendsService sharedService] addFriend:userId param:params
                                                  onCompletion:^(NSDictionary *dict) {
                                                      if(dict != nil)
                                                      {
                                                          NSString *result = (NSString *)[dict objectForKey:@"success"];
                                                          if(![result isEqual:@"false"]) {
                                                              [hud hide:YES];
                                                              [self loadUsers];
                                                          }
                                                      }
                                                  } onError:^(NSError *error) {
                                                      [hud hide:YES];
                                                  }];
                 }
             }
         } onError:^(NSError *error) {
             [hud hide:YES];
         }];
    }
    
   
}
@end
