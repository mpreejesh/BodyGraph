//
//  StartCampaignViewController.h
//  BodyGraph
//
//  Created by Cai DaRong on 2/14/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface VCStartCampaign : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate>
{
	IBOutlet UITextField *m_campaignNameLabel;
	IBOutlet UILabel *m_privateLabel;
	IBOutlet UILabel *m_weightLabel;
	IBOutlet UIButton *m_minusBtn;
	IBOutlet UIButton *m_plusBtn;
	IBOutlet UIButton *m_privateBtn;
    
	
	MBProgressHUD *m_progressView;
	
	NSTimer *m_longTapTimer;

}

@end
