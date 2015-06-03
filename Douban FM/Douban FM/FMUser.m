//
//  FMUser.m
//  Douban FM
//
//  Created by Lolo on 15/5/26.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import "FMUser.h"



@implementation FMUser

//登陆成功 返回信息
//login {
//    r = 0;
//    "user_info" =     {
//        ck = L3zp;
//        id = 1831044;
//        "is_dj" = 0;
//        "is_new_user" = 0;
//        "is_pro" = 0;
//        name = Lolo;
//        "play_record" =         {
//            banned = 7;
//            "fav_chls_count" = 0;
//            liked = 85;
//            played = 7606;
//        };
//        "third_party_info" = "<null>";
//        uid = hitlolo;
//        url = "http://www.douban.com/people/hitlolo/";
//    };
//}

+ (instancetype)userByDictionary:(NSDictionary *)userinfo
{
    FMUser *user = [[FMUser alloc]initWithDictionary:userinfo];
    if (user)
    {
        return user;
    }
    else
        return nil;
    
}

- (instancetype)initWithDictionary:(NSDictionary *)userinfo
{
    self = [super init];
    if (self)
    {
        self.isLogined = [userinfo valueForKey:@"r"];
        NSDictionary *tem_userinfo = [userinfo valueForKey:@"user_info"];
        self.cookie   = [tem_userinfo valueForKey:@"ck"];
        self.userID   = [tem_userinfo valueForKey:@"id"];
        self.userName = [tem_userinfo valueForKey:@"name"];
        NSDictionary *playrecord = [tem_userinfo valueForKey:@"play_record"];
        self.playRecord = playrecord;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.isLogined  = [aDecoder decodeObjectForKey:@"isLogined"];
        self.cookie     = [aDecoder decodeObjectForKey:@"cookie"];
        self.userID     = [aDecoder decodeObjectForKey:@"userID"];
        self.userName   = [aDecoder decodeObjectForKey:@"userName"];
        self.playRecord = [aDecoder decodeObjectForKey:@"playrecord"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_isLogined  forKey:@"isLogined"];
    [aCoder encodeObject:_cookie     forKey:@"cookie"];
    [aCoder encodeObject:_userID     forKey:@"userID"];
    [aCoder encodeObject:_userName   forKey:@"userName"];
    [aCoder encodeObject:_playRecord forKey:@"playrecord"];
}


@end
