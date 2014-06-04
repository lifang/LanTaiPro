//
//  StaffsCell.h
//  LanTaiPro
//
//  Created by lantan on 14-5-29.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataService.h"

@interface StaffsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *personBtn1;

@property (strong, nonatomic) IBOutlet UILabel *personNameLab1;

@property (strong, nonatomic) IBOutlet UILabel *personNameLab2;
@property (strong, nonatomic) IBOutlet UIButton *personBtn2;

@property (strong, nonatomic) NSString *personId1;
@property (strong, nonatomic) NSString *personId2;
- (IBAction)tapBtn:(UIButton *)sender;

//给cell赋值
-(void)initStaffsCell:(NSArray *)staffStoreArr AndUsedStaffsDic:(NSMutableArray *)usedStaffArr;
@end
