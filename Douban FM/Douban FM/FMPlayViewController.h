//
//  FMPlayViewController.h
//  Douban FM
//
//  Created by Lolo on 15/5/24.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGCategoryView.h"
#import "FMChannelsViewController.h"
#import "FMPlayer.h"
#import "FMProtocol.h"


@interface FMPlayViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,ReloadChannels,SongInfo>



@property (strong, nonatomic) IBOutlet UILabel        *chanelName;
@property (strong, nonatomic) IBOutlet UIImageView    *albumCover;
@property (strong, nonatomic) IBOutlet UIImageView    *albumStencil;
@property (strong, nonatomic) IBOutlet UIProgressView *timerProgress;

@property (strong, nonatomic) IBOutlet UILabel        *songName;
@property (strong, nonatomic) IBOutlet UILabel        *singerName;
@property (strong, nonatomic) IBOutlet UIButton       *likeButton;

@property (weak, nonatomic)id<PlayDelegate>            playerDelegate;

- (void)showChannelBar;
- (void)dismssChannelBar;
@end
