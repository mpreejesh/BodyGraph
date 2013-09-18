//
//  Constants.h
//  FaceCap
//
//  Created by Nelson Chicas on 4/10/13.
//  Copyright (c) 2013 Applits. All rights reserved.
//

#define kRegisterToken      @"7d107bd7-a083-4017-971b-66d54c97d26f"
#define kSecurityContext    @"BodyGraph"
#define kUserIdKey          @"User"
#define kLoginSourceKey     @"Source"

#if DEBUG

//#define kBaseUrl                            @"http://192.168.1.107:8080/BodyGraph"
//#define kRegisterUrl                        @"http://192.168.1.107:8080/BodyGraph/register"
//#define kLoginUrl                           @"http://192.168.1.107:8080/BodyGraph/login"
//
//#define kUsersUrl                           @"http://192.168.1.107:8080/BodyGraph/users/%i"
//#define kGetUPictureUrl                     @"http://192.168.1.107:8080/BodyGraph/users/%i/picture"
//#define kUJournalsUrl                       @"http://192.168.1.107:8080/BodyGraph/campaigns/%i/journals"
//#define kUCampaignsUrl                      @"http://192.168.1.107:8080/BodyGraph/users/%i/campaigns"
//#define kUFinishCampaignUrl                 @"http://192.168.1.107:8080/BodyGraph/finish_campaign/%i"
//#define kUCommentsForJournalUrl             @"http://192.168.1.107:8080/BodyGraph/comments/journal/%i"
//#define kUCommentsForPostUrl                @"http://192.168.1.107:8080/BodyGraph/comments/post/%i"
//
//#define kGetournalsActivitiesByCampaignUrl  @"http://192.168.1.107:8080/BodyGraph/campaigns/%i"
//#define kJournalsUrl                        @"http://192.168.1.107:8080/BodyGraph/users/%i/journals/%i"
//#define kGetFPictureUrl                     @"http://192.168.1.107:8080/BodyGraph/journals/%i/front-picture"
//#define kGetSPictureUrl                     @"http://192.168.1.107:8080/BodyGraph/journals/%i/front-picture"
//#define kCampaignsUrl                       @"http://192.168.1.107:8080/BodyGraph/users/%i/campaigns/%i"
//#define kFriendsUrl                         @"http://192.168.1.107:8080/BodyGraph/users/%i/friends"
//#define kFeedUrl                            @"http://192.168.1.107:8080/BodyGraph/users/%i/feed"
//#define kCJournalsUrl                       @"http://192.168.1.107:8080/BodyGraph/categories/%i/journals/%i"
//#define kAddFitMatesUrl                     @"http://192.168.1.107:8080/BodyGraph/addfitmates/%i"
//
//#define kNotificationUrl                    @"http://192.168.1.107:8080/BodyGraph/notification"
//#define kUNotificationUrl                   @"http://192.168.1.107:8080/BodyGraph/notification/%i"
//#define kUNotificationCountUrl              @"http://192.168.1.107:8080/BodyGraph/notificationCount/%i"

#define kBaseUrl                            @"http://apps.applits.com/BodyGraph"
#define kRegisterUrl                        @"http://apps.applits.com/BodyGraph/register"
#define kLoginUrl                           @"http://apps.applits.com/BodyGraph/login"

#define kUsersUrl                           @"http://apps.applits.com/BodyGraph/users/%i"
#define kGetUPictureUrl                     @"http://apps.applits.com/BodyGraph/users/%i/picture"
#define kUJournalsUrl                       @"http://apps.applits.com/BodyGraph/campaigns/%i/journals"
#define kUCampaignsUrl                      @"http://apps.applits.com/BodyGraph/users/%i/campaigns"
#define kUFinishCampaignUrl                 @"http://apps.applits.com/BodyGraph/finish_campaign/%i"
#define kUCommentsForJournalUrl             @"http://apps.applits.com/BodyGraph/comments/journal/%i"
#define kUCommentsForPostUrl                @"http://apps.applits.com/BodyGraph/comments/post/%i"

