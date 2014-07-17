//
//  PackageCardCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-6-3.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PackageCardCell.h"

#define LeftBtnTag 100
#define RightBtnTag 1000

#define LabelTag  85478

@implementation PackageCardCell

- (void)awakeFromNib
{
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
    return label;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier packageCardModel:(PackageCardModel *)package
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PackageCardCell" owner:self options: nil];
        if(arrayOfViews.count < 1){return nil;}
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[PackageCardCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.backgroundColor = [UIColor clearColor];
        
        self.packageModel = package;
        
        self.titleLabel.text = package.name;
        self.timeLabel.text = [NSString stringWithFormat:@"截止时间:%@",package.ended_at];
        
        
        CGRect frame = CGRectMake(0, 54, 0, 30);
        for (int i=0; i<package.productList.count; i++) {
            frame.size.height = 30;
            PackageCardProductModel *packageProduct = (PackageCardProductModel *)package.productList[i];
            //左边---------------------
            NSString *content = [NSString stringWithFormat:@"%@ %@次",packageProduct.name,packageProduct.product_num];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, packageProduct.name.length)];
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1] range:NSMakeRange(packageProduct.name.length+1, packageProduct.product_num.length)];
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(content.length-1, 1)];
            
            UILabel *leftLab = [self returnlabel];
            leftLab.attributedText = attributedString;
            leftLab.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:16];
            
            frame.origin.x = 10;
            frame.size.width = 158;
            frame.origin.y = 54+30*i;
            leftLab.frame = frame;
        
            [self.contentView addSubview:leftLab];
            //右边---------------------
            //项目
            UILabel *nameLab = [self returnlabel];
            nameLab.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:20];
            nameLab.textColor = [UIColor whiteColor];
            nameLab.text = packageProduct.name;
            
            frame.origin.x = 169;
            frame.size.width = 180;
            frame.origin.y = 74+30*i;
            nameLab.frame = frame;
            [self.contentView addSubview:nameLab];
            //已使用
            UILabel *useLab = [self returnlabel];
            useLab.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:20];
            useLab.textColor = [UIColor whiteColor];
            useLab.text = [NSString stringWithFormat:@"%d",[packageProduct.product_num integerValue]-[packageProduct.unused_num integerValue]];
            
            frame.origin.x = 349;
            frame.size.width = 80;
            frame.origin.y = 74+30*i;
            useLab.frame = frame;
            [self.contentView addSubview:useLab];
            //剩余
            UILabel *unuseLab = [self returnlabel];
            unuseLab.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:20];
            unuseLab.textColor = [UIColor whiteColor];
            unuseLab.text = packageProduct.unused_num;
            
            frame.origin.x = 429;
            frame.size.width = 80;
            frame.origin.y = 74+30*i;
            unuseLab.frame = frame;
            [self.contentView addSubview:unuseLab];
            
            //选择框
            if ([packageProduct.unused_num integerValue]>0) {//还有未使用
                
                frame.origin.x = 509;
                frame.size.width = 30;
                frame.size.height = 30;
                frame.origin.y = 74+30*i;
                
                UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                leftBtn.frame =frame;
                leftBtn.tag = LeftBtnTag+i;
                [leftBtn setImage:[UIImage imageNamed:@"product-add.png"] forState:UIControlStateNormal];
                [leftBtn addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:leftBtn];
                
                frame.origin.x = 539;
                UILabel *label = [self returnlabel];
                label.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:20];
                label.textColor = [UIColor whiteColor];
                label.frame = frame;
                label.tag = LabelTag +i;
                label.text = [NSString stringWithFormat:@"%@",packageProduct.selected_num];
                [self.contentView addSubview:label];
                
                frame.origin.x = 569;
                UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                rightBtn.frame =frame;
                rightBtn.tag = RightBtnTag+i;
                [rightBtn setImage:[UIImage imageNamed:@"product-reduce"] forState:UIControlStateNormal];
                [rightBtn addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:rightBtn];
                
            }
        }
        
        
        
    }
    return self;
}
//row_btnTag_套餐卡id_产品id_数量
-(NSString *)returnStringWith:(int)btnTag
{
    PackageCardProductModel *packageProduct = (PackageCardProductModel *)self.packageModel.productList[btnTag];
    NSString *string = [NSString stringWithFormat:@"%d_%d_%@_%@_%@",self.idxPath.row,btnTag,self.packageModel.cus_card_id,packageProduct.productId,packageProduct.selected_num];
    return string;
}

