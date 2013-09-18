//
//  Friend.h
//  FaceCap
//
//  Created by Nelson Chicas on 5/20/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#import "User.h"

@interface Friend : User

@property (nonatomic, assign) BOOL isFollowed;
@property (nonatomic, assign) BOOL isFollowing;

@end
