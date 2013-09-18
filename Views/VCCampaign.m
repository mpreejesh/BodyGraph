//
//  VCCampaign.m
//  BodyGraph
//
//  Created by Rony Vasquez on 06/05/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "VCCampaign.h"
#import "VCSettings.h"
#import "VCProfile.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CampaignService.h"
#import "VCStartCampaign.h"

@interface VCCampaign ()
@property (nonatomic, strong) User *user;
@end

@implementation VCCampaign

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
    // Do any additional setup after loading the view from its nib.
    if(self){
        self.tabBarItem.title = @"My Campaign";
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
    }
   

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
- (IBAction)btnProfile:(id)sender {
    VCProfile *vc = [[VCProfile alloc]initWithNibName:@"VCProfile" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)finishCampaignClicked:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Finishing...";
        
    [[CampaignService sharedService] finishCampaign:self.user.activeCampaign.campaignId
       onCompletion:^(NSDictionary *result) {
           [hud hide:YES];
           [AppDelegate sharedDelegate].localUser.activeCampaign = nil;
           VCStartCampaign *vc = [[VCStartCampaign alloc] initWithNibName:@"VCStartCampaign" bundle:nil];
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

@end
