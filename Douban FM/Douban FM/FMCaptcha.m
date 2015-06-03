//
//  FMCaptcha.m
//  Douban FM
//
//  Created by Lolo on 15/5/27.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import "FMCaptcha.h"

@implementation FMCaptcha

+ (instancetype)captchaWithID:(NSString *)captchaID AndURL:(NSString *)captchaURL
{
    static FMCaptcha *instance = nil;
    if (instance == nil)
    {
        instance = [[FMCaptcha alloc]initWithID:captchaID AndURL:captchaURL];
    }
    else
    {
        instance.captchaID = captchaID;
        instance.captchaURL = [NSURL URLWithString:captchaURL];;
    }
    return instance;
}


- (instancetype)initWithID:(NSString *)captchaID AndURL:(NSString *)captchaURL
{
    self = [super init];
    if (self)
    {
        self.captchaID = captchaID;
        self.captchaURL = [NSURL URLWithString:captchaURL];
    }
    return self;
}



@end
