//
//  NotificationsCell.h
//  BodyGraph
//
//  Created by Sreejesh MP on 24/07/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *fitmateImage;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, strong) IBOutlet UIButton *btnAccept;


@end
