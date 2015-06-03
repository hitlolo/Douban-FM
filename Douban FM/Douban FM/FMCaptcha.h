//
//  FMCaptcha.h
//  Douban FM
//
//  Created by Lolo on 15/5/27.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FMCaptcha : NSObject

@property(strong, nonatomic)NSString     *captchaID;
@property(strong, nonatomic)NSURL        *captchaURL;

+ (instancetype)captchaWithID:(NSString*)captchaID AndURL:(NSString*)captchaURL;


@end
