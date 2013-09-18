//
//  VCNotifications.m
//  BodyGraph
//
//  Created by Sreejesh MP on 24/07/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "VCNotifications.h"
#import "User.h"
#import "AppDelegate.h"
#import "VCFitmates.h"
#import "VCSettings.h"
#import "VCTrackImage.h"
#import "VCCampaign.h"
#import "VCInspire.h"
#import "VCMotivate.h"
#import "HUDManager.h"
#import "NotificationService.h"
#include "Notification.h"
#import "NotificationsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NotificationsMsgCell.h"
#import "FriendsService.h"

// NotificationsCell for Confirm friend request
// NotificationsMsgCell for comment/like or being friend notification
#define kNotificationsCellIdentifier @"NotificationsCell"
#define kNotificationsMsgCellIdentifier @"NotificationsMsgCell"

@interface VCNotifications ()
@property (nonatomic, strong) User *user;
@property(nonatomic, strong) Notifications *notifications;
@end

@implementation VCNotifications

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
       if (self)
       {
           self.user = [AppDelegate sharedDelegate].localUser;
       }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(self)
        self.tabBarItem.title = @"Notifications";
    
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
    

    self.navigationItem.title = @"Notifications";
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    
    NSInteger userId = [[NSUserDefaults standardUserDefaults] integerForKey:kUserIdKey];
    [[NotificationService sharedService] getNotificationData:userId withParams:nil
    onCompletion:^(Notifications *notifications) {
        self.notifications = notifications;
        [m_Notificatios reloadData];
        [hud hide:YES];
    }
    onError:^(NSError *error) {
        [hud hide:YES];
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

- (IBAction)btnInspire:(id)sender
{
    //VCInspire *vc = [[[VCInspire alloc] initWithNibName:@"VCInspire" bundle:nil] autorelease];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)btnMotivate:(id)sender
{
    VCMotivate *vc = [[VCMotivate alloc] initWithNibName:@"VCMotivate" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnTrack:(id)sender
{
    VCTrackImage *vc = [[VCTrackImage alloc] initWithNibName:@"VCTrackImage" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnCampaign:(id)sender
{
    VCCampaign *vc = [[VCCampaign alloc] initWithNibName:@"VCCampaign" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnFitmates:(id)sender
{
    VCFitmates *vc = [[VCFitmates alloc] initWithNibName:@"VCFitmates" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notifications.notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     Notification *notification = [[NSArray arrayWithArray:self.notifications.notifications] objectAtIndex:[indexPath row]];
    
    if(notification.type == 0)
    {
        NotificationsCell *cell = (NotificationsCell *)[m_Notificatios dequeueReusableCellWithIdentifier:kNotificationsCellIdentifier];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:kNotificationsCellIdentifier owner:self options:nil];
            cell = [nibs objectAtIndex:0];
        }
        
        cell.nameLabel.text = notification.user.nickname;
        cell.timeLabel.text = notification.duration;
        cell.descriptionLabel.text = notification.description;

        UIActivityIndicatorView *fitmateImageIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        fitmateImageIndicator.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        [fitmateImageIndicator setColor:[UIColor blackColor]];
        
        [fitmateImageIndicator removeFromSuperview];
        
        fitmateImageIndicator.center = CGPointMake(CGRectGetMidX(cell.fitmateImage.bounds), CGRectGetMidY(cell.fitmateImage.bounds));
        
        
        [cell.fitmateImage addSubview:fitmateImageIndicator];
        
        [fitmateImageIndicator startAnimating];
        
        
        [cell.fitmateImage setImageWithURL:[NSURL URLWithString:notification.user.pictureUrl] placeholderImage:[UIImage imageNamed:notification.user.pictureUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [fitmateImageIndicator setHidden:YES];
            [fitmateImageIndicator stopAnimating];
            
        }];
        
        [cell.btnAccept addTarget:self action:@selector(AddAcceptFriendRequest_Clicked:) forControlEvents:UIControlEventTouchDown];
        return cell;
    }
    else
    {
        NotificationsMsgCell *cell = (NotificationsMsgCell *)[m_Notificatios dequeueReusableCellWithIdentifier:kNotificationsMsgCellIdentifier];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:kNotificationsMsgCellIdentifier owner:self options:nil];
            cell = [nibs objectAtIndex:0];
        }
                
        cell.nameLabel.text = notification.user.nickname;
        cell.timeLabel.text = notification.duration;
        cell.descriptionLabel.text = notification.description;
        
        UIActivityIndicatorView *fitmateImageIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        fitmateImageIndicator.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        [fitmateImageIndicator setColor:[UIColor blackColor]];
        
        [fitmateImageIndicator removeFromSuperview];
        
        fitmateImageIndicator.center = CGPointMake(CGRectGetMidX(cell.fitmateImage.bounds), CGRectGetMidY(cell.fitmateImage.bounds));
        
        
        [cell.fitmateImage addSubview:fitmateImageIndicator];
        
        [fitmateImageIndicator startAnimating];
        
        
        [cell.fitmateImage setImageWithURL:[NSURL URLWithString:notification.user.pictureUrl] placeholderImage:[UIImage imageNamed:notification.user.pictureUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [fitmateImageIndicator setHidden:YES];
            [fitmateImageIndicator stopAnimating];
            
        }];
        
        if(notification.type == 1) // for comment notification icon
        {
            UIImage *btnImage = [UIImage imageNamed:@"Notifycomment.png"];
            [cell.btnType setBackgroundImage:btnImage forState:UIControlStateNormal];
        }
        else if(notification.type == 2) // Like notification icon
        {
            UIImage *btnImage = [UIImage imageNamed:@"notifyLike.png"];
            [cell.btnType setBackgroundImage:btnImage forState:UIControlStateNormal];
        }
        else  if(notification.type == 3) //Friend request accepted
        {
            UIImage *btnImage = [UIImage imageNamed:@"notifyRequestAccept.png"];
            [cell.btnType setBackgroundImage:btnImage forState:UIControlStateNormal];
        }
        
        return cell;
    }
    
}

- (IBAction)AddAcceptFriendRequest_Clicked:(UIButton*)button {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Accep Request...";
    
    CGPoint buttonOriginInTableView = [button convertPoint:CGPointZero toView:m_Notificatios];
    NSIndexPath *indexPath = [m_Notificatios indexPathForRowAtPoint:buttonOriginInTableView];
    
    Notification *notification = [[NSArray arrayWithArray:self.notifications.notifications] objectAtIndex:[indexPath row]];
    
    [[NotificationService sharedService] deleteNotification:notification.notificationId
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
                                       [NSNumber numberWithInt:notification.user.userId], @"friendId",
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
                                                        [self.notifications.notifications removeObjectAtIndex:[indexPath row]];                                                        
                                                        [m_Notificatios reloadData];
                                                        [hud hide:YES];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
@end
