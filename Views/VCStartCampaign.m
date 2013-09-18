//
//  StartCampaignViewController.m
//  BodyGraph
//
//  Created by Cai DaRong on 2/14/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "VCStartCampaign.h" 
#import "VCTrackImage.h"
#import "VCSettings.h"
#import "Campaign.h"
#import "Journal.h"
#import "CampaignService.h"
#import "AppDelegate.h"
#import "VCProfile.h"

@interface VCStartCampaign ()

@property (nonatomic, strong) Campaign *campaign;
@property (nonatomic, strong) Journal *journal;

@end

@implementation VCStartCampaign

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.campaign = [[Campaign alloc] init];
        self.campaign.name = m_campaignNameLabel.text;
        self.campaign.isPublic = YES;
        self.campaign.isActive = YES;
        self.campaign.startDate = [NSDate date];
        self.campaign.initialWeight = [m_weightLabel.text integerValue];        
        
        self.journal = [[Journal alloc] init];
        self.journal.weight = [m_weightLabel.text integerValue];
        self.journal.date = [NSDate date];
        
        self.campaign.journals = [[NSMutableArray alloc] initWithObjects:self.journal, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.title = self.campaign.name;
	
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
	[menuBtn addTarget:self action:@selector(settingsBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	
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
    
    m_privateLabel.text = @"Public";
    [m_privateBtn setBackgroundImage:[UIImage imageNamed:@"unlockBtn.png"] forState:UIControlStateNormal];
	
	[m_plusBtn addTarget:self action:@selector(plusBtnClicked) forControlEvents:UIControlEventTouchDown];
	[m_plusBtn addTarget:self action:@selector(stopLongTapTimer) forControlEvents:UIControlEventTouchUpInside];
	
	[m_minusBtn addTarget:self action:@selector(minusBtnClicked) forControlEvents:UIControlEventTouchDown];
	[m_minusBtn addTarget:self action:@selector(stopLongTapTimer) forControlEvents:UIControlEventTouchUpInside];
}

- (void) backBtnClicked
{
	//[self.navigationController popViewControllerAnimated:YES];
    VCProfile *vc = [[VCProfile alloc] initWithNibName:@"VCProfile" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) settingsBtnClicked
{
	VCSettings *vc = [[VCSettings alloc] initWithNibName:@"VCSettings" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
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

- (void) plusBtnClicked
{
	int weightInLbs = [m_weightLabel.text integerValue];
	weightInLbs++;
	m_weightLabel.text = [NSString stringWithFormat:@"%d", weightInLbs];
    self.journal.weight = self.campaign.initialWeight = weightInLbs;
	
	[self performSelector:@selector(startLongTapTimer) withObject:nil afterDelay:0.5];
}

- (void) minusBtnClicked
{
	int weightInLbs = [m_weightLabel.text integerValue];
	weightInLbs = MAX(0, --weightInLbs);
	m_weightLabel.text = [NSString stringWithFormat:@"%d", weightInLbs];
    self.journal.weight = self.campaign.initialWeight = weightInLbs;
	
	[self performSelector:@selector(startLongTapTimer) withObject:nil afterDelay:0.5];
}

- (IBAction)ReturnKeyButton {
    [m_campaignNameLabel resignFirstResponder];
}


- (IBAction) beginJournalBtnClicked:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    
	self.journal.weight = self.campaign.initialWeight = [m_weightLabel.text integerValue];
    self.campaign.name = m_campaignNameLabel.text;
    
    NSDictionary *campaignDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  self.campaign.name, @"name",
                                  [NSNumber numberWithBool:self.campaign.isPublic], @"public",
                                  [NSNumber numberWithFloat:self.campaign.initialWeight], @"initial_weight",
                                  [NSNumber numberWithBool:self.campaign.isActive], @"active", nil];
    NSInteger userId = [AppDelegate sharedDelegate].localUser.userId;
    [[CampaignService sharedService] createCampaign:campaignDict forUser:userId
    onCompletion:^(Campaign *campaign) {
        [AppDelegate sharedDelegate].localUser.activeCampaign = campaign;
        [hud hide:YES];
        VCTrackImage *vc = [[VCTrackImage alloc] initWithNibName:@"VCTrackImage" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    onError:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [hud hide:YES];
        [alert show];
    }];
}

- (IBAction) privateBtnClicked:(id)sender
{
	self.campaign.isPublic = !self.campaign.isPublic;
	if ( self.campaign.isPublic )
	{
		m_privateLabel.text = @"Public";
		[m_privateBtn setBackgroundImage:[UIImage imageNamed:@"unlockBtn.png"] forState:UIControlStateNormal];
	}
	else
	{
		m_privateLabel.text = @"Private";
		[m_privateBtn setBackgroundImage:[UIImage imageNamed:@"lockBtn.png"] forState:UIControlStateNormal];
	}
}

- (void) longTapTimerProc
{
	if ( m_plusBtn.isHighlighted )
	{
		[self plusBtnClicked];
	}
	else if ( m_minusBtn.isHighlighted )
	{
		[self minusBtnClicked];
	}
	else
	{
		[m_longTapTimer invalidate];
		m_longTapTimer = nil;
	}
}

- (void) startLongTapTimer
{

}

- (void) stopLongTapTimer
{
	if ( m_longTapTimer )
	{
		[m_longTapTimer invalidate];
		m_longTapTimer = nil;
	}
}

- (void) gotoTrackImage
{
	VCTrackImage *vc = [[VCTrackImage alloc] initWithNibName:@"VCTrackImage" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
