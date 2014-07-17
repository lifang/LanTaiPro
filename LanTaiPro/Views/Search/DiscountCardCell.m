//
//  DiscountCardCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-3.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "DiscountCardCell.h"

@implementation DiscountCardCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)returnlabel
{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1];
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:17];
    return label;
}

-(CGSize)getSizeWithString:(NSString *)str
{
    UIFont *aFont = [UIFont fontWithName:@"HiraginoSansGB-W6" size:17];
    CGSize size = [str sizeWithFont:aFont constrainedToSize:CGSizeMake(616, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier discountCard:(DiscountCardModel *)discountCard
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"DiscountCardCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[DiscountCardCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.backgroundColor = [UIColor clearColor];
        
        NSString *title = [NSString stringWithFormat:@"%@:%@",discountCard.name,discountCard.totle_price];
        
        NSMutableAttributedString *title_attributedString = [[NSMutableAttributedString alloc] initWithString:title];
        [title_attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,discountCard.name.length+1)];
        [title_attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1] range:NSMakeRange(discountCard.name.length+1, title.length-discountCard.name.length-1)];
        self.titleLabel.attributedText = title_attributedString;
        
        self.validLabel.text = [NSString stringWithFormat:@"有效期:%@个月",discountCard.date_month];
        self.timeLabel.text = [NSString stringWithFormat:@"截止日期:%@",discountCard.ended];

        NSString *content = [NSString stringWithFormat:@"适用:%@",discountCard.apply_content];
        NSString *total_content = [NSString stringWithFormat:@"%@ %.1f折",content,[discountCard.discount floatValue]/10];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:total_content];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,content.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1] range:NSMakeRange(content.length+1, total_content.length-content.length-1)];
        
        self.applyContentLabel.attributedText = attributedString;
        

    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
