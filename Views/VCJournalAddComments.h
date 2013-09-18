//
//  VCJournalAddComments.h
//  BodyGraph
//
//  Created by Kodemint on 05/08/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Journal.h"

@interface VCJournalAddComments : UIViewController<UITableViewDataSource,UINavigationControllerDelegate,
UITableViewDelegate>
{
    IBOutlet UIImageView *fitmateImage;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UIImageView *frontImage;
    IBOutlet UIImageView *sideImage;
    IBOutlet UILabel *progressLabel;
    IBOutlet UILabel *weightLabel;
    IBOutlet UITextView *txtComment;
    IBOutlet UIView *viewCommentBox;
    IBOutlet UITableView *m_CommentsTable;
    IBOutlet UIButton *btnPostComment;
}
- (void)setJournalId:(Journal *)journal nickName:(NSString *)name journalOwnerId:(NSInteger)ownerId;
@end
