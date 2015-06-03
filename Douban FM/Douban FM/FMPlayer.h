//
//  FMPlayer.h
//  Douban FM
//
//  Created by Lolo on 15/5/25.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "FMChannels.h"
#import "FMUser.h"
#import "FMPlayList.h"
#import "FMSong.h"
#import "FMProtocol.h"


@interface FMPlayer : NSObject
<PlayDelegate>

@property(nonatomic)BOOL                  isLogined;
@property(strong, nonatomic)FMChannels    *channel;
@property(strong, nonatomic)FMUser        *user;
@property(strong, nonatomic)FMPlayList    *playlist;
@property(strong, nonatomic)FMChannelInfo *currentChannel;
@property(strong, nonatomic)FMSong        *currentSong;
@property(weak,   nonatomic)id<SongInfo>   songInfoDelegate;
@property(strong, nonatomic)MPMoviePlayerController *player;
@property(nonatomic)BOOL                             isPlaying;

+ (instancetype)sharedInstance;

//user info
- (void)start;
- (BOOL)login:(FMUser*)user;
- (void)loadArchiveredUserInfo;
- (void)archiverUserInfo;
- (void)switchChannel:(FMChannelInfo*)channel;
@end
