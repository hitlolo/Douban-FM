//
//  FMPlayList.h
//  Douban FM
//
//  Created by Lolo on 15/5/25.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMSong.h"

@interface FMPlayList : NSObject


@property(strong, nonatomic)NSMutableArray *songs;
@property(strong, nonatomic)FMSong         *currentSong;
@property(nonatomic)int                     currentSongIndex;

- (void)getPlaylistByAction:(NSString*)action Playtime:(NSTimeInterval)playtime ChannelID:(NSString*)channel SongID:(NSString*)song;
@end
