//
//  FMChannelInfo.m
//  Douban FM
//
//  Created by Lolo on 15/5/26.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import "FMChannelInfo.h"

@implementation FMChannelInfo


- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        self.channelName = dictionary[@"name"];
        self.channelID   = dictionary[@"id"];
        
    }
    return self;
}

@end
