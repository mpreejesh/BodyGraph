//
//  TrackImageViewController.h
//  BodyGraph
//
//  Created by Cai DaRong on 3/21/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Journal.h"

@interface VCTrackImage : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
	IBOutlet UIImageView *m_previewImageView;
	IBOutlet UIButton *m_imageTypeBtn;
	IBOutlet UILabel *m_dayLabel;
	IBOutlet UILabel *m_monthLabel;
	IBOutlet UILabel *m_yearLabel;
	
	BOOL m_bIsFrontImage;
	
	UIImage *m_frontImage;
	UIImage *m_sideImage;
}

- (id)initWithJournal:(Journal *)journal;

@end
