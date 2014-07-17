//
//  PayPackagecardCell.h
//  LanTaiPro
//
//  Created by comdosoft on 14-7-4.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayPackagecardCell : UITableViewCell

@property (nonatomic,strong) UILabel *lblName,*lblPrice;
@property (nonatomic,strong) NSMutableArray *selectedArr;
@property (nonatomic,strong) NSMutableDictionary *product;
@property (nonatomic,strong) NSIndexPath *index;
@property (nonatomic,assign) NSInteger cellType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier with:(NSMutableDictionary *)prod indexPath:(NSIndexPath *)idx type:(NSInteger)type;

@end
