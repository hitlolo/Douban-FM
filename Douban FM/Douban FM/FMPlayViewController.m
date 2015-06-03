//
//  FMPlayViewController.m
//  Douban FM
//
//  Created by Lolo on 15/5/24.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import "FMPlayViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <UIImageView+AFNetworking.h>

@interface FMPlayViewController ()
{
    PGCategoryView        *chanelView;
    FMPlayer              *fmplayer;
    NSTimer               *progressTimer;
    UITableView           *channelTabel;
    UIColor               *fontColor;
}

@end

@implementation FMPlayViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initFromNib];
        [self initPlayer];
        [self initChanelView];
        [self initProgressTimer];
        [self initPlayPauseAction];
    }
    return self;
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    //远程控制中心
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];

}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark - self init


- (void)initFromNib
{
    [[NSBundle mainBundle] loadNibNamed:@"FMPlayViewController" owner:self options:nil];
    CGRect frame = [[UIScreen mainScreen]bounds];
    self.view.frame = frame;
    fontColor = [self.chanelName textColor];
    //[self.contentView addSubview:self.view];

}

- (void)initProgressTimer
{
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

- (void)updateProgress
{
    FMSong *song = [[[FMPlayer sharedInstance]playlist]currentSong];
    self.timerProgress.progress = [[FMPlayer sharedInstance]player].currentPlaybackTime/[song.length intValue];
}

- (void)initPlayController
{
    self.playerDelegate = [FMPlayer sharedInstance];
    
}

- (void)initPlayPauseAction
{
    self.albumStencil.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPlayPausePressed)];
    [singleTap setNumberOfTapsRequired:1];
    [self.albumStencil addGestureRecognizer:singleTap];
}


#pragma mark -
#pragma mark - Side Chanel View

- (void)initChanelView
{
    //FMChannelsViewController *cvc = [[FMChannelsViewController alloc]init];
    
    channelTabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,250, self.view.bounds.size.height)];
    channelTabel.delegate = self;
    channelTabel.dataSource = self;
    channelTabel.sectionHeaderHeight = 80;
    channelTabel.rowHeight = 60;
    //self.clearsSelectionOnViewWillAppear = YES;
    [channelTabel registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ChannelCell"];
    
    [channelTabel addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadChannels)];
    
    // 设置文字
    [channelTabel.header setTitle:@"下拉获取频道" forState:MJRefreshHeaderStateIdle];
    [channelTabel.header setTitle:@"松开刷新" forState:MJRefreshHeaderStatePulling];
    [channelTabel.header setTitle:@"Loading" forState:MJRefreshHeaderStateRefreshing];
    
    // 设置字体
    channelTabel.header.font = [UIFont systemFontOfSize:15];
    
    // 设置颜色
    channelTabel.header.textColor = [UIColor grayColor];
    // 马上进入刷新状态
    //[self.tableView.header beginRefreshing];

    
    UIView *chanelContentView;
    
    
    //CGRect frame = CGRectMake(self.view.bounds.size.width, 0,self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect frame = CGRectMake(self.view.bounds.size.width, 0,250, self.view.bounds.size.height);
    chanelContentView = [[UIView alloc]initWithFrame:frame];
    
    chanelContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    chanelContentView.backgroundColor = [UIColor redColor];
    
    //cvc.view.frame = chanelContentView.bounds;
    
    
    [chanelContentView addSubview:channelTabel];
    [self.view addSubview:chanelContentView];
    

    // CGRect frame = chanelContentView.frame;
    frame.origin.x -= 30;
    //
    frame.size.width = 30;
    chanelView = [PGCategoryView categoryRightView:chanelContentView];
    chanelView.frame = frame;
    [self.view addSubview:chanelView];
    
}

- (void)loadChannels
{
    [fmplayer.channel loadChannels];
    [channelTabel.header endRefreshing];
}

- (void)showChannelBar
{
    [chanelView show];
}

- (void)dismssChannelBar
{
    [chanelView hide];
}


#pragma mark - Table view data delegate & data source

