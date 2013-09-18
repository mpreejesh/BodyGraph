//
//  SettingsViewController.m
//  BodyGraph
//
//  Created by Cai DaRong on 3/21/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "VCSettings.h"
//#import "WebViewController.h"
#import "FacebookManager.h"
#import "TwitterManager.h"
#import "iRate.h"

@interface VCSettings ()

@end

@implementation VCSettings

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.navigationItem.title = @"Settings";
	
	/// back button
	UIImage *imgBack = [UIImage imageNamed:@"backBtn.png"];
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setBackgroundImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
	[backButton setBackgroundImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateHighlighted];
	[backButton setFrame:CGRectMake(0, 0, imgBack.size.width, imgBack.size.height)];
	[backButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	self.navigationItem.leftBarButtonItem = backButtonItem;
	
	BOOL fbShare = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShareOnFacebook"];
    
    BOOL twShare = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShareOnTwitter"];
	
	NSString *facebookImageName = fbShare ? @"onBtn.png" : @"offBtn.png";
	[m_facebookBtn setBackgroundImage:[UIImage imageNamed:facebookImageName] forState:UIControlStateNormal];
	
	NSString *twitterImageName = twShare ? @"onBtn.png" : @"offBtn.png";
	[m_twitterBtn setBackgroundImage:[UIImage imageNamed:twitterImageName] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backBtnClicked
{
	[self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) facebookBtnClicked
{
    BOOL fbShare = ![[NSUserDefaults standardUserDefaults] boolForKey:@"ShareOnFacebook"];
	[[NSUserDefaults standardUserDefaults] setBool:fbShare forKey:@"ShareOnFacebook"];
	
	NSString *facebookImageName = fbShare? @"onBtn.png" : @"offBtn.png";
	[m_facebookBtn setBackgroundImage:[UIImage imageNamed:facebookImageName] forState:UIControlStateNormal];
}

- (IBAction) twitterBtnClicked
{
	BOOL twShare = ![[NSUserDefaults standardUserDefaults] boolForKey:@"ShareOnTwitter"];
	[[NSUserDefaults standardUserDefaults] setBool:twShare forKey:@"ShareOnTwitter"];
	
	NSString *twitterImageName = twShare ? @"onBtn.png" : @"offBtn.png";
	[m_twitterBtn setBackgroundImage:[UIImage imageNamed:twitterImageName] forState:UIControlStateNormal];
}

- (IBAction) unitBtnClicked
{
	
}

- (IBAction) myAccountBtnClicked
{
}

- (IBAction) rateBtnClicked
{
    [iRate sharedInstance].applicationBundleID = @"com.applits.BodyGraph";
    [[iRate sharedInstance] promptForRating];
}

- (IBAction) termsBtnClicked
{
    /*NSString *url = @"http://bodygraphpapp.com/docs/terms-of-service.html";
    WebViewController *webViewController = [[WebViewController alloc] initWithTitle:@"Terms of Service" content:url];
    [self.navigationController pushViewController:webViewController animated:YES];*/
}

@end
