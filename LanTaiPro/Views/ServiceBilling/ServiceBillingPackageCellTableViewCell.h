//
//  ServiceBillingPackageCellTableViewCell.h
//  LanTaiPro
//
//  Created by comdosoft on 14-6-9.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PackageCardModel.h"

@protocol ServiceBillingPackageCellDelegate;

@interface ServiceBillingPackageCellTableViewCell : UITableViewCell

@property (nonatomic, assign) id<ServiceBillingPackageCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) NSIndexPath *idxPath;
@property (nonatomic, strong) PackageCardModel *packageModel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier packageCardModel:(PackageCardModel *)package;

@end

@protocol ServiceBillingPackageCellDelegate <NSObject>

//-(void)orderByPackageCard:(PackageCardCell *)cell;

@end