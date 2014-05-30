//
//  CarView.m
//  LanTaiPro
//
//  Created by lantan on 14-5-28.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "CarView.h"

@implementation CarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.carImageview = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.carImageview.backgroundColor = [UIColor clearColor];
        [self addSubview:self.carImageview];
        
        self.carNumberLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.carNumberLab.backgroundColor = [UIColor clearColor];
        [self addSubview:self.carNumberLab];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.carImageview.frame = CGRectMake(0, 30, self.frame.size.width, self.frame.size.height-30);
    self.carNumberLab.frame = CGRectMake(0, 0, self.frame.size.width, 24);

}


@end
