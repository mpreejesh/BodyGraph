//
//  TrackImageViewController.m
//  BodyGraph
//
//  Created by Cai DaRong on 3/21/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "VCTrackImage.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "VCSettings.h"
#import "VCTrackWeight.h"
#import "Journal.h"
#import "User.h"
#import "AppDelegate.h"
#import "JournalService.h"
#import "UIImage+Base64.h"
#import "VCProfile.h"

@interface VCTrackImage ()

@property (nonatomic,strong) Journal *journal;

@end

@implementation VCTrackImage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithJournal:(Journal *)journal
{
    self = [super initWithNibName:@"VCTrackImage" bundle:nil];
    if (self) {
        self.journal = journal;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if(self)
         self.tabBarItem.title = @"Track";
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
	
	User *user = [AppDelegate sharedDelegate].localUser;
	self.navigationItem.title = user.nickname;
	
	if ( [user.gender isEqualToString:@"Female"] )
	{
		NSString *imageName = m_bIsFrontImage ? @"femaleFrontBtn.png" : @"femaleSideBtn.png";
		[m_imageTypeBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	}
	else
	{
		NSString *imageName = m_bIsFrontImage ? @"maleFrontBtn.png" : @"maleSideBtn.png";
		[m_imageTypeBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	}
	
	NSDate *currentDate = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
	
	m_dayLabel.text = [NSString stringWithFormat:@"%d", dateComponents.day];
	m_monthLabel.text = [self monthStringWithValue:dateComponents.month];
	m_yearLabel.text = [NSString stringWithFormat:@"%d", dateComponents.year];	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction) imageTypeBtnClicked
{
	m_bIsFrontImage = !m_bIsFrontImage;
    User *user = [AppDelegate sharedDelegate].localUser;
	if ( [user.gender isEqualToString:@"Female"] )
	{
		NSString *imageName = m_bIsFrontImage ? @"femaleFrontBtn.png" : @"femaleSideBtn.png";
		[m_imageTypeBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	}
	else
	{
		NSString *imageName = m_bIsFrontImage ? @"maleFrontBtn.png" : @"maleSideBtn.png";
		[m_imageTypeBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	}
}

- (IBAction) takeImageBtnClicked
{
	UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
	pickController.sourceType = UIImagePickerControllerSourceTypeCamera;
	pickController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
	pickController.delegate = self;
	[self presentModalViewController:pickController animated:YES];
}

- (IBAction) knobBtnClicked
{
    
    
	UIImage *image = m_previewImageView.image;
	if ( m_bIsFrontImage )
	{
		m_frontImage = image;
	}
	else
	{
		m_sideImage = image;
	}
	
    User *user = [AppDelegate sharedDelegate].localUser;
    
	if ( m_frontImage && m_sideImage )
	{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Please wait...";
        
        float weight = (self.journal.weight == 0) ? user.activeCampaign.initialWeight : self.journal.weight;
        
        CGSize sizeCropped = CGSizeMake(128, 128);
        
        UIImage *smallFrontImage = [self imageWithImage:m_frontImage scaledToSize:sizeCropped];//call below function...
        UIImage *smallSideImage = [self imageWithImage:m_sideImage scaledToSize:sizeCropped];//call below function...
        
        NSString *encodedFrontImage = [smallFrontImage  base64StringFromPNG];
        NSString *encodedSideImage = [smallSideImage  base64StringFromPNG];
        NSDictionary *journalDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     [NSNumber numberWithFloat:weight], @"weight",
                                     [NSNumber numberWithInt:user.userId], @"userId",
                                     encodedFrontImage, @"front_image",
                                     encodedSideImage, @"side_image", nil];
        [[JournalService sharedService] createJournal:journalDict forCampaign:user.activeCampaign.campaignId //shinu
        onCompletion:^(Journal *journal) {
            [hud hide:YES];
            VCTrackWeight *vc = [[VCTrackWeight alloc] initWithNibName:@"VCTrackWeight" bundle:nil];
            [vc initWithJournal:journal];
            [self.navigationController pushViewController:vc animated:YES];
        }
        onError:^(NSError *error) {
            [hud hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BodyGraph"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
		
		
	}
	else
	{
		m_bIsFrontImage = m_frontImage == nil ? YES : NO;
		if ( [user.gender isEqualToString:@"Female"] )
		{
			NSString *imageName = m_bIsFrontImage ? @"femaleFrontBtn.png" : @"femaleSideBtn.png";
			[m_imageTypeBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
		}
		else
		{
			NSString *imageName = m_bIsFrontImage ? @"maleFrontBtn.png" : @"maleSideBtn.png";
			[m_imageTypeBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
		}
	}
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage*) rotateWithImage:(UIImage *)image orient:(UIImageOrientation)orient
{
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGImageRef         imag = image.CGImage;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;
    
    rect.size.width  = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            // would get you an exact copy of the original
            assert(false);
            return nil;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            bnds = swapWidthAndHeight(bnds);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
            break;
            
        default:
            // orientation value supplied is invalid
            assert(false);
            return nil;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

static CGRect swapWidthAndHeight(CGRect rect)
{
    CGFloat  swap = rect.size.width;
    
    rect.size.width  = rect.size.height;
    rect.size.height = swap;
    
    return rect;
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

#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
	if ( [mediaType isEqualToString:(NSString *)kUTTypeImage] )
	{
		UIImage *image = (UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
		[m_previewImageView setImage:image];
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

@end
