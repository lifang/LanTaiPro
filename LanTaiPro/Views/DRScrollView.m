//
//  DRScrollView.m
//  LanTaiPro
//
//  Created by lantan on 14-6-13.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "DRScrollView.h"
#import "ConstationCarView.h"
#import "CarView.h"
@interface DRScrollView ()
@property (nonatomic,strong) NSTimer *scrollTimer;
@property (nonatomic,assign) int step;
@end
@implementation DRScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[ConstationCarView class]]) {
             ConstationCarView *constationCarView = (ConstationCarView*)subView;
            CGRect superRect = [constationCarView convertRect:constationCarView.carView.frame toView:self];
            if (CGRectContainsPoint(superRect, point) && !constationCarView.isEmpty) {
                return [self superview];
            }
        }
    }
    return [super hitTest:point withEvent:event];
}

-(void)startScrollContentWithStep:(int)step{
    self.step = step;
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scrollMiddleScrollview) userInfo:nil repeats:YES];
}

-(void)stopScroll{
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

-(void)scrollMiddleScrollview{
    if (self.step > 0 && self.contentOffset.y < self.contentSize.height - CGRectGetHeight(self.frame)) {
        self.contentOffset = (CGPoint){self.contentOffset.x,self.contentOffset.y+self.step};
    }else
        if (self.step < 0 && self.contentOffset.y > 0) {
            self.contentOffset = (CGPoint){self.contentOffset.x,self.contentOffset.y+self.step};
        }else{
            [self stopScroll];
        }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
