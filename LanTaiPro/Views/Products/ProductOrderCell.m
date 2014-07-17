//
//  ProductOrderCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-22.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "ProductOrderCell.h"

@implementation ProductOrderCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier object:(id)object type:(NSInteger)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ProductOrderCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[ProductOrderCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.objectModel = object;
        self.type = type;
        if (type==0 || type==1) {
            self.addButton.hidden = NO;self.reduceButton.hidden = NO;
            ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.objectModel;
            self.titleLab.text = psModel.p_name;
            self.numberLab.text = [NSString stringWithFormat:@"%d",psModel.p_count];
            self.priceLab.text = psModel.p_price;
            self.totlaPriceLab.text = [NSString stringWithFormat:@"%.2f",[psModel.p_price floatValue]*psModel.p_count];
        }else {
            self.addButton.hidden = YES;self.reduceButton.hidden = YES;
            CardModel *cardModel = (CardModel *)self.objectModel;
            self.titleLab.text = cardModel.c_name;
            self.numberLab.text = [NSString stringWithFormat:@"%d",1];
            self.priceLab.text = cardModel.c_price;
            self.totlaPriceLab.text = cardModel.c_price;
        }
    }
    return self;
}

-(void)setIdxPath:(NSIndexPath *)idxPath{
    _idxPath = idxPath;
}

#pragma mark - 增／减 - 产品或服务
//tag=1增加，tag＝0减少
-(IBAction)buttonPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    BOOL isSuccess = NO;
    
    int count = [self.numberLab.text integerValue];//用户选择数量
    int tempCount = count;
    
    ProductAndServiceModel *psModel = (ProductAndServiceModel *)self.objectModel;
    if (btn.tag==1) {
        count += 1;
        if ([psModel.p_num integerValue]<0) {//没有库存限制
            isSuccess = YES;
            psModel.p_count += 1;
        }else {
            if (count>[psModel.p_num integerValue]) {
                [Utility errorAlert:@"库存不足" dismiss:YES];
            }else {
                isSuccess = YES;
                psModel.p_count += 1;
            }
        }

    }else {
        count -= 1;
        if (count<1) {
            [Utility errorAlert:@"至少选择1件产品" dismiss:YES];
        }else {
            isSuccess = YES;
            psModel.p_count -= 1;
        }
    }
    
    if (isSuccess == YES) {
        self.numberLab.text = [NSString stringWithFormat:@"%d",psModel.p_count];
        self.totlaPriceLab.text = [NSString stringWithFormat:@"%.2f",[psModel.p_price floatValue]*psModel.p_count];
        
        int count2 = [self.numberLab.text integerValue];
        
        float price = [psModel.p_price floatValue]*(count2-tempCount);
        
        NSDictionary *aDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2f",price],@"price", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Order_view_refresh_price" object:aDic];
        
        self.objectModel = psModel;
    }
}

@end
