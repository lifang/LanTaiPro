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
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:15];
    return label;
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
        
        self.titleLabel.text = discountCard.name;
        self.validLabel.text = [NSString stringWithFormat:@"有效期:%@个月",discountCard.date_month];
        self.timeLabel.text = [NSString stringWithFormat:@"截止日期:%@",discountCard.ended];
        self.totalPriceLabe.text = [NSString stringWithFormat:@"面值:%@",discountCard.totle_price];
        
        NSString *content = [NSString stringWithFormat:@"适用:%@",discountCard.apply_content];
        NSString *total_content = [NSString stringWithFormat:@"%@ %@折",content,discountCard.discount];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:total_content];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,content.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1] range:NSMakeRange(content.length+1, total_content.length-content.length-1)];
        
        self.applyContentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.applyContentLabel.textAlignment = NSTextAlignmentCenter;
        self.applyContentLabel.backgroundColor = [UIColor clearColor];
        self.applyContentLabel.numberOfLines = 0;
        self.applyContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.applyContentLabel.attributedText = attributedString;
        self.applyContentLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:15];
        self.applyContentLabel.frame = (CGRect){10,65,141,discountCard.productList.count*30};
        [self.contentView addSubview:self.applyContentLabel];
        
        CGRect frame = CGRectMake(151, 65, 0, 30);
        for (int i=0; i<discountCard.productList.count; i++){
            frame.origin.y = 65+30*i;
            DiscountCardProductModel *disProduct = (DiscountCardProductModel *)discountCard.productList[i];
            
            //日期
            UILabel *timeLab = [self returnlabel];
            timeLab.text = disProduct.name;
            
            frame.origin.x = 151;
            frame.size.width =90;
            timeLab.frame = frame;
            [self.contentView addSubview:timeLab];
            //项目
            UILabel *nameLab = [self returnlabel];
            nameLab.text = disProduct.name;
            
            frame.origin.x += frame.size.width;
            frame.size.width =130;
            nameLab.frame = frame;
            [self.contentView addSubview:nameLab];
            //金额
            UILabel *pricrLab = [self returnlabel];
            pricrLab.text = disProduct.sale_price;
            
            frame.origin.x += frame.size.width;
            frame.size.width =100;
            pricrLab.frame = frame;
            [self.contentView addSubview:pricrLab];
            //折扣
            UILabel *discountLab = [self returnlabel];
            discountLab.text = [NSString stringWithFormat:@"%@折",discountCard.discount];
            
            frame.origin.x += frame.size.width;
            frame.size.width =43;
            discountLab.frame = frame;
            [self.contentView addSubview:discountLab];
            //优惠后
            UILabel *youhuiLab = [self returnlabel];
            float dis = [discountCard.discount floatValue]/10;
            youhuiLab.text = [NSString stringWithFormat:@"%.2f",[disProduct.sale_price floatValue]*dis];
            
            frame.origin.x += frame.size.width;
            frame.size.width =83;
            youhuiLab.frame = frame;
            [self.contentView addSubview:youhuiLab];
            //状态
            UILabel *statusLab = [self returnlabel];
            statusLab.text = @"成功";
            
            frame.origin.x += frame.size.width;
            frame.size.width =40;
            statusLab.frame = frame;
            [self.contentView addSubview:statusLab];
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
