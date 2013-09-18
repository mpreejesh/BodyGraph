//
//  TrackProgressCell.h
//  BodyGraph
//
//  Created by Nelson Chicas on 6/18/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackProgressCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *fitmateImage;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *frontImage;
@property (nonatomic, strong) IBOutlet UIImageView *sideImage;
@property (nonatomic, strong) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) IBOutlet UILabel *likesLabel;
@property (nonatomic, strong) IBOutlet UILabel *commentsLabel;

@end
