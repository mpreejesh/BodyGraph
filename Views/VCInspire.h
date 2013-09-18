//
//  VCInspire.h
//  BodyGraph
//
//  Created by Rony Vasquez on 05/05/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCInspire : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)btnInspire:(id)sender;
- (IBAction)btnMotivate:(id)sender;
- (IBAction)btnTrack:(id)sender;
- (IBAction)btnFitmates:(id)sender;
- (IBAction)btnCampaign:(id)sender;

@end
