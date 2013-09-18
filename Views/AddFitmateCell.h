//
//  AddFitmateCell.h
//  BodyGraph
//
//  Created by Kodemint on 24/07/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFitmateCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UILabel *labelName;
@property(nonatomic, strong) IBOutlet UILabel *labelCampaign;
@property(nonatomic, strong) IBOutlet UILabel *labelCommom;
@property (nonatomic, retain) IBOutlet UIImageView *fitmateImage;
@property(nonatomic, strong) IBOutlet UIButton *btnAddMate;
@end
