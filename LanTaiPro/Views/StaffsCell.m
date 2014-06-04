//
//  StaffsCell.m
//  LanTaiPro
//
//  Created by lantan on 14-5-29.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "StaffsCell.h"
#define SELETED 100
#define UNSELETED 1000

@implementation StaffsCell

- (void)awakeFromNib
{
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle]loadNibNamed:@"StaffsCell" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0]isKindOfClass:[StaffsCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
//给cell赋值
-(void)initStaffsCell:(NSArray *)staffStoreArr AndUsedStaffsDic:(NSMutableArray *)usedStaffArr
{
        for (int i = 0; i < staffStoreArr.count; i++) {
        NSDictionary *staffStoreDic = [[NSDictionary alloc]initWithDictionary:[staffStoreArr objectAtIndex:i]];
        if (i == 0) {
            
            self.personNameLab1.text = [NSString stringWithFormat:@"%@",[staffStoreDic objectForKey:@"name"]];
            self.personId1 = [NSString stringWithFormat:@"%@",[staffStoreDic objectForKey:@"id"]];
            if ([usedStaffArr containsObject:staffStoreDic]) {
                [self.personBtn1 setBackgroundImage:[UIImage imageNamed:@"station-activePerson"] forState:UIControlStateNormal];
                self.personBtn1.tag = 101;
            }
        }
        else
        {
            if (staffStoreArr.count == 2) {
                self.personNameLab2.text = [NSString stringWithFormat:@"%@",[staffStoreDic objectForKey:@"name"]];
                self.personId2 = [NSString stringWithFormat:@"%@",[staffStoreDic objectForKey:@"id"]];
                if ([usedStaffArr containsObject:staffStoreDic]) {
                    [self.personBtn2 setBackgroundImage:[UIImage imageNamed:@"station-activePerson"] forState:UIControlStateNormal];
                    self.personBtn2.tag = 102;
                }
                else
                {
                    [self.personBtn2 setBackgroundImage:[UIImage imageNamed:@"station-person"] forState:UIControlStateNormal];
                }
            }
        }
    }
    
}
//选择技师
- (IBAction)tapBtn:(UIButton *)sender {
    NSString *tagStr = [NSString stringWithFormat:@"%d",sender.tag];
    if (tagStr.length == 4) {
        NSInteger tagInt = sender.tag;
            //判断是第一个Btn
        if (tagInt-UNSELETED == 1) {
            //判断[DataService sharedService].staffIdArr是不是包含了该技师
            if (![[DataService sharedService].staffIdArr containsObject:self.personId1]) {
                [[DataService sharedService].staffIdArr addObject:self.personId1];
                //判断是不是为空
                if ([[DataService sharedService].staffNameStr isEqualToString:@" "]) {
                    [[DataService sharedService].staffNameStr setString:@""];
                    [[DataService sharedService].staffNameStr appendString:self.personNameLab1.text];
                }
                else
                {
                    [[DataService sharedService].staffNameStr appendString:[NSString stringWithFormat:@" %@",self.personNameLab1.text]];
                }
               
            }
        }
        else{
            if (![[DataService sharedService].staffIdArr containsObject:self.personId2]) {
                [[DataService sharedService].staffIdArr addObject:self.personId2];
                if ([[DataService sharedService].staffNameStr isEqualToString:@" "]) {
                    [[DataService sharedService].staffNameStr setString:@""];
                    [[DataService sharedService].staffNameStr appendString:self.personNameLab2.text];
                }
                else
                {
                    [[DataService sharedService].staffNameStr appendString:[NSString stringWithFormat:@" %@",self.personNameLab2.text]];
                }

            }

        }
        [sender setBackgroundImage:[UIImage imageNamed:@"station-activePerson"] forState:UIControlStateNormal];
        sender.tag = tagInt - UNSELETED +SELETED;
           }
    else
    {
        NSInteger tagInt = sender.tag;
        
        if (tagInt-SELETED == 1) {
            [[DataService sharedService].staffIdArr removeObject:self.personId1];
            [self deleteUnseletedStaffs:self.personNameLab1.text];
        }
        else{
            [[DataService sharedService].staffIdArr removeObject:self.personId2];
            [self deleteUnseletedStaffs:self.personNameLab2.text];

        }

        [sender setBackgroundImage:[UIImage imageNamed:@"station-person"] forState:UIControlStateNormal];
        sender.tag = tagInt - SELETED +UNSELETED;
    }
    //添加通知，显示已选择的技师
     [[NSNotificationCenter defaultCenter] postNotificationName:@"showSeletedStaffs" object:self];
 }
//[DataService sharedService].staffNameStr 去掉没打勾的技师的name
-(void)deleteUnseletedStaffs:(NSString *)unSeletedStaffsStr
{
    NSRange range;

    if ([[DataService sharedService].staffNameStr hasPrefix:unSeletedStaffsStr]) {
        range = [[DataService sharedService].staffNameStr rangeOfString:[NSString stringWithFormat:@"%@",unSeletedStaffsStr]];
    }
    else
    {
         range = [[DataService sharedService].staffNameStr rangeOfString:[NSString stringWithFormat:@" %@",unSeletedStaffsStr]];
    }
       [[DataService sharedService].staffNameStr deleteCharactersInRange:range];
}
@end