//加
-(void)leftButtonPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    PackageCardProductModel *packageProduct = (PackageCardProductModel *)self.packageModel.productList[btn.tag-LeftBtnTag];
    
    UILabel *label = (UILabel *)[self.contentView viewWithTag:(btn.tag-LeftBtnTag+LabelTag)];
    int count = [label.text intValue];
    //判断库存
    if ((count+1)>[packageProduct.several_times intValue]) {
        NSString *message = [NSString stringWithFormat:@"%@ 库存不足",packageProduct.name];
        [Utility errorAlert:message dismiss:YES];
    }
    else
    {
        if ((count+1)>[packageProduct.unused_num intValue]) {
            NSString *message = [NSString stringWithFormat:@"套餐卡最多只能选择:%@",packageProduct.unused_num];
            [Utility errorAlert:message dismiss:YES];
        }
        else
        {
            packageProduct.selected_num = [NSString stringWithFormat:@"%d",count+1];
            [self.packageModel.productList replaceObjectAtIndex:(btn.tag-LeftBtnTag) withObject:packageProduct];
            label.text = [NSString stringWithFormat:@"%d",count+1];
            
            
            if (![LTDataShare sharedService].packageOrderArray) {
                [LTDataShare sharedService].packageOrderArray = [[NSMutableArray alloc]init];
                
                NSString *string = [self returnStringWith:(btn.tag-LeftBtnTag)];
                [[LTDataShare sharedService].packageOrderArray addObject:string];
            }else {
                BOOL isExit = NO;
                if ([LTDataShare sharedService].packageOrderArray.count>0){
                    for (int i=0; i<[LTDataShare sharedService].packageOrderArray.count; i++) {
                        NSString *string = [LTDataShare sharedService].packageOrderArray[i];
                        NSArray *array = [string componentsSeparatedByString:@"_"];
                        if ([array[2] intValue]==[self.packageModel.cus_card_id intValue] && [array[3] intValue]==[packageProduct.productId intValue]) {
                            NSString *string2 = [self returnStringWith:(btn.tag-LeftBtnTag)];
                            [[LTDataShare sharedService].packageOrderArray replaceObjectAtIndex:i withObject:string2];
                            isExit = YES;
                            break;
                        }
                    }
                }
                
                if (isExit == NO) {
                    NSString *string = [self returnStringWith:(btn.tag-LeftBtnTag)];
                    [[LTDataShare sharedService].packageOrderArray addObject:string];
                }
            }
            
            DLog(@"##  %@",[LTDataShare sharedService].packageOrderArray)
            
        }
    }
    
}
//减
-(void)rightButtonPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;

    PackageCardProductModel *packageProduct = (PackageCardProductModel *)self.packageModel.productList[btn.tag-RightBtnTag];
    
    UILabel *label = (UILabel *)[self.contentView viewWithTag:(btn.tag-RightBtnTag+LabelTag)];
    int count = [label.text intValue];
    
    if ((count-1)<0) {
        
    }else {
        label.text = [NSString stringWithFormat:@"%d",count-1];
        
        packageProduct.selected_num = [NSString stringWithFormat:@"%d",count-1];
        [self.packageModel.productList replaceObjectAtIndex:(btn.tag-RightBtnTag) withObject:packageProduct];
        
        for (int i=0; i<[LTDataShare sharedService].packageOrderArray.count; i++) {
            NSString *string = [LTDataShare sharedService].packageOrderArray[i];
            NSArray *array = [string componentsSeparatedByString:@"_"];
            if ([array[2] intValue]==[self.packageModel.cus_card_id intValue] && [array[3] intValue]==[packageProduct.productId intValue]) {
                if ((count-1)==0) {
                    [[LTDataShare sharedService].packageOrderArray removeObject:string];
                }else {
                    NSString *string2 = [self returnStringWith:(btn.tag-RightBtnTag)];
                    [[LTDataShare sharedService].packageOrderArray replaceObjectAtIndex:i withObject:string2];
                }
                
                break;
            }
        }
        
        DLog(@"##!!  %@",[LTDataShare sharedService].packageOrderArray)
    }
    
}
@end