//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView* view = [tableView headerViewForSection:section];
//    
//}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  
    return fmplayer.channel.channelTitle[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
   return [[[fmplayer channel]channelTitle]count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [[[fmplayer channel]channels][section] count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.textColor = fontColor;
    cell.textLabel.text = [[fmplayer channel].channels[indexPath.section][indexPath.row] channelName];
    //cell.textLabel.text = [[player channel]channelTitle][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMChannelInfo * currenChannel = fmplayer.channel.channels[indexPath.section][indexPath.row];
    [fmplayer switchChannel:currenChannel];
}

- (void)reload
{
    [channelTabel reloadData];
}

#pragma mark -
#pragma mark - player & button actions

- (void)initPlayer
{
    fmplayer = [FMPlayer sharedInstance];
    fmplayer.channel.tableReloadDelegate = self;
    fmplayer.songInfoDelegate = self;
    self.playerDelegate = fmplayer;
}

- (IBAction)buttonNextPressed:(UIButton *)sender
{
    [self.playerDelegate skip];
}

- (void)buttonPlayPausePressed
{
    if ([self.playerDelegate isPlaying])
    {
        self.albumCover.alpha = 0.2f;
        self.albumStencil.image = [UIImage imageNamed:@"albumBlock2"];
        //pause the timer
        [progressTimer setFireDate:[NSDate distantFuture]];
    }
    else if (![self.playerDelegate isPlaying])
    {
        self.albumCover.alpha = 1.0f;
        self.albumStencil.image = [UIImage imageNamed:@"albumBlock"];
        [progressTimer setFireDate:[NSDate date]];

    }
    [self.playerDelegate playAndPause];
}

- (IBAction)buttonHeartPressed:(UIButton *)sender
{
    int liked = [fmplayer.playlist.currentSong.like intValue];
    if (!liked)
    {
        [self.likeButton setImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
    }
    else if (liked )
    {
        [self.likeButton setImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    }
    
    [self.playerDelegate heart];
}

- (IBAction)buttonDeletePressed:(UIButton *)sender
{
    [self.playerDelegate ashBin];
}

//-------------------------------
- (void)setSongInfo
{
    FMSong *song = fmplayer.playlist.currentSong;
    self.chanelName.text =  [NSString stringWithFormat:@"%@ Mhz",fmplayer.channel.currentChannel.channelName];
    self.songName.text = song.title;
    self.singerName.text = song.artist;
    [self.albumCover setImageWithURL:[NSURL URLWithString:song.picture]];
    //likeButon的红心图像
    
    if ([song.like intValue] == 1)
    {
       // NSLog(@"%d,like value 1",[song.like intValue]);
        [self.likeButton setImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
    }
    else if ([song.like intValue] == 0)
    {
        //NSLog(@"%d,like value 0",[song.like intValue]);
        [self.likeButton setImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    }
    
    [progressTimer setFireDate:[NSDate date]];
    
    [self setLockScreenInfo];
}

#pragma mark -
#pragma mark - remote controll & info center

- (void)setLockScreenInfo
{
    if (NSClassFromString(@"MPNowPlayingInfoCenter"))
    {
        FMSong *song = fmplayer.playlist.currentSong;
        if (song != nil)
        {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:song.title forKey:MPMediaItemPropertyTitle];
            [dict setObject:song.artist forKey:MPMediaItemPropertyArtist];
            UIImage *alumImage = self.albumCover.image;
            if (alumImage != nil)
            {
                [dict setObject:[[MPMediaItemArtwork alloc]initWithImage:alumImage] forKey:MPMediaItemPropertyArtwork];
            }
            [dict setObject:[NSNumber numberWithFloat:fmplayer.player.currentPlaybackTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经播放时间
            [dict setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];//进度光标的速度 （这个随 自己的播放速率调整，我默认是原速播放）
            [dict setObject:[NSNumber numberWithFloat:[song.length floatValue]]forKey:MPMediaItemPropertyPlaybackDuration];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        }
    }
}


//响应远程音乐播放控制消息
- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    
    if (receivedEvent.type == UIEventTypeRemoteControl)
    {
        
        switch (receivedEvent.subtype)
        {
                
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
                [self buttonPlayPausePressed];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self.playerDelegate skip];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                break;
            default:
                break;
        }
    }
}
@end
