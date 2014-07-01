//
//  DrawSignView.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-20.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "DrawSignView.h"


@implementation DrawSignView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"DrawSignView" owner:self options:nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[DrawSignView class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        
        self.drawView=[[DrawView alloc]initWithFrame:frame];
        [self.drawView setBackgroundColor:[UIColor clearColor]];
        [self addSubview: self.drawView];
        [self sendSubviewToBack:self.drawView];
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"signView"]];
    }
    return self;
}
//后退
-(IBAction)remove:(id)sender{
    [ self.drawView revocation];
}
//清除
-(IBAction)clear:(id)sender{
    [self.drawView clear];
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
