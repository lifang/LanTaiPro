//
//  ProductOrderCell.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-22.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductOrderCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLab;
@property (nonatomic, weak) IBOutlet UILabel *numberLab;
@property (nonatomic, weak) IBOutlet UILabel *priceLab;
@property (nonatomic, weak) IBOutlet UILabel *totlaPriceLab;

@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, weak) IBOutlet UIButton *reduceButton;
@end
