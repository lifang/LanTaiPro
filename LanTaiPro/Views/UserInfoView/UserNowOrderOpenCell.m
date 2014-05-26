//
//  UserNowOrderOpenCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "UserNowOrderOpenCell.h"

@implementation UserNowOrderOpenCell

- (void)awakeFromNib
{
    self.lineView = [[UIView alloc]initWithFrame:CGRectZero];
    self.lineView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.lineView];
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
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:17];
    return label;
}
- (NSString *)returnStringWithUserNowOrderProductModel:(UserNowOrderProductModel *)proModel number:(int)k
{
    switch (k) {
        case 0:
            return proModel.p_name;
            break;
        case 1:
            return proModel.p_number;
            break;
        case 2:
            return proModel.p_price;
            break;
        case 3:
            return proModel.p_totalPrice;
            break;
            
        default:
            return nil;
            break;
    }
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier userNowOrderModel:(UserNowOrderModel *)userNowOrder
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"UserNowOrderOpenCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UserNowOrderOpenCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        
        
        self.orderCodeLabel.text = [NSString stringWithFormat:@"%@",userNowOrder.orderCode];
        self.orderNumLabel.text = [NSString stringWithFormat:@"%@",userNowOrder.orderNum];
        
        //产品
        CGRect frame = CGRectMake(0, 80, 142, 30);
        
        for (int i=0; i<userNowOrder.productList.count; i++) {
            UserNowOrderProductModel *proModel = (UserNowOrderProductModel *)userNowOrder.productList[i];
            
            for (int k=0; k<4; k++) {
                UILabel *label = [self returnlabel];
                frame.origin.x = 142*k;
                label.frame = frame;
                label.text = [self returnStringWithUserNowOrderProductModel:proModel number:k];
                [self.contentView addSubview:label];
                label = nil;
            }
            frame.origin.x = 0;
            frame.origin.y += 30;
        }
        
        NSString *string = [NSString stringWithFormat:@"总计:  %@",userNowOrder.orderPrice];
        CGSize size = [string sizeWithFont:[UIFont fontWithName:@"HiraginoSansGB-W3" size:17]];
        
        frame.origin.x = self.frame.size.width-size.width-40;
        UILabel *label = [self returnlabel];
        label.frame = frame;
        label.text = string;
        [self.contentView addSubview:label];
        label = nil;
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.lineView.frame = (CGRect){0,self.frame.size.height-1,self.frame.size.width,1};
}
@end
