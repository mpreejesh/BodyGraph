//
//  VCProfile.m
//  BodyGraph
//
//  Created by Cai DaRong on 4/3/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "VCProfile.h"
#import "VCSettings.h"
#import "VCInspire.h"
#import "VCLogin.h"
#import "VCViewCampaign.h"
#import "VCTrackImage.h"
#import "AppDelegate.h"
#import "User.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Cache.h"
#import "FitmateCell.h"
#import "UserService.h"
#import "HUDManager.h"
#import "VCJournalAddComments.h"
#import "FriendsService.h"

#define kCellIdentifier @"FitmateCell"

@interface VCProfile ()

@property (nonatomic, strong) User *user;

@end

@implementation VCProfile

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self ) {
        self.user = [AppDelegate sharedDelegate].localUser;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if(self)
        self.tabBarItem.title = @"Profile";
        
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
    
	
	for (UIView *view in self.view.subviews)
	{
		if ( [view isKindOfClass:[UILabel class]] )
		{
			UILabel *label = (UILabel *)view;
			[label setFont:[UIFont fontWithName:@"Capsuula" size:label.font.pointSize]];
		}
	}
    
   self.navigationItem.title = @"Profile";

        if( self.user == nil ) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        
        NSInteger userId = [[NSUserDefaults standardUserDefaults] integerForKey:kUserIdKey];
        [[UserService sharedService] getUserData:userId withParams:nil
        onCompletion:^(User *user) {
           
            [AppDelegate sharedDelegate].localUser = user;
            self.user = user;
            
            [m_myIcon setImageWithURL:[NSURL URLWithString:self.user.pictureUrl]
                     placeholderImage:[UIImage imageNamed:self.user.pictureUrl]];
            m_nameLabel.text = self.user.nickname;
           
            NSArray *friends = [NSArray arrayWithArray:self.user.friends];
            CGFloat baseSize = m_friendIconScroll.bounds.size.height;
            for( int i=0; i<friends.count; ++i ) {
                User *friend = [friends objectAtIndex:i];
                CGRect frame = CGRectMake(baseSize * i, 0, baseSize, baseSize);
                UIButton *button = [[UIButton alloc] initWithFrame:frame];
                button.tag = friend.userId;
                [button setImage:[UIImage loadFromCache:friend.pictureUrl shouldWrite:YES] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(selectFriend:) forControlEvents:UIControlEventTouchUpInside];
                [m_friendIconScroll addSubview:button];
            }
            
            if( self.user.activeCampaign == nil ) {
                [hud hide:YES];
                [self pushViewController:@"VCStartCampaign"];
            }
            else {
                NSDate *currentDate = self.user.activeCampaign.startDate;
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
                m_daysLabel.text = [NSString stringWithFormat:@"%d", dateComponents.day];
                int userWeight = (int) self.user.activeCampaign.finalWeight - self.user.activeCampaign.initialWeight;
                m_losedWeightLabel.text = [NSString stringWithFormat:@"%d", userWeight];
                m_campaignLabel.text = self.user.activeCampaign.name;
                [m_journalsTable reloadData];
                [hud hide:YES];
            }
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
     else
     {
          MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
          hud.labelText = @"Loading...";
         
          [[UserService sharedService] getJournalActivitiesByCampaign:self.user.activeCampaign.campaignId withParams:nil
          onCompletion:^(Campaign *campaign) {
              
              
              
              [m_myIcon setImageWithURL:[NSURL URLWithString:self.user.pictureUrl]
                       placeholderImage:[UIImage imageNamed:self.user.pictureUrl]];
              m_nameLabel.text = self.user.nickname;
              
              
              [[FriendsService sharedService] getFriendRequestsForUser:self.user.userId
               onCompletion:^(NSArray *array) {
                  self.user.friends = [NSMutableArray arrayWithArray:array];
                  
                  NSArray *friends = [NSArray arrayWithArray:self.user.friends];
                  CGFloat baseSize = m_friendIconScroll.bounds.size.height;
                  for( int i=0; i<friends.count; ++i ) {
                      User *friend = [friends objectAtIndex:i];
                      CGRect frame = CGRectMake(baseSize * i, 0, baseSize, baseSize);
                      UIButton *button = [[UIButton alloc] initWithFrame:frame];
                      button.tag = friend.userId;
                      [button setImage:[UIImage loadFromCache:friend.pictureUrl shouldWrite:YES] forState:UIControlStateNormal];
                      [button addTarget:self action:@selector(selectFriend:) forControlEvents:UIControlEventTouchUpInside];
                      [m_friendIconScroll addSubview:button];
                  }
              }
              onError:^(NSError *error) {
                  
                  NSArray *friends = [NSArray arrayWithArray:self.user.friends];
                  CGFloat baseSize = m_friendIconScroll.bounds.size.height;
                  for( int i=0; i<friends.count; ++i ) {
                      User *friend = [friends objectAtIndex:i];
                      CGRect frame = CGRectMake(baseSize * i, 0, baseSize, baseSize);
                      UIButton *button = [[UIButton alloc] initWithFrame:frame];
                      button.tag = friend.userId;
                      [button setImage:[UIImage loadFromCache:friend.pictureUrl shouldWrite:YES] forState:UIControlStateNormal];
                      [button addTarget:self action:@selector(selectFriend:) forControlEvents:UIControlEventTouchUpInside];
                      [m_friendIconScroll addSubview:button];
                  }

              }];
                            
              if( self.user.activeCampaign == nil ) {
                  [self pushViewController:@"VCStartCampaign"];
              }
              else {
              
                  NSDate *currentDate = self.user.activeCampaign.startDate; // 2013-07-11 09:39:16 2013-07-11 15:36:16 IST
                  NSCalendar *calendar = [NSCalendar currentCalendar];
                  NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
                  //NSString *abc=[NSString stringWithFormat:@"%d", dateComponents.day];
                  m_daysLabel.text = [NSString stringWithFormat:@"%d", dateComponents.day];
                  int userWeight = (int) self.user.activeCampaign.finalWeight - self.user.activeCampaign.initialWeight;
                  m_losedWeightLabel.text = [NSString stringWithFormat:@"%d", userWeight];
                  m_campaignLabel.text = self.user.activeCampaign.name;
                 
                  for (Journal *journal_ in  campaign.journals) {
                      [self setJournalActivities:journal_.journalId Duration:journal_.Duration CommentsCount:journal_.comments_count LikesCount:journal_.likes_count];
                  }
                  
                  [m_journalsTable reloadData];
                 
                  [hud hide:YES];
              }
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

}


- (IBAction)selectFriend:(UIButton*)button {
    
}
- (void)setJournalActivities:(NSInteger)jid Duration:(NSString *)duration CommentsCount:(NSInteger)c_count LikesCount:(NSInteger)l_count
{
      for (Journal *journal_ in  self.user.activeCampaign.journals) {
          if(journal_.journalId == jid)
          {
              journal_.Duration = duration;
              journal_.comments_count = c_count;
              journal_.likes_count = l_count;
              break;
          }
      }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.user.activeCampaign.journals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FitmateCell *cell = (FitmateCell *)[m_journalsTable dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FitmateCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
    }
    
    Journal *journal = [[NSArray arrayWithArray:self.user.activeCampaign.journals] objectAtIndex:[indexPath row]];
    cell.tag = journal.journalId;
    cell.nameLabel.text = self.user.nickname;
    cell.timeLabel.text = journal.Duration;
    
    NSString *frontImageUrl = [NSString stringWithFormat:@"%@%@%@", kBaseUrl, @"/", journal.frontImageUrl];
    NSString *sideImageUrl = [NSString stringWithFormat:@"%@%@%@", kBaseUrl, @"/", journal.sideImageUrl];
    
    //cell.progressLabel.text = [NSString stringWithFormat:@"%d", (int)(journal.weight - self.user.activeCampaign.initialWeight)];
    cell.frontImage.image = nil;
    cell.sideImage.image = nil;
    
//    [cell.frontImage setImageWithURL:[NSURL URLWithString:frontImageUrl]
//                    placeholderImage:[UIImage imageNamed:frontImageUrl]];
//    [cell.sideImage setImageWithURL:[NSURL URLWithString:sideImageUrl]
//                    placeholderImage:[UIImage imageNamed:sideImageUrl]];
    
    UIActivityIndicatorView *frontImageIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIActivityIndicatorView *sideImageIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    frontImageIndicator.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    sideImageIndicator.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    [frontImageIndicator setColor:[UIColor whiteColor]];
    [sideImageIndicator  setColor:[UIColor whiteColor]];
    
    [frontImageIndicator removeFromSuperview];
    [sideImageIndicator  removeFromSuperview];

    frontImageIndicator.center = CGPointMake(CGRectGetMidX(cell.frontImage.bounds), CGRectGetMidY(cell.frontImage.bounds));
    sideImageIndicator.center  = CGPointMake(CGRectGetMidX(cell.sideImage.bounds),  CGRectGetMidY(cell.sideImage.bounds));

    
    [cell.frontImage addSubview:frontImageIndicator];
    [cell.sideImage  addSubview:sideImageIndicator];

    [frontImageIndicator startAnimating];
    [sideImageIndicator startAnimating];

    
    [cell.frontImage setImageWithURL:[NSURL URLWithString:frontImageUrl] placeholderImage:[UIImage imageNamed:frontImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [frontImageIndicator setHidden:YES];
        [frontImageIndicator stopAnimating];
        
    }];
    
    [cell.sideImage setImageWithURL:[NSURL URLWithString:sideImageUrl] placeholderImage:[UIImage imageNamed:sideImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [sideImageIndicator setHidden:YES];
        [sideImageIndicator stopAnimating];
        
    }];
    
    cell.commentsLabel.text = (NSString *)[NSString stringWithFormat:@"%d", (int)journal.comments_count];
    cell.likesLabel.text = (NSString *)[NSString stringWithFormat:@"%d", (int)journal.likes_count];
    cell.weightLabel.text = (NSString *)[NSString stringWithFormat:@"%d", (int)journal.weight];
    
    cell.btnComment.tag = [indexPath row];
    [cell.btnComment addTarget:self action:@selector(ShowComment_Clicked:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}

- (IBAction)ShowComment_Clicked:(UIButton*)button {
    //NSLog(@"indexPath.row value : %d", button.tag);
    VCJournalAddComments *vc= [[VCJournalAddComments alloc] initWithNibName:@"VCJournalAddComments" bundle:nil];
    Journal *journal = [[NSArray arrayWithArray:self.user.activeCampaign.journals] objectAtIndex:button.tag];
    [vc setJournalId:journal nickName:self.user.nickname journalOwnerId:self.user.userId];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void) backBtnClicked
{
	//[self.navigationController popViewControllerAnimated:YES];
    VCInspire *vc= [[VCInspire alloc] initWithNibName:@"VCInspire" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void) menuBtnClicked
{
	VCSettings *vc = [[VCSettings alloc] initWithNibName:@"VCSettings" bundle:nil];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	[self presentModalViewController:nav animated:YES];
}

- (IBAction)btnCampaign:(id)sender {
    VCViewCampaing *vc = [[VCViewCampaing alloc] initWithNibName:@"VCViewCampaign" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnTrackImage:(id)sender {
    VCTrackImage *vc = [[VCTrackImage alloc] initWithNibName:@"VCTrackImage" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushViewController:(NSString*)name
{
    UIViewController *viewController = [[NSClassFromString(name) alloc] initWithNibName:name bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
