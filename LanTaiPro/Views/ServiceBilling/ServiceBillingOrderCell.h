//
//  ServiceBillingOrderCell.h
//  LanTaiPro
//
//  Created by comdosoft on 14-6-10.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderProductModel.h"

@interface ServiceBillingOrderCell : UITableViewCell

@property (nonatomic, strong) OrderProductModel *proModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier product:(OrderProductModel *)product;
@end
