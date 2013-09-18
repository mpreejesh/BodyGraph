//
//  SettingsViewController.h
//  BodyGraph
//
//  Created by Cai DaRong on 3/21/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCSettings : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
	IBOutlet UIButton *m_facebookBtn;
	IBOutlet UIButton *m_twitterBtn;
	IBOutlet UIButton *m_unitBtn;
}

@end
