//
//  VCJournalAddComments.m
//  BodyGraph
//
//  Created by Kodemint on 05/08/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "VCJournalAddComments.h"
#import "VCSettings.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Cache.h"
#import "CommentsCell.h"
#import "CommentsService.h"
#import "AppDelegate.h"
#include "HUDManager.h"
#include "VCLogin.h"
#import "VCProfile.h"

#define kCellIdentifier @"CommentsCell"

@interface VCJournalAddComments ()
@property (nonatomic, assign) Journal *jrnl;
@property (nonatomic, assign) NSInteger journalOwnerId;
@property(nonatomic, strong) NSString *nickName;
@property(nonatomic, strong)Comments *comments;

@end

@implementation VCJournalAddComments


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
	
    if(self)
        self.tabBarItem.title = @"Comments";
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //set notification for when a key is pressed.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(keyPressed:)
                                                 name: UITextViewTextDidChangeNotification
                                               object: nil];
    
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
    
       
    if(self.jrnl != nil)
    {
        
        nameLabel.text = self.nickName;
        timeLabel.text = self.jrnl.Duration;
        
        NSString *frontImageUrl = [NSString stringWithFormat:@"%@%@%@", kBaseUrl, @"/", self.jrnl.frontImageUrl];
        NSString *sideImageUrl = [NSString stringWithFormat:@"%@%@%@", kBaseUrl, @"/", self.jrnl.sideImageUrl];
        
        frontImage.image = nil;
        sideImage.image = nil;
                
        UIActivityIndicatorView *frontImageIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        UIActivityIndicatorView *sideImageIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        frontImageIndicator.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        sideImageIndicator.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        [frontImageIndicator setColor:[UIColor whiteColor]];
        [sideImageIndicator  setColor:[UIColor whiteColor]];
        
        [frontImageIndicator removeFromSuperview];
        [sideImageIndicator  removeFromSuperview];
        
        frontImageIndicator.center = CGPointMake(CGRectGetMidX(frontImage.bounds), CGRectGetMidY(frontImage.bounds));
        sideImageIndicator.center  = CGPointMake(CGRectGetMidX(sideImage.bounds),  CGRectGetMidY(sideImage.bounds));
        
        
        [frontImage addSubview:frontImageIndicator];
        [sideImage  addSubview:sideImageIndicator];
        
        [frontImageIndicator startAnimating];
        [sideImageIndicator startAnimating];
        
        
        [frontImage setImageWithURL:[NSURL URLWithString:frontImageUrl] placeholderImage:[UIImage imageNamed:frontImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [frontImageIndicator setHidden:YES];
            [frontImageIndicator stopAnimating];
            
        }];
        
        [sideImage setImageWithURL:[NSURL URLWithString:sideImageUrl] placeholderImage:[UIImage imageNamed:sideImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [sideImageIndicator setHidden:YES];
            [sideImageIndicator stopAnimating];
            
        }];
        
        weightLabel.text = (NSString *)[NSString stringWithFormat:@"%d", (int)self.jrnl.weight];
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        [[CommentsService sharedService] getCommentsOfJournal:self.jrnl.journalId withParams:nil onCompletion:^(Comments *comments) {
            self.comments = comments;
            [m_CommentsTable reloadData];
            [hud hide:YES];
        } onError:^(NSError *error) {
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
    
    self.navigationItem.title = @"Comments";
}

-(void)setJournalId:(Journal *)journal nickName:(NSString *)name journalOwnerId:(NSInteger)ownerId
{
    self.journalOwnerId = ownerId;
    self.jrnl = journal;
    self.nickName = name;
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

- (void) backBtnClicked
{
	//[self.navigationController popViewControllerAnimated:YES];
    VCProfile *vc = [[VCProfile alloc] initWithNibName:@"VCProfile" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) menuBtnClicked
{
	VCSettings *vc = [[VCSettings alloc] initWithNibName:@"VCSettings" bundle:nil];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	[self presentModalViewController:nav animated:YES];
}

- (void) animateTextField: (UITextView*) textField up: (BOOL) up movDist:(int)movementDistance
{
    //const int movementDistance = 105; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void) keyboardWillShow:(NSNotification *)note{
    [self animateTextField: txtComment up: YES movDist:210];
}
-(void) keyboardWillHide:(NSNotification *)note{
    [self animateTextField: txtComment up: NO movDist:210];
}

-(void) keyPressed: (NSNotification*) notification{
    CGSize newSize = [txtComment.text
                      sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]
                      constrainedToSize:CGSizeMake(222,9999)
                      lineBreakMode:UILineBreakModeWordWrap];
    
    NSInteger newSizeH = newSize.height;
    CGRect chatBoxFrame = txtComment.frame;
    
    if(newSize.height <= 30)
    {
        chatBoxFrame.size.height = 30;
    }
    else if(newSize.height <= 84)
    {
        chatBoxFrame.size.height = newSizeH + 12;
        chatBoxFrame.origin.y = chatBoxFrame.origin.y - 18;
        
    }
    NSLog(@"Height : %f", chatBoxFrame.size.height);

    txtComment.frame = chatBoxFrame;
    
}

- (IBAction)dismissKeyboard:(id)sender
{
    [txtComment resignFirstResponder];
}

- (IBAction)btnPostComment:(id)sender {
    
    NSString *desc = @"Comment on your Progress Track";
    
    NSDictionary *commentsDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [NSNumber numberWithInt:[AppDelegate sharedDelegate].localUser.userId], @"userId", // for notification
                                  [NSNumber numberWithInt:self.journalOwnerId], @"journalOwnerId", // for notification
                                  [NSNumber numberWithInt:0], @"post_id", // this notification only for journal comments, not for posts/status
                                  [NSNumber numberWithInt:1], @"type", // for notification
                                  desc, @"description",
                                  [NSNumber numberWithInt:0], @"isread",
                                  txtComment.text, @"comments", nil];
    
    [[CommentsService sharedService]
     createJournalComment:commentsDict
     forJournal:self.jrnl.journalId
     onCompletion:^(Comment *comments) {
         if(comments.comment_id != 0)
         {
             txtComment.text = @"";
             if(self.comments.comments.count == 1)
             {
                 Comment *comment = [[NSArray arrayWithArray:self.comments.comments] objectAtIndex:0];
                 if(comment.comment_id == 0)
                 {
                     [self.comments.comments removeObject:comment];
                 }
             }
             [self.comments.comments addObject:comments];
             [m_CommentsTable reloadData];
         }
     }
     onError:^(NSError *error) {
         
     }];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsCell *cell = (CommentsCell *)[m_CommentsTable dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:kCellIdentifier owner:self options:nil];
        cell = [nibs objectAtIndex:0];
    }
    
    Comment *comment = [[NSArray arrayWithArray:self.comments.comments] objectAtIndex:[indexPath row]];
    cell.commentsTextView.text = comment.comment;
    return cell;
}
@end
