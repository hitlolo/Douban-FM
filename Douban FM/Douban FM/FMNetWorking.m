//
//  FMNetWorking.m
//  Douban FM
//
//  Created by Lolo on 15/5/27.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import "FMNetWorking.h"

@interface FMNetWorking()
{
    AFHTTPRequestOperationManager *httpManager;
}

@end

@implementation FMNetWorking



+ (instancetype)sharedInstance
{
    static FMNetWorking* networking = nil;
    if (networking == nil)
    {
        networking  = [[FMNetWorking alloc]init];
    }
    return networking;
}


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        httpManager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}



#pragma mark -
#pragma mark - Net Working



@end
