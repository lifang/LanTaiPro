//
//  PaySvcardCell.m
//  LanTaiPro
//
//  Created by comdosoft on 14-7-4.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "PaySvcardCell.h"
#define OPEN 100
#define CLOSE 1000

@implementation PaySvcardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//type   0:活动   1:打折卡
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier with:(NSMutableDictionary *)product indexPath:(NSIndexPath *)idx type:(int)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.prod = [product mutableCopy];
        self.selectedArr = [NSMutableArray arrayWithArray:[self.prod objectForKey:@"products"]];
        self.index = idx;
        self.type = type;
        //名称
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];
        self.lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(250, 0, 104, 30)];
        self.lblPrice.textColor = [UIColor whiteColor];
        self.lblPrice.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:16];
        self.lblPrice.textAlignment = NSTextAlignmentCenter;
        
        if (type==0) {//----------------------------------------------------------------------------活动
            int disc_types =[[self.prod objectForKey:@"disc_types"]intValue];
            NSString *name = [NSString stringWithFormat:@"%@",[self.prod objectForKey:@"sale_name"]];
            if (disc_types==0) {
                NSString *content = [NSString stringWithFormat:@"%@:包含产品打%.1f折",name,[[self.prod objectForKey:@"discount"]floatValue]/10];
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,name.length+6)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1] range:NSMakeRange(name.length+6, content.length-1-name.length-6)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(content.length-1, 1)];
                
                self.nameLab.attributedText = attributedString;
            }else {
                NSString *content = [NSString stringWithFormat:@"%@:包含产品优惠%.2f元",name,[[self.prod objectForKey:@"price"]floatValue]];
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,name.length+7)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1] range:NSMakeRange(name.length+7, content.length-1-name.length-7)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(content.length-1, 1)];
                
                self.nameLab.attributedText = attributedString;
            }
            //优惠金额
            self.lblPrice.text = [NSString stringWithFormat:@"%.2f",[[self.prod objectForKey:@"show_price"]floatValue]];
            
        }else {//----------------------------------------------------------------------------打折卡
            NSString *name = [NSString stringWithFormat:@"%@",[self.prod objectForKey:@"card_name"]];
            NSString *content = [NSString stringWithFormat:@"%@:包含产品打%.1f折",name,[[self.prod objectForKey:@"discount"]floatValue]/10];

            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,name.length+6)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:91./255 green:223./255 blue:243./255 alpha:1] range:NSMakeRange(name.length+6, content.length-1-name.length-6)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(content.length-1, 1)];
            
            self.nameLab.attributedText = attributedString;
            
            //优惠金额
            self.lblPrice.text = [NSString stringWithFormat:@"%.2f",[[self.prod objectForKey:@"show_price"]floatValue]];
        }
        self.nameLab.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:16];
        [self.contentView addSubview:self.lblPrice];
        [self.contentView addSubview:self.nameLab];
        
        //包含项目
        CGRect frame = CGRectMake(354, 0, 250, 30);
        int len = self.selectedArr.count;
        
        for (int i=0; i<len; i++) {
            NSDictionary *dic = [self.selectedArr objectAtIndex:i];
            frame.origin.y = 30 * i;
            
            UILabel *lblProd = [[UILabel alloc] initWithFrame:frame];
            lblProd.lineBreakMode = NSLineBreakByCharWrapping;
            lblProd.numberOfLines = 0;
            lblProd.textAlignment = NSTextAlignmentRight;
            lblProd.backgroundColor = [UIColor clearColor];
            lblProd.textColor = [UIColor whiteColor];
            lblProd.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:16];
            
            if (self.type==0) {//活动
                lblProd.text = [NSString stringWithFormat:@"%@:%@次",[dic objectForKey:@"name"],[dic objectForKey:@"prod_num"]];
                
                if (i==0) {
                    frame.origin.x += 260;
                    frame.size.width = 30;
                    UIButton *sale_btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    sale_btn.frame = frame;
                    [sale_btn addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventTouchUpInside];
        
                    if ([[self.prod objectForKey:@"selected"] intValue] == 1 ) {
                        sale_btn.tag = OPEN +i;
                        [sale_btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                    }else if ([[self.prod objectForKey:@"selected"] intValue] == 0 ){
                        sale_btn.tag = CLOSE +i;
                        [sale_btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                    }
                    [self.contentView addSubview:sale_btn];
                }
            }else {//打折卡
                lblProd.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pname"]];

                if ([[dic objectForKey:@"selected"] intValue] == 1 ) {
                    lblProd.tag = OPEN +i+OPEN;
                }else {
                    lblProd.tag = CLOSE +i+CLOSE;
                }
                frame.origin.x += 260;
                frame.size.width = 30;
                if ([[self.prod objectForKey:@"is_new"]intValue]==0) {
                    UIButton *card_btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    card_btn.frame = frame;
                    [card_btn addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if ([[dic objectForKey:@"selected"] intValue] == 1) {
                        card_btn.tag = OPEN +i;
                        [card_btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                    }else if ([[dic objectForKey:@"selected"] intValue] == 0){
                        card_btn.tag = CLOSE +i;
                        [card_btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                    }
                    [self.contentView addSubview:card_btn];
                }
            }
            [self.contentView addSubview:lblProd];
            frame.origin.x = 354;
            frame.size.width = 250;
        }
        
        UIView *whiteView = [[UIView alloc]initWithFrame:(CGRect){0,30*len,648,1}];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteView];
        whiteView = nil;
    }
    return self;
}

//活动
- (NSString *)checkFormWithIndexRow:(int)row andId:(int)product_id andNumber:(int)num {
    NSMutableString *prod_count = [NSMutableString string];
    [prod_count appendFormat:@"%d_%d_%d,",row,product_id,num];
    return prod_count;
}
//打折卡
//选择
- (void)clickSwitch:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSString *tagStr = [NSString stringWithFormat:@"%d",btn.tag];
    [DataService sharedService].first = NO;
    CGFloat x = 0;
    CGFloat y = 0;
    NSMutableDictionary *dic;//对应产品
    
    NSArray *array = [[DataService sharedService].number_id allKeys];//产品、服务
    //纪录
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"%@",[self.prod objectForKey:@"sale_id"]];
    
    if (self.type==0) {//-----------------------------------------------------------------------------活动
        //纪录
        NSMutableString *string = [NSMutableString string];
        [string appendFormat:@"%@",[self.prod objectForKey:@"sale_id"]];
        //判断活动：优惠金额？打折？
        int disc_types = [[self.prod objectForKey:@"disc_types"]intValue];
        if (disc_types == 0){
            CGFloat discount_x = 0;
            CGFloat discount_y = 0;
            //折扣
            CGFloat sale_discount = 1 -[[self.prod objectForKey:@"discount"]floatValue]/100;
            if (tagStr.length == 3) {
                if ([DataService sharedService].saleArray.count>0) {
                    for (int i=0; i<[DataService sharedService].saleArray.count; i++) {
                        NSMutableString *str = [[DataService sharedService].saleArray objectAtIndex:i];
                        NSArray *arr = [str componentsSeparatedByString:@"_"];
                        NSString *s_id = [arr objectAtIndex:0];//活动id
                        if ([s_id intValue] == [string intValue]) {
                            [[DataService sharedService].saleArray removeObjectAtIndex:i];
                        }
                    }
                }
                //活动对应的产品
                for (int j=0; j<self.selectedArr.count; j++) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.selectedArr objectAtIndex:j]];
                    NSString * product_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"product_id"]];
                    //判断这个id在不在number_id里面
                    if ([array containsObject:product_id]) {//活动包含此产品
                        //从row_id_numArray数组中找到此产品被消费次数
                        int row = self.index.row;
                        int num = [[dic objectForKey:@"prod_num"]intValue];//活动里面的数目
                        discount_x = [[[DataService sharedService].price_id objectForKey:product_id] floatValue];//产品价格
                        int num_count = 0;
                        if ([DataService sharedService].row_id_numArray.count >0) {
                            int i = 0;
                            while (i<[DataService sharedService].row_id_numArray.count) {
                                NSString *str = [[DataService sharedService].row_id_numArray objectAtIndex:i];
                                NSArray *arr = [str componentsSeparatedByString:@"_"];
                                int index_row = [[arr objectAtIndex:0]intValue];
                                if (row == index_row) {//index.row相同
                                    int p_id = [[arr objectAtIndex:1]intValue];
                                    if (p_id == [product_id intValue]){
                                        //id相同
                                        num_count = [[arr objectAtIndex:2]intValue];
                                        discount_y = discount_y +discount_x *num_count *sale_discount;
                                        //重置number_id数据
                                        int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//剩余次数
                                        [[DataService sharedService].number_id removeObjectForKey:product_id];
                                        [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:product_id];
                                        
                                        //删除消费次数
                                        [[DataService sharedService].row_id_numArray removeObjectAtIndex:i];
                                        
                                        [dic setObject:[NSString stringWithFormat:@"%d",num + num_count] forKey:@"prod_num"];
                                        //修改活动
                                        [self.selectedArr replaceObjectAtIndex:j withObject:dic];
                                    }
                                    break;
                                }
                                i++;
                            }
                        }
                    }
                }
                
                CGFloat lbl_price = [self.lblPrice.text floatValue];
                if ((lbl_price+discount_y) <0.0001f ) {
                    self.lblPrice.text = @"0";
                }else {
                    self.lblPrice.text = [NSString stringWithFormat:@"%.2f",discount_y+lbl_price];
                }
                //////////////////////////////////////////////////
                x = discount_y;
                [self.prod setValue:@"0" forKey:@"selected"];
                [self.prod setObject:self.selectedArr forKey:@"products"];
                
                int tag = btn.tag;
                btn.tag = tag - OPEN + CLOSE;
                [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                
            }else {
                //活动对应的产品
                BOOL changeTag = NO;  BOOL showAlert = NO;
                for (int i=0; i<self.selectedArr.count; i++) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.selectedArr objectAtIndex:i]];
                    NSString * product_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"product_id"]];
                    //判断这个id在不在price_id里面
                    if ([array containsObject:product_id]) {//活动包含此产品
                        int num = [[dic objectForKey:@"prod_num"]intValue];//活动里面的数目
                        int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//活动－－用户选择的数目
                        
                        discount_x = 0-[[[DataService sharedService].price_id objectForKey:product_id]floatValue];//此产品的价格
                        if (count_num == 0) {
                            showAlert = YES;
                        }else {
                            changeTag = YES;
                            if (num <= count_num) {//用户次数大于活动提供次数
                                //初始count  --num
                                NSString *str = [self checkFormWithIndexRow:self.index.row andId:[product_id intValue] andNumber:num];
                                [[DataService sharedService].row_id_numArray addObject:str];
                                
                                discount_y = discount_y +discount_x * num*sale_discount;
                                //纪录
                                [string appendFormat:@"_%@=%.2f=%d",product_id,0-discount_x * num*sale_discount,num];
                                //重置number_id数据
                                [[DataService sharedService].number_id removeObjectForKey:product_id];
                                [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d",count_num - num] forKey:product_id];
                                
                                [dic setObject:[NSString stringWithFormat:@"%d",num - num] forKey:@"prod_num"];
                                //修改活动
                                [self.selectedArr replaceObjectAtIndex:i withObject:dic];
                            }else {//用户次数小于活动提供次数
                                //初始count  --count_num
                                NSString *str = [self checkFormWithIndexRow:self.index.row andId:[product_id intValue] andNumber:count_num];
                                [[DataService sharedService].row_id_numArray addObject:str];
                                discount_y = discount_y+ discount_x * count_num  *sale_discount;
                                //纪录
                                [string appendFormat:@"_%@=%.2f=%d",product_id,0-discount_x * count_num  *sale_discount,count_num];
                                
                                //重置number_id数据
                                [[DataService sharedService].number_id removeObjectForKey:product_id];
                                [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", count_num- count_num] forKey:product_id];
                                
                                [dic setObject:[NSString stringWithFormat:@"%d",num - count_num] forKey:@"prod_num"];
                                //修改活动
                                [self.selectedArr replaceObjectAtIndex:i withObject:dic];
                            }
                            x = discount_y;
                            CGFloat lbl_price = [self.lblPrice.text floatValue];
                            self.lblPrice.text = [NSString stringWithFormat:@"%.2f",discount_y+lbl_price];
                            [self.prod setValue:@"1" forKey:@"selected"];
                            [self.prod setObject:self.selectedArr forKey:@"products"];
                        }
                    }
                }
                if (changeTag==NO && showAlert==YES) {
                    [Utility errorAlert:@"您已经在其他项目中使用优惠，不必再重复使用" dismiss:YES];
                }
                if (changeTag == YES) {
                    [[DataService sharedService].saleArray addObject:string];
                    DLog(@"优惠金额333 ＋ %@",[DataService sharedService].saleArray);
                    
                    int tag = btn.tag;
                    btn.tag = tag - CLOSE + OPEN;
                    [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                }
            }
            [self.prod setObject:self.lblPrice.text forKey:@"show_price"];
            //////////////////////////////////////////////////
            NSString *price = [NSString stringWithFormat:@"%.2f",x];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:price,@"object",self.prod,@"prod",self.index,@"idx",@"1",@"type", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic];
        } else {
            //活动优惠金额
            CGFloat discount_x = 0;
            CGFloat discount_y = 0;
            
            if (tagStr.length == 3) {
                if ([DataService sharedService].saleArray.count>0) {
                    for (int i=0; i<[DataService sharedService].saleArray.count; i++) {
                        NSMutableString *str = [[DataService sharedService].saleArray objectAtIndex:i];
                        NSArray *arr = [str componentsSeparatedByString:@"_"];
                        NSString *s_id = [arr objectAtIndex:0];//活动id
                        if ([s_id intValue] == [string intValue]) {
                            [[DataService sharedService].saleArray removeObjectAtIndex:i];
                        }
                    }
                }
                DLog(@"优惠金额222 ＋ %@",[DataService sharedService].saleArray);
                if (self.selectedArr.count>0) {
                    discount_y = 0- [[_prod objectForKey:@"show_price"]floatValue];//优惠的金额
                    for (int j=0; j<self.selectedArr.count; j++) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.selectedArr objectAtIndex:j]];
                        NSString * product_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"product_id"]];
                        if ([array containsObject:product_id]) {//活动包含此产品
                            //从row_id_numArray数组中找到此产品被消费次数
                            int row = self.index.row;
                            int num = [[dic objectForKey:@"prod_num"]intValue];//活动里面的数目
                            
                            discount_x = [[[DataService sharedService].price_id objectForKey:product_id] floatValue];//产品价格
                            int num_count = 0;
                            if ([DataService sharedService].row_id_numArray.count >0) {
                                int i = 0;
                                while (i<[DataService sharedService].row_id_numArray.count) {
                                    NSString *str = [[DataService sharedService].row_id_numArray objectAtIndex:i];
                                    NSArray *arr = [str componentsSeparatedByString:@"_"];
                                    int index_row = [[arr objectAtIndex:0]intValue];
                                    if (row == index_row) {//index.row相同
                                        int p_id = [[arr objectAtIndex:1]intValue];
                                        if (p_id == [product_id intValue]){
                                            //id相同
                                            num_count = [[arr objectAtIndex:2]intValue];
                                            //                                        discount_y = discount_y +discount_x *num_count;
                                            //重置number_id数据
                                            int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//剩余次数
                                            [[DataService sharedService].number_id removeObjectForKey:product_id];
                                            [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:product_id];
                                            
                                            //删除消费次数
                                            [[DataService sharedService].row_id_numArray removeObjectAtIndex:i];
                                            
                                            [dic setObject:[NSString stringWithFormat:@"%d",num + num_count] forKey:@"prod_num"];
                                            //修改活动
                                            [self.selectedArr replaceObjectAtIndex:j withObject:dic];
                                        }
                                        break;
                                    }
                                    i++;
                                }
                            }
                        }
                    }
                    
                    NSDictionary *saleDic = [NSDictionary dictionaryWithObjectsAndKeys:self.selectedArr,@"product", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"packageCardreloadTableView" object:saleDic];
                    
                    CGFloat lbl_price = [self.lblPrice.text floatValue];
                    if ((lbl_price+discount_y) <0.0001f ) {
                        self.lblPrice.text = @"0";
                    }else {
                        self.lblPrice.text = [NSString stringWithFormat:@"%.2f",discount_y+lbl_price];
                    }
                    //////////////////////////////////////////////////
                    x = discount_y;
                    [self.prod setValue:@"0" forKey:@"selected"];
                    [self.prod setObject:self.selectedArr forKey:@"products"];
                    
                    int tag = btn.tag;
                    btn.tag = tag - OPEN + CLOSE;
                    [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
                }
            }else {
                if (self.selectedArr.count>0) {
                    for (int i=0; i<self.selectedArr.count; i++) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.selectedArr objectAtIndex:i]];
                        NSString * product_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"product_id"]];
                        if ([array containsObject:product_id]) {//活动包含此产品
                            int num = [[dic objectForKey:@"prod_num"]intValue];//活动里面的数目
                            int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//活动－－用户选择的数目
                            discount_x = 0-[[[DataService sharedService].price_id objectForKey:product_id]floatValue];//此产品的价格
                            if (count_num == 0) {
                                [Utility errorAlert:@"您已经在其他项目中使用优惠，不必再重复使用" dismiss:YES];
                            }else {
                                if (num <= count_num) {//用户次数大于活动提供次数
                                    //初始count  --num
                                    NSString *str = [self checkFormWithIndexRow:self.index.row andId:[product_id intValue] andNumber:num];
                                    [[DataService sharedService].row_id_numArray addObject:str];
                                    //纪录
                                    [string appendFormat:@"_%@=%.2f=%d",product_id,0-discount_x * num,num];
                                    
                                    discount_y = discount_y +discount_x * num;
                                    //重置number_id数据
                                    [[DataService sharedService].number_id removeObjectForKey:product_id];
                                    [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d",count_num - num] forKey:product_id];
                                    
                                    [dic setObject:[NSString stringWithFormat:@"%d",num - num] forKey:@"prod_num"];
                                    //修改活动
                                    [self.selectedArr replaceObjectAtIndex:i withObject:dic];
                                    
                                }else {//用户次数小于活动提供次数
                                    //初始count  --count_num
                                    NSString *str = [self checkFormWithIndexRow:self.index.row andId:[product_id intValue] andNumber:count_num];
                                    [[DataService sharedService].row_id_numArray addObject:str];
                                    
                                    //纪录
                                    [string appendFormat:@"_%@=%.2f=%d",product_id,0-discount_x * count_num,count_num];
                                    
                                    discount_y = discount_y+ discount_x * count_num;
                                    //重置number_id数据
                                    [[DataService sharedService].number_id removeObjectForKey:product_id];
                                    [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", count_num- count_num] forKey:product_id];
                                    
                                    [dic setObject:[NSString stringWithFormat:@"%d",num - count_num] forKey:@"prod_num"];
                                    //修改活动
                                    [self.selectedArr replaceObjectAtIndex:i withObject:dic];
                                }
                                CGFloat price_sale = [[_prod objectForKey:@"price"]floatValue];
                                CGFloat price_customer = discount_y;
                                if ((price_customer +price_sale)<0) {
                                    discount_y = 0-[[_prod objectForKey:@"price"] floatValue];
                                }
                                x = discount_y;
                                CGFloat lbl_price = [self.lblPrice.text floatValue];
                                self.lblPrice.text = [NSString stringWithFormat:@"%.2f",discount_y+lbl_price];
                                [self.prod setValue:@"1" forKey:@"selected"];
                                [self.prod setObject:self.selectedArr forKey:@"products"];
                                
                                int tag = btn.tag;
                                btn.tag = tag - CLOSE + OPEN;
                                [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                                
                                [string appendFormat:@"_%.2f",0-price_customer];
                                [[DataService sharedService].saleArray addObject:string];
                                DLog(@"优惠金额111 ＋ %@",[DataService sharedService].saleArray);
                            }
                        }
                    }
                }
            }
            
            [self.prod setObject:self.lblPrice.text forKey:@"show_price"];
            NSString *price = [NSString stringWithFormat:@"%.2f",x];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:price,@"object",self.prod,@"prod",self.index,@"idx",@"1",@"type", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic];
        }
    }else {//--------------------------------------------------------------------------------------------打折卡
        CGFloat discount_y = 0;
        
        if (tagStr.length == 3) {
            dic = [[self.selectedArr objectAtIndex:btn.tag - OPEN] mutableCopy];
            NSString * product_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pid"]];
            CGFloat scard_discount = 1 -[[self.prod objectForKey:@"discount"]floatValue]/100;//折扣
            y =[[dic objectForKey:@"pprice"] floatValue];
            int num_count = 0;
            if ([DataService sharedService].svcardArray.count >0) {
                int i = 0;
                while (i<[DataService sharedService].svcardArray.count) {
                    NSString *str = [[DataService sharedService].svcardArray objectAtIndex:i];
                    NSArray *arr = [str componentsSeparatedByString:@"_"];
                    int index_row = [[arr objectAtIndex:0]intValue];
                    if (self.index.row == index_row) {
                        int p_id = [[arr objectAtIndex:1]intValue];
                        if (p_id == [product_id intValue]) {
                            num_count = [[arr objectAtIndex:2]intValue];
                            discount_y = discount_y +y *num_count *scard_discount;
                            
                            //重置number_id数据
                            int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//剩余次数
                            [[DataService sharedService].number_id removeObjectForKey:product_id];
                            [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", num_count+count_num] forKey:product_id];
                            
                            //删除消费次数
                            [[DataService sharedService].svcardArray removeObjectAtIndex:i];
                            
                            [self.selectedArr replaceObjectAtIndex:btn.tag - OPEN withObject:dic];
                        }
                        break;
                    }
                    i++;
                }
            }
            x=discount_y;
            CGFloat lbl_price = [self.lblPrice.text floatValue];
            if ((lbl_price+discount_y) <0.0001f ) {
                self.lblPrice.text = @"0.00";
            }else {
                self.lblPrice.text = [NSString stringWithFormat:@"%.2f",discount_y+lbl_price];
            }
            [self.prod setValue:[NSString stringWithFormat:@"%@",self.lblPrice.text] forKey:@"show_price"];
            
            [dic setValue:@"0" forKey:@"selected"];
            [self.prod setObject:self.selectedArr forKey:@"products"];
            
            int tag = btn.tag;
            btn.tag = tag - OPEN + CLOSE;
            [btn setImage:[UIImage imageNamed:@"cb_mono_off"] forState:UIControlStateNormal];
        }else {
            dic = [[self.selectedArr objectAtIndex:btn.tag - CLOSE] mutableCopy];
            NSString * product_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pid"]];
            if ([array containsObject:product_id]) {
                CGFloat scard_discount = 1 -[[self.prod objectForKey:@"discount"]floatValue]/100;//折扣
                int count_num = [[[DataService sharedService].number_id objectForKey:product_id]intValue];//用户选择的数目
                y =0-[[dic objectForKey:@"pprice"] floatValue];
                if (count_num == 0) {
                    [Utility errorAlert:@"您已经在其他项目中使用优惠，不必再重复使用" dismiss:YES];
                }else {
                    //打折卡优惠产品次数
                    NSString *str = [self checkFormWithIndexRow:self.index.row andId:[product_id intValue] andNumber:count_num];
                    [[DataService sharedService].svcardArray addObject:str];
                    
                    //重置number_id数据
                    [[DataService sharedService].number_id removeObjectForKey:product_id];
                    [[DataService sharedService].number_id setObject:[NSString stringWithFormat:@"%d", count_num- count_num] forKey:product_id];
                    
                    x = count_num*y*scard_discount;//优惠金额

                    [dic setValue:@"1" forKey:@"selected"];
                    float showPrice = [[self.prod objectForKey:@"show_price"]floatValue];
                    [self.prod setValue:[NSString stringWithFormat:@"%.2f",showPrice+x] forKey:@"show_price"];
                    
                    self.lblPrice.text = [NSString stringWithFormat:@"%.2f",showPrice+x];
                    [self.selectedArr replaceObjectAtIndex:btn.tag-CLOSE withObject:dic];
                    
                    [self.prod setObject:self.selectedArr forKey:@"products"];
                    
                    int tag = btn.tag;
                    btn.tag = tag - CLOSE + OPEN;
                    [btn setImage:[UIImage imageNamed:@"cb_mono_on"] forState:UIControlStateNormal];
                    
                }
            }else {
                [Utility errorAlert:@"您本次消费中没有购买此产品" dismiss:YES];
            }
        }
        NSString *price = [NSString stringWithFormat:@"%.2f",x];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:price,@"object",self.prod,@"prod",self.index,@"idx",@"1",@"type", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_total" object:dic];
    }
}
@end
