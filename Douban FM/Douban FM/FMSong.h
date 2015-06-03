//
//  FMSong.h
//  Douban FM
//
//  Created by Lolo on 15/5/25.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMSong : NSObject


@property (strong, nonatomic) NSString *title;      //歌曲名
@property (strong, nonatomic) NSString *artist;     //歌手
@property (strong, nonatomic) NSString *picture;    //唱片图片
@property (strong, nonatomic) NSString *length;     //歌曲时长
@property (strong, nonatomic) NSString *like;       //是否加心
@property (strong, nonatomic) NSString *url;        //歌曲url
@property (strong, nonatomic) NSString *sid;        //歌曲id

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;
@end
