//
//  FMUser.h
//  Douban FM
//
//  Created by Lolo on 15/5/26.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>

enum
{
    SUCCESS = 0,
    FAIL
};

@interface FMUser : NSObject<NSCoding>



@property(strong, nonatomic)NSNumber*     isLogined;
@property(strong, nonatomic)NSString*     cookie;
@property(strong, nonatomic)NSString*     userID;
@property(strong, nonatomic)NSString*     userName;
@property(strong, nonatomic)NSDictionary* playRecord;

+ (instancetype)userByDictionary:(NSDictionary*)userinfo;
- (instancetype)initWithDictionary:(NSDictionary*)userinfo;

@end
