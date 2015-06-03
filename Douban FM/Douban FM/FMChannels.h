//
//  FMChannels.h
//  Douban FM
//
//  Created by Lolo on 15/5/25.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "FMChannelInfo.h"
#include "FMProtocol.h"

//channel index in channelSection
enum
{
    MINE = 0,
    RECOMMAND,
    UPTREND,
    HOT
};

enum
{
    DEFAULT = 0,
    LIKED
};

@interface FMChannels : NSObject

@property (strong, nonatomic)NSArray        *channelTitle;
@property (strong, nonatomic)NSMutableArray *channels;
@property (strong, nonatomic)NSMutableArray *mineChannels;
@property (strong, nonatomic)NSMutableArray *recommandChannels;
@property (strong, nonatomic)NSMutableArray *uptrendChannels;
@property (strong, nonatomic)NSMutableArray *hotChannels;

@property (strong, nonatomic)FMChannelInfo  *currentChannel;
@property (weak, nonatomic)id<ReloadChannels> tableReloadDelegate;

- (void)loadChannels;
- (FMChannelInfo*)defaultChannel;

@end
