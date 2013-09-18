//
//  VCInspire.m
//  BodyGraph
//
//  Created by Rony Vasquez on 05/05/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "VCInspire.h"
#import "VCMotivate.h"
#import "VCTrackImage.h"
#import "VCFitmates.h"
#import "VCCampaign.h"
#import "VCSettings.h"
#import "VCProfile.h"

@interface VCInspire ()

@end

@implementation VCInspire

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self){
    self.tabBarItem.title = @"Body Graph's";
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
	
        for (UIView *view in self.scrollView.subviews)
        {
            if ( [view isKindOfClass:[UILabel class]] )
            {
                UILabel *label = (UILabel *)view;
                [label setFont:[UIFont fontWithName:@"Capsuula" size:label.font.pointSize]];
            }
        }
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 627);
        self.scrollView.frame = self.view.frame;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
- (IBAction)btnInspire:(id)sender {
    
}

- (IBAction)btnMotivate:(id)sender {
    VCMotivate *vc = [[VCMotivate alloc] initWithNibName:@"VCMotivate" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnTrack:(id)sender {
    VCTrackImage *vc = [[VCTrackImage alloc] initWithNibName:@"VCTrackImage" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnFitmates:(id)sender {
    VCFitmates *vc = [[VCFitmates alloc] initWithNibName:@"VCFitmates" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnCampaign:(id)sender {
    VCCampaign *vc = [[VCCampaign alloc] initWithNibName:@"VCCampaign" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) backBtnClicked
{
    VCProfile *vc= [[VCProfile alloc] initWithNibName:@"VCProfile" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void) menuBtnClicked
{
    VCSettings *vc = [[VCSettings alloc] initWithNibName:@"VCSettings" bundle:nil];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	[self presentModalViewController:nav animated:YES];
}
@end
