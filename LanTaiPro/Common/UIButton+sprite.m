//
//  UIButton+sprite.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-26.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "UIButton+sprite.h"

@implementation UIButton (sprite)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self animateSmall];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self animateBig];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}
- (void)animateSmall
{
    CGRect frame = self.frame;

    frame.origin.x = frame.origin.x+3;
    frame.origin.y = frame.origin.y+3;
    frame.size.width = frame.size.width-6;
    frame.size.height = frame.size.height-6;

    [UIView animateWithDuration:0.25 animations:^{
        self.frame = frame;
    }];
}

- (void)animateBig
{
    CGRect frame = self.frame;

    frame.origin.x = frame.origin.x-3;
    frame.origin.y = frame.origin.y-3;
    frame.size.width = frame.size.width+6;
    frame.size.height = frame.size.height+6;

    [UIView animateWithDuration:0.25 animations:^{
        self.frame = frame;
    }];
}
@end
