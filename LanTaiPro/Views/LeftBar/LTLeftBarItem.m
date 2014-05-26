//
//  LTLeftBarItem.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "LTLeftBarItem.h"

@implementation LTLeftBarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - property
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    [_itemBtn setSelected:isSelected];
    [self setUserInteractionEnabled:!isSelected];
}

@end
