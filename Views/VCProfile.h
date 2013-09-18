//
//  VCProfile.h
//  BodyGraph
//
//  Created by Cai DaRong on 4/3/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCProfile : UIViewController<UITableViewDataSource,UINavigationControllerDelegate,
                                        UITableViewDelegate>
{
	IBOutlet UIImageView *m_myIcon;
	IBOutlet UIScrollView *m_friendIconScroll;
	IBOutlet UILabel *m_daysLabel;
	IBOutlet UILabel *m_losedWeightLabel;
	IBOutlet UILabel *m_campaignLabel;
	IBOutlet UILabel *m_nameLabel;
    IBOutlet UITableView *m_journalsTable;

}
- (IBAction)btnCampaign:(id)sender;
- (IBAction)btnTrackImage:(id)sender;

@end
