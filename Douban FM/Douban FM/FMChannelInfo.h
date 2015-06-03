//
//  FMChannelInfo.h
//  Douban FM
//
//  Created by Lolo on 15/5/26.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMChannelInfo : NSObject


@property(strong, nonatomic)NSString *channelName;
@property(strong, nonatomic)NSString *channelID;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
