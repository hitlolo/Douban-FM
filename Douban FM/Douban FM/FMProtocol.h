//
//  FMProtocal.h
//  Douban FM
//
//  Created by Lolo on 15/5/30.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#ifndef Douban_FM_FMProtocol_h
#define Douban_FM_FMProtocol_h

@protocol PlayDelegate <NSObject>

- (void)playAndPause;
- (void)skip;
- (void)heart;
- (void)ashBin;
- (BOOL)isPlaying;

@end


@protocol SongInfo <NSObject>

- (void)setSongInfo;

@end

@protocol ReloadChannels <NSObject>

- (void)reload;

@end

#endif
