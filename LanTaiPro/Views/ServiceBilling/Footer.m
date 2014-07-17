//
//  Footer.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-10.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "Footer.h"

@implementation Footer

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
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1];
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:20];
    return label;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = (CGRect){0,0,526,30};
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.totalPriceLabel = [self returnlabel];
        self.totalPriceLabel.frame = (CGRect){0,0,526,30};
        [self addSubview:self.totalPriceLabel];
    }
    return self;
}
@end
