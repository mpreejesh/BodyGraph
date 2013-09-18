//
//  VCNotifications.h
//  BodyGraph
//
//  Created by Sreejesh MP on 24/07/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCNotifications : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *m_Notificatios;
}
- (IBAction)btnInspire:(id)sender;
- (IBAction)btnMotivate:(id)sender;
- (IBAction)btnTrack:(id)sender;
- (IBAction)btnCampaign:(id)sender;
- (IBAction)btnFitmates:(id)sender;


@end
