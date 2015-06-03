//
//  FMPlayList.m
//  Douban FM
//
//  Created by Lolo on 15/5/25.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import "FMPlayList.h"
#import <AFNetworking/AFNetworking.h>
#import "FMSong.h"
#import "FMPlayer.h"

@implementation FMPlayList



//Request
//
//GET: /j/mine/playlist
//
//Usage
//
//Get new playlist when player status change.
//
//Parameters
//
//type
//n : None. Used for get a song list only.
//e : Ended a song normally.
//u : Unlike a hearted song.
//r : Like a song.
//s : Skip a song.
//b : Trash a song.
//p : Use to get a song list when the song in playlist was all played.
//sid
//the song's id
//pt
//how long the song has passed when operated
//channel
//channel id
//pb
//for the normal user(not pro) , value 64
//from
//value mainsite
//r
//a 10 digits 16 hex random number
//Resopnse
//
//e : the operate status
//others : a playlist

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.songs = [NSMutableArray array];
        self.currentSongIndex = 0;
    }
    return self;
}

// url "http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite"

- (void)getPlaylistByAction:(NSString *)action Playtime:(NSTimeInterval)playtime ChannelID:(NSString *)channel_id SongID:(NSString *)song_id
{
    NSString *url = @"http://douban.fm/j/mine/playlist";
    
    NSMutableDictionary* parameter = [NSMutableDictionary dictionary];
    if (action!=nil)
    {
        [parameter setObject:action forKey:@"type"];
    }
    if (playtime != 0.0)
    {
        [parameter setObject:[NSString stringWithFormat:@"%f",playtime] forKey:@"pt"];
    }
    if (channel_id != nil)
    {
        [parameter setObject:channel_id forKey:@"channel"];
    }
    if (song_id != nil)
    {
        [parameter setObject:song_id forKey:@"sid"];
    }
    [parameter setObject:@"mainsite" forKey:@"from"];
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [httpManager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        NSDictionary *songDic = responseObject;
        if (songDic != nil && [self.songs count]!= 0)
        {
            [self.songs removeAllObjects];
        }
        //NSLog(@"%@",songDic);
        for (NSDictionary *song in [songDic objectForKey:@"song"])
        {
          
            
            //subtype=T为广告标识位，如果是T，则不加入播放列表(去广告)
            if ([[song objectForKey:@"subtype"] isEqualToString:@"T"])
            {
                continue;
            }
            FMSong *temSong = [[FMSong alloc] initWithDictionary:song];
            NSLog(@"%@",temSong.title);
            [self.songs addObject:temSong];
        }
        
        if ([self.songs count] != 0)
        {
            //like a song
            //则继续播放该歌曲，并在返回新的歌单后 重指向新歌单的首 使当前歌曲播放完后 继续播放新歌单
            if ([action isEqual:@"r"])
            {
                self.currentSongIndex = -1;
            }
            //其他行为 则停止播放当前歌曲 直接播放新歌单
            else
            {
                self.currentSongIndex = 0;
                self.currentSong = self.songs[self.currentSongIndex];
                
                [[FMPlayer sharedInstance].player prepareToPlay];
                [[FMPlayer sharedInstance].player setContentURL:[NSURL URLWithString:self.currentSong.url]];
                [[FMPlayer sharedInstance].player play];
            }
            
            NSLog(@"%d",self.songs.count);
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

@end
