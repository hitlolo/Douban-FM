//
//  FMSong.m
//  Douban FM
//
//  Created by Lolo on 15/5/25.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import "FMSong.h"

@implementation FMSong

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.artist  = [dictionary objectForKey:@"artist"];
        self.title   = [dictionary objectForKey:@"title"];
        self.url     = [dictionary objectForKey:@"url"];
        self.picture = [dictionary objectForKey:@"picture"];
        self.length  = [dictionary objectForKey:@"length"];
        self.like    = [dictionary objectForKey:@"like"];
        self.sid     = [dictionary objectForKey:@"sid"];
    }
    return self;
}

@end
