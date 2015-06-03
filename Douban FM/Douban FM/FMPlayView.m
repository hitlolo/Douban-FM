//
//  FMPlayView.m
//  Douban FM
//
//  Created by Lolo on 15/5/24.
//  Copyright (c) 2015年 Lolo. All rights reserved.
//

#import "FMPlayView.h"

@implementation FMPlayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadFromNib:frame];
        return self;
    }
    else return nil;
}

- (void)loadFromNib:(CGRect)frame
{
    NSLog(@"FMPlayview init");
    [[NSBundle mainBundle] loadNibNamed:@"FMPlayView" owner:self options:nil];
    
    //NSLog(@"%f,%f",self.contentView.bounds.size.width,self.contentView.bounds.size.height);
    
    self.contentView.frame = frame;
    
    [self addSubview:self.contentView];

}

@end
