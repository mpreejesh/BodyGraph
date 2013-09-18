//
//  NSObject+Comments.h
//  BodyGraph
//
//  Created by Kodemint on 06/08/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  Comment : NSObject
@property(nonatomic, assign) NSInteger comment_id;
@property(nonatomic, assign) NSInteger journal_id;
@property(nonatomic, assign) NSInteger post_id;
@property(nonatomic, strong) NSString *comment;
@end