#define kGetournalsActivitiesByCampaignUrl  @"http://apps.applits.com/BodyGraph/campaigns/%i"
#define kJournalsUrl                        @"http://apps.applits.com/BodyGraph/users/%i/journals/%i"
#define kGetFPictureUrl                     @"http://apps.applits.com/BodyGraph/journals/%i/front-picture"
#define kGetSPictureUrl                     @"http://apps.applits.com/BodyGraph/journals/%i/front-picture"
#define kCampaignsUrl                       @"http://apps.applits.com/BodyGraph/users/%i/campaigns/%i"
#define kFriendsUrl                         @"http://apps.applits.com/BodyGraph/users/%i/friends"
#define kFeedUrl                            @"http://apps.applits.com/BodyGraph/users/%i/feed"
#define kCJournalsUrl                       @"http://apps.applits.com/BodyGraph/categories/%i/journals/%i"
#define kAddFitMatesUrl                     @"http://apps.applits.com/BodyGraph/addfitmates/%i"

#define kNotificationUrl                    @"http://apps.applits.com/BodyGraph/notification"
#define kUNotificationUrl                   @"http://apps.applits.com/BodyGraph/notification/%i"
#define kUNotificationCountUrl              @"http://apps.applits.com/BodyGraph/notificationCount/%i"


#else

#define kBaseUrl                            @"http://apps.applits.com/BodyGraph"
#define kRegisterUrl                        @"http://apps.applits.com/BodyGraph/register"
#define kLoginUrl                           @"http://apps.applits.com/BodyGraph/login"

#define kUsersUrl                           @"http://apps.applits.com/BodyGraph/users/%i"
#define kGetUPictureUrl                     @"http://apps.applits.com/BodyGraph/users/%i/picture"
#define kUJournalsUrl                       @"http://apps.applits.com/BodyGraph/users/%i/journals"
#define kUCampaignsUrl                      @"http://apps.applits.com/BodyGraph/users/%i/campaigns"
#define kUFinishCampaignUrl                 @"http://apps.applits.com/BodyGraph/finish_campaign/%i"
#define kUCommentsForJournalUrl             @"http://apps.applits.com/BodyGraph/comments/journal/%i"
#define kUCommentsForPostUrl                @"http://apps.applits.com/BodyGraph/comments/post/%i"

#define kGetournalsActivitiesByCampaignUrl  @"http://apps.applits.com/BodyGraph/campaigns/%i"
#define kJournalsUrl                        @"http://apps.applits.com/BodyGraph/users/%i/journals/%i"
#define kGetFPictureUrl                     @"http://apps.applits.com/BodyGraph/journals/%i/front-picture"
#define kGetSPictureUrl                     @"http://apps.applits.com/BodyGraph/journals/%i/front-picture"
#define kCampaignsUrl                       @"http://apps.applits.com/BodyGraph/users/%i/campaigns/%i"
#define kFriendsUrl                         @"http://apps.applits.com/BodyGraph/users/%i/friends"
#define kFeedUrl                            @"http://apps.applits.com/BodyGraph/users/%i/feed"
#define kCJournalsUrl                       @"http://apps.applits.com/BodyGraph/categories/%i/journals/%i"
#define kAddFitMatesUrl                     @"http://apps.applits.com/BodyGraph/addfitmates/%i"

#define kNotificationUrl                    @"http://apps.applits.com/BodyGraph/notification"
#define kUNotificationUrl                   @"http://apps.applits.com/BodyGraph/notification/%i"
#define kUNotificationCountUrl              @"http://apps.applits.com/BodyGraph/notificationCount/%i"


#endif

typedef enum LoginType  {
    Credentials = 0,
    Facebook = 1,
    Twitter = 2
} LoginType;

//typedef enum ActionType {
//    FromPhone = 0,
//    FromFacebook = 1,
//    FromTwitter = 2
//} ActionType;
