//
//  TrackWeightViewController.m
//  BodyGraph
//
//  Created by Cai DaRong on 3/21/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "VCTrackWeight.h"
#import "VCSettings.h"
#import "VCStartCampaign.h"
#import "VCProfile.h"
#import "VCInspire.h"
#import "VCMotivate.h"
#import "VCTrackImage.h"
#import "VCCampaign.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "User.h"
#import "JournalService.h"

@interface VCTrackWeight ()

@property (nonatomic, strong) Journal *journal;

@end

@implementation VCTrackWeight

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithJournal:(Journal *)journal
{
    self = [super initWithNibName:@"VCTrackWeight" bundle:nil];
    if (self) {
        self.journal = journal;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
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
	
	NSDate *currentDate = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
	
	m_dayLabel.text = [NSString stringWithFormat:@"%d", dateComponents.day];
	m_monthLabel.text = [self monthStringWithValue:dateComponents.month];
	
    
    NSString *frontImageUrl = [NSString stringWithFormat:@"%@%@%@", kBaseUrl, @"/", self.journal.frontImageUrl];
    NSString *sideImageUrl = [NSString stringWithFormat:@"%@%@%@", kBaseUrl, @"/", self.journal.sideImageUrl];
    
	//[m_frontImageView setImageWithURL:[NSURL URLWithString: frontImageUrl]
    //                 placeholderImage:[UIImage imageNamed:frontImageUrl]];
	//[m_sideImageView setImageWithURL:[NSURL URLWithString:sideImageUrl]
    //                placeholderImage:[UIImage imageNamed:sideImageUrl]];
	
    
    
    
    UIActivityIndicatorView *frontImageIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIActivityIndicatorView *sideImageIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    frontImageIndicator.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    sideImageIndicator.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    [frontImageIndicator setColor:[UIColor whiteColor]];
    [sideImageIndicator  setColor:[UIColor whiteColor]];
    
    [frontImageIndicator removeFromSuperview];
    [sideImageIndicator  removeFromSuperview];
    
    frontImageIndicator.center = CGPointMake(CGRectGetMidX(m_frontImageView.bounds), CGRectGetMidY(m_frontImageView.bounds));
    sideImageIndicator.center  = CGPointMake(CGRectGetMidX(m_sideImageView.bounds),  CGRectGetMidY(m_sideImageView.bounds));
    
    
    [m_frontImageView addSubview:frontImageIndicator];
    [m_sideImageView  addSubview:sideImageIndicator];
    
    [frontImageIndicator startAnimating];
    [sideImageIndicator startAnimating];
    
    
    [m_frontImageView setImageWithURL:[NSURL URLWithString:frontImageUrl] placeholderImage:[UIImage imageNamed:frontImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [frontImageIndicator setHidden:YES];
        [frontImageIndicator stopAnimating];
        
    }];

    [m_sideImageView setImageWithURL:[NSURL URLWithString:sideImageUrl] placeholderImage:[UIImage imageNamed:sideImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [sideImageIndicator setHidden:YES];
        [sideImageIndicator stopAnimating];
        
    }];
    
    
    
    
    
    
	[m_plusBtn addTarget:self action:@selector(plusBtnClicked) forControlEvents:UIControlEventTouchDown];
	[m_plusBtn addTarget:self action:@selector(stopLongTapTimer) forControlEvents:UIControlEventTouchUpInside];
	
	[m_minusBtn addTarget:self action:@selector(minusBtnClicked) forControlEvents:UIControlEventTouchDown];
	[m_minusBtn addTarget:self action:@selector(stopLongTapTimer) forControlEvents:UIControlEventTouchUpInside];
	
    User *user = [AppDelegate sharedDelegate].localUser;
	self.navigationItem.title = [user.nickname isEqualToString:@""] ? @"Your Name" : user.nickname;
    m_weightLabel.text = [NSString stringWithFormat:@"%d",(int) user.activeCampaign.initialWeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backBtnClicked
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) menuBtnClicked
{
	VCSettings *vc = [[VCSettings alloc] initWithNibName:@"VCSettings" bundle:nil];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	[self presentModalViewController:nav animated:YES];
}

- (void) plusBtnClicked
{
	int weightInLbs = [m_weightLabel.text integerValue];
	weightInLbs++;
	m_weightLabel.text = [NSString stringWithFormat:@"%d", weightInLbs];
    self.journal.weight = weightInLbs;
	
	[self performSelector:@selector(startLongTapTimer) withObject:nil afterDelay:0.5];
}

- (void) minusBtnClicked
{
	int weightInLbs = [m_weightLabel.text integerValue];
	weightInLbs = MAX(0, --weightInLbs);
	m_weightLabel.text = [NSString stringWithFormat:@"%d", weightInLbs];
    self.journal.weight = weightInLbs;
	
	[self performSelector:@selector(startLongTapTimer) withObject:nil afterDelay:0.5];
}

- (IBAction) trackBtnClicked
{
    User *user = [AppDelegate sharedDelegate].localUser;
    self.journal.weight = [m_weightLabel.text integerValue];
    NSDictionary *journalDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSNumber numberWithFloat:self.journal.weight], @"weight", nil];
    [[JournalService sharedService] updateJournal:self.journal.journalId forUser:user.userId withParams:journalDict
    onCompletion:^(NSDictionary *result) {
        //user.activeCampaign.journals
        //NSMutableArray *journals = [[NSMutableArray alloc] init];
        //if( [result objectForKey:@"journals"] )
            //for( NSDictionary *journalDict in (NSArray *)[result objectForKey:@"journals"] ) {
                Journal *journal = [Journal fromDictionary:result];
                [user.activeCampaign.journals insertObject:journal atIndex:0];
                
            //}
        
        [AppDelegate sharedDelegate].localUser = user;
        //shinu
        VCInspire *vc = [[VCInspire alloc] initWithNibName:@"VCInspire" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    onError:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
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

- (NSString *) monthStringWithValue:(int)month
{
    NSString *months[12] = {
        @"JAN",
        @"FEB",
        @"MAR",
        @"APR",
        @"MAY",
        @"JUN",
        @"JUL",
        @"AUG",
        @"SEP",
        @"OCT",
        @"NOV",
        @"DEC"
    };
    
    return months[month-1];
}

@end