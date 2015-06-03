//
//  FMLoginViewController.h
//  Douban FM
//
//  Created by Lolo on 15/5/26.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLoginViewController.h"

@interface FMUserViewController : UIViewController


@property(strong, nonatomic)IBOutlet UIImageView *avatarImage;
@property(strong, nonatomic)IBOutlet UILabel     *playedNo;
@property(strong, nonatomic)IBOutlet UILabel     *likedNo;
@property(strong, nonatomic)IBOutlet UILabel     *banedNO;
@property(strong, nonatomic)IBOutlet UILabel *userName;

@end
