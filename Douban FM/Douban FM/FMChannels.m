//
//  FMChannels.m
//  Douban FM
//
//  Created by Lolo on 15/5/25.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import "FMChannels.h"
#import "FMPlayer.h"

@implementation FMChannels
{
    AFHTTPRequestOperationManager  *httpManager;
   
}



- (instancetype)init
{
    self = [super init];
    if (self)
    {
        httpManager = [AFHTTPRequestOperationManager manager];
        [self initChannelSections];
        self.currentChannel = [self defaultChannel];
        //[self loadChannels];
        
    }
    return self;
}

//-3	红心兆赫
//0	    私人兆赫
- (void)initChannelSections
{
    self.channelTitle = @[@"我的兆赫",@"推荐兆赫",@"上升最快",@"热门兆赫"];
    
    self.channels          = [NSMutableArray array];
    self.mineChannels      = [NSMutableArray array];
    self.recommandChannels = [NSMutableArray array];
    self.uptrendChannels   = [NSMutableArray array];
    self.hotChannels       = [NSMutableArray array];
    
    [self.channels addObject:self.mineChannels];
    [self.channels addObject:self.recommandChannels];
    [self.channels addObject:self.uptrendChannels];
    [self.channels addObject:self.hotChannels];
    
    FMChannelInfo *privateFM = [[FMChannelInfo alloc]init];
    privateFM.channelID   = @"0";
    privateFM.channelName = @"私人兆赫";
    

    
    [self.channels[MINE] addObject:privateFM];

}


- (void)loadChannels
{
    BOOL is_logined = [[FMPlayer sharedInstance] isLogined];
    if (is_logined == YES)
    {
        //第一次登录 增添红心兆赫
        if ([self.channels[MINE]count] == 1)
        {
            FMChannelInfo *heartedFM = [[FMChannelInfo alloc]init];
            heartedFM.channelID   = @"-3";
            heartedFM.channelName = @"红心兆赫";
            [self.channels[MINE] addObject:heartedFM];
            [self refreshChannel:MINE];
        }
       
    }
    else if (is_logined == NO)
    {
        if ([self.channels[MINE]count] == 2)
        {
            [self.channels[MINE]removeObjectAtIndex:1];
        }
    }
    //刷新其他频道
    [self refreshChannel:RECOMMAND];
    [self refreshChannel:HOT];
    [self refreshChannel:UPTREND];
   

    
}

- (FMChannelInfo*)defaultChannel
{
    return self.channels[MINE][DEFAULT];
}




- (void)refreshChannel:(int)index
{
    NSString* url;
    switch (index)
    {
        case MINE:
            {
            NSString* user_id = [FMPlayer sharedInstance].user.userID;
            url = [NSString stringWithFormat: @"http://douban.fm/j/explore/get_login_chls?uk=%@",user_id];
            }
            
            break;
        case RECOMMAND:
            url = @"http://douban.fm/j/explore/get_recommend_chl";
            break;
        case HOT:
            url = @"http://douban.fm/j/explore/hot_channels";
            break;
        case UPTREND:
            url = @"http://douban.fm/j/explore/up_trending_channels";
            break;
        default:
            break;
    }
    
    //NSLog(@"%@",url);
    
    [httpManager GET:url
                 parameters:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                    //1.remove objects that already there
                    if (index != MINE)
                    {
                        [self.channels[index] removeAllObjects];
                    }
                     
                    //2.get new channels from url
                    NSDictionary *channelsDictionary = responseObject;
                    NSDictionary *channelData = [channelsDictionary objectForKey:@"data"];
                    if (index == RECOMMAND)
                    {
                        NSDictionary *channels = [channelData objectForKey:@"res"];
                        {
                            FMChannelInfo *channelInfo = [[FMChannelInfo alloc]initWithDictionary:channels];
                            [[self.channels objectAtIndex:index] addObject:channelInfo];
                        }

                    }
                
                    if (index != RECOMMAND)
                    {
                        for (NSDictionary *channels in [channelData objectForKey:@"channels"])
                        {
                           
                            FMChannelInfo *channelInfo = [[FMChannelInfo alloc]initWithDictionary:channels];
                            [[self.channels objectAtIndex:index] addObject:channelInfo];
                             //
                        }
                    }
                    
                    //reload data after load from web
                    [self.tableReloadDelegate reload];
                     //NSLog(@"%d channel,%@",index,[self.channels objectAtIndex:index]);

                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
                 {
                    NSLog(@"%@",error);
                 }
     ];

}

@end
