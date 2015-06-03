//
//  FMLoginViewController.h
//  Douban FM
//
//  Created by Lolo on 15/5/26.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "FMPlayer.h"
#import "FMNetWorking.h"
#import "FMUser.h"
#import "FMCaptcha.h"


@interface FMLoginViewController : UIViewController
<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet UITextField *captchaText;
@property (strong, nonatomic) IBOutlet UIImageView *captchaImage;
@property (strong, nonatomic) FMCaptcha            *captcha;

@end
