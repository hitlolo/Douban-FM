//
//  FMPlayView.h
//  Douban FM
//
//  Created by Lolo on 15/5/24.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMPlayView : UIView

@property (strong, nonatomic) IBOutlet UIView         *contentView;
@property (strong, nonatomic) IBOutlet UIImageView    *albumCover;
@property (strong, nonatomic) IBOutlet UIImageView    *albumStencil;

@property (strong, nonatomic) IBOutlet UIProgressView *timerProgress;

@end
