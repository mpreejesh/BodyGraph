//
//  VCViewCampaing.m
//  BodyGraph
//
//  Created by Rony Vasquez on 05/05/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "VCViewCampaign.h"
#import "VCSettings.h"
#import "User.h"
#import "AppDelegate.h"

@interface VCViewCampaing ()
@property (nonatomic, strong) User *user;
@end

@implementation VCViewCampaing

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        if (self) {
        // Custom initialization
            self.user = [AppDelegate sharedDelegate].localUser;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(self){
        self.tabBarItem.title = @"Motivate";
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnNext:(id)sender {
    NSString *aNumberString = self.mDay.text;
    int i = [aNumberString intValue];
    i++;
    [self.mDay setText:[NSString stringWithFormat:@"%d",i]];
}
- (void)viewDidUnload {
    [self setMDay:nil];
    [super viewDidUnload];
}
- (IBAction)btnPrevious:(id)sender {
    NSString *aNumberString = self.mDay.text;
    int i = [aNumberString intValue];
    i--;
    [self.mDay setText:[NSString stringWithFormat:@"%d",i]];
}
@end
