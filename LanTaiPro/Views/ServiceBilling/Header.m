//
//  Header.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-10.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "Header.h"

@implementation Header

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (UILabel *)returnlabel
{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:20];
    return label;
}
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor = [UIColor clearColor];
        UILabel *lab1 = [self returnlabel];
        lab1.text = @"名称";
        lab1.frame = (CGRect){0,5,209,30};
        [self addSubview:lab1];
        
        UILabel *lab2 = [self returnlabel];
        lab2.text = @"单价";
        lab2.frame = (CGRect){210,5,106,30};
        [self addSubview:lab2];
        
        UILabel *lab3 = [self returnlabel];
        lab3.text = @"数量";
        lab3.frame = (CGRect){315,5,106,30};
        [self addSubview:lab3];
        
        UILabel *lab4 = [self returnlabel];
        lab4.text = @"小计";
        lab4.frame = (CGRect){420,5,106,30};
        [self addSubview:lab4];
    }
    return self;
}

@end
