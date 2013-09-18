//
//  TrackWeightViewController.h
//  BodyGraph
//
//  Created by Cai DaRong on 3/21/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Journal.h";

@interface VCTrackWeight : UIViewController
{
	IBOutlet UILabel *m_monthLabel;
	IBOutlet UILabel *m_dayLabel;
	IBOutlet UIImageView *m_frontImageView;
	IBOutlet UIImageView *m_sideImageView;
	IBOutlet UILabel *m_weightLabel;
	
	IBOutlet UIButton *m_plusBtn;
	IBOutlet UIButton *m_minusBtn;
		MBProgressHUD *m_progressView;
	
	NSTimer *m_longTapTimer;
}

- (id)initWithJournal:(Journal *)journal;

@end
