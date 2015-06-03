//
//  FMPlayer.m
//  Douban FM
//
//  Created by Lolo on 15/5/25.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import "FMPlayer.h"

@implementation FMPlayer


+ (instancetype)sharedInstance
{
    static FMPlayer* player = nil;
    if (player == nil)
    {
        player = [[FMPlayer alloc]init];
    }
    return player;
}



- (instancetype)init
{
    self = [super init];
    if (self)
    {
        //1. get user info
        [self loadArchiveredUserInfo];
        //2. get channels
        if (self.isLogined)
        {
            [self loadLoginChannels];
        }
        else
        {
            [self loadChannels];
        }
        //3. get player
        [self loadPlayer];
        
    }
    return self;
}

- (void)start
{

    //load playlist by current channel
    
    if (self.channel == nil) return;
    
    [self loadPlaylistAndPlay];
    [self setIsPlaying:YES];
}

#pragma mark -
#pragma mark - Channels & playlist & player

- (void)loadPlayer
{
    self.player = [[MPMoviePlayerController alloc]init];
    
   
    //后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    //add 播放器观察者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playNext)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSongInfo)
                                                 name: MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    
}

- (void)loadChannels
{
    self.channel = [[FMChannels alloc]init];
    
}

- (void)loadLoginChannels;
{

}

//type
//n : None. Used for get a song list only.
//e : Ended a song normally.
//u : Unlike a hearted song.
//r : Like a song.
//s : Skip a song.
//b : Trash a song.
//p : Use to get a song list when the song in playlist was all played.
- (void)loadPlaylistAndPlay
{
    self.playlist = [[FMPlayList alloc]init];
    [self.playlist getPlaylistByAction:@"n" Playtime:0 ChannelID:self.channel.currentChannel.channelID SongID:nil];
}


- (void)playNext
{
    //歌单已全部播放完 获取下一个歌单
    if (self.playlist.currentSongIndex == [self.playlist.songs count] - 1)
    {
        [self.playlist getPlaylistByAction:@"p" Playtime:0 ChannelID:self.channel.currentChannel.channelID SongID:nil];
    }
    //未播放完 播放下一首
    else
    {
        self.playlist.currentSongIndex++;
        self.playlist.currentSong = self.playlist.songs[self.playlist.currentSongIndex];
        [self.player setContentURL:[NSURL URLWithString:self.playlist.currentSong.url]];
        [self.player play];
    }

}

- (void)setSongInfo
{
    [self.songInfoDelegate setSongInfo];
}

#pragma mark -
#pragma mark - user methods

- (BOOL)login:(FMUser*)user
{
    self.user = user;
    if (self.user != nil)
    {
        self.isLogined = YES;
        return YES;
    }
    else
    {
        self.isLogined = NO;
        return NO;
    }
}



- (void)loadArchiveredUserInfo
{
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *appdelegatePath = [homePath stringByAppendingPathComponent:@"FMUserinfo.archiver"];
    //添加储存的文件名
    NSData *data = [[NSData alloc]initWithContentsOfFile:appdelegatePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    self.user = [unarchiver decodeObjectForKey:@"userInfo"];
    [unarchiver finishDecoding];
    
    if (self.user == nil)
    {
        self.isLogined = NO;
    }
    else
        self.isLogined = YES;
    
}

- (void)archiverUserInfo
{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:@"userInfo"];
    [archiver finishEncoding];
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filepath = [homePath stringByAppendingPathComponent:@"FMUserinfo.archiver"];
    //添加储存的文件名
    if ([data writeToFile:filepath atomically:YES])
    {
        NSLog(@"UesrInfo存储成功");
    }
}


#pragma mark -
#pragma mark - Controller Methods

- (void)playAndPause
{
    if (self.isPlaying)
    {
        [self.player pause];
        [self setIsPlaying:NO];
    }
    else if (!self.isPlaying)
    {
        [self.player play];
        [self setIsPlaying:YES];
    }
}

//type
//n : None. Used for get a song list only.
//e : Ended a song normally.
//u : Unlike a hearted song.
//r : Like a song.
//s : Skip a song.
//b : Trash a song.
//p : Use to get a song list when the song in playlist was all played.
- (void)skip
{
    [self.player pause];
    NSString *action = @"s";
    NSTimeInterval playtime = self.player.currentPlaybackTime;
    NSString *channelID = self.channel.currentChannel.channelID;
    NSString *songID = self.playlist.currentSong.sid;
    [self.playlist getPlaylistByAction:action Playtime: playtime ChannelID: channelID SongID:songID];
}

- (void)heart
{
    //if current song unliked
    NSString *action;
    if ([self.playlist.currentSong.like intValue] == 0)
    {
        //like a song
         action = @"r";
        self.playlist.currentSong.like = @"1";
    }
    else if ( [self.playlist.currentSong.like intValue] == 1)
    {
        //unlike a song
        [self.player pause];
        action = @"u";
        self.playlist.currentSong.like = @"0";
    }
    NSTimeInterval playtime = self.player.currentPlaybackTime;
    NSString *channelID = self.channel.currentChannel.channelID;
    NSString *songID = self.playlist.currentSong.sid;
    [self.playlist getPlaylistByAction:action Playtime: playtime ChannelID: channelID SongID:songID];
}

- (void)ashBin
{
    //trash a song
    [self.player pause];
    NSString *action = @"b";
    NSTimeInterval playtime = self.player.currentPlaybackTime;
    NSString *channelID = self.channel.currentChannel.channelID;
    NSString *songID = self.playlist.currentSong.sid;
    [self.playlist getPlaylistByAction:action Playtime: playtime ChannelID: channelID SongID:songID];

}

- (void)switchChannel:(FMChannelInfo*)channel;
{
    [self.player pause];
    self.channel.currentChannel = channel;
    NSLog(@"%@",self.channel.currentChannel.channelName);
    NSLog(@"%@",self.channel.currentChannel.channelID);
    NSString *action = @"n";
    NSString *channelID = self.channel.currentChannel.channelID;
    [self.playlist getPlaylistByAction:action Playtime: 0 ChannelID: channelID SongID:nil];

}
@end
