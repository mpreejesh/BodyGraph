//
//  VCViewCampaing.h
//  BodyGraph
//
//  Created by Rony Vasquez on 05/05/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCViewCampaing : UIViewController
- (IBAction)btnNext:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *mDay;

- (IBAction)btnPrevious:(id)sender;
@end
