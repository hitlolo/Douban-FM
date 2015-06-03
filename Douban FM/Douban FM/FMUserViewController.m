//
//  FMLoginViewController.m
//  Douban FM
//
//  Created by Lolo on 15/5/26.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import "FMUserViewController.h"
#import <UIImageView+AFNetworking.h>

@interface FMUserViewController ()


@end

@implementation FMUserViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initFromNib];
        [self initAvatarAction];
        
    }
    return self;
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initUserInfo];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width/2.0;
    [self.avatarImage setClipsToBounds:YES];
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
    [[NSBundle mainBundle] loadNibNamed:@"FMUserViewController" owner:self options:nil];
    CGRect frame = [[UIScreen mainScreen]bounds];
    self.view.frame = frame;
    //[self.contentView addSubview:self.view];
    
}

- (void)initAvatarAction
{
    //给登陆图片添加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped)];
    [singleTap setNumberOfTapsRequired:1];
    self.avatarImage.userInteractionEnabled = YES;
    [self.avatarImage addGestureRecognizer:singleTap];
    
}

- (void)avatarTapped
{
    NSLog(@"tapeed");
    FMLoginViewController *loginVC = [[FMLoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark - user method

- (void)initUserInfo
{
    FMPlayer *player = [FMPlayer sharedInstance];
    if (player.isLogined)
    {
        NSString *url = [NSString stringWithFormat:@"http://img3.douban.com/icon/ul%@-1.jpg",player.user.userID];
        NSURL    *avatar_url = [NSURL URLWithString:url];
        self.userName.text = player.user.userName;
        [self initAvatar:avatar_url];
        [self initPlayrecord:player.user.playRecord];
    }
    else
        return;
}

- (void)initAvatar:(NSURL*)url
{
    [self.avatarImage setImageWithURL:url];
}

- (void)initPlayrecord:(NSDictionary*)playrecord
{
  
    self.playedNo.text = [NSString stringWithFormat:@"%@", [playrecord objectForKey:@"played"]] ;
    self.likedNo.text  = [NSString stringWithFormat:@"%@", [playrecord objectForKey:@"liked"]];
    self.banedNO.text  = [NSString stringWithFormat:@"%@", [playrecord objectForKey:@"banned"]];

}

@end
