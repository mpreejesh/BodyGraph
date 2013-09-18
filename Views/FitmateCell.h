//
//  FitmateCell.h
//  BodyGraph
//
//  Created by Rony Vasquez on 02/06/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FitmateCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *fitmateImage;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UIImageView *frontImage;
@property (nonatomic, retain) IBOutlet UIImageView *sideImage;
@property (nonatomic, strong) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) IBOutlet UILabel *likesLabel;
@property (nonatomic, strong) IBOutlet UILabel *commentsLabel;

@property (nonatomic, strong) IBOutlet UIButton *btnComment;
@property (nonatomic, strong) IBOutlet UIButton *btnLike;
@property (nonatomic, strong) IBOutlet UILabel *weightLabel;
@end