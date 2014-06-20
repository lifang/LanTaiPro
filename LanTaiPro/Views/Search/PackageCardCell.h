//
//  PackageCardCell.h
//  LanTaiPro
//
//  Created by comdosoft on 14-6-3.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PackageCardModel.h"

@protocol PackageCardCellDelegate;

@interface PackageCardCell : UITableViewCell

@property (nonatomic, assign) id<PackageCardCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (nonatomic, strong) PackageCardModel *packageModel;
@property (nonatomic, strong) NSIndexPath *idxPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier packageCardModel:(PackageCardModel *)package;
@end

@protocol PackageCardCellDelegate <NSObject>

//-(void)orderByPackageCard:(PackageCardCell *)cell;

@end