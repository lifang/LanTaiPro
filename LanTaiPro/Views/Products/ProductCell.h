//
//  ProductCell.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-22.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProductModel.h"

@protocol ProductCellDelegate ;

@interface ProductCell : UITableViewCell

@property (nonatomic, assign) id<ProductCellDelegate>delegate;
///背景图片
@property (nonatomic, strong) UIImageView *backgroundImageView;
///头像
@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
///标题
@property (nonatomic, weak) IBOutlet UILabel *titlelabel;
///介绍
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
///选中状态
@property (nonatomic, weak) IBOutlet UIButton *statusButton;
///数量显示
@property (nonatomic, weak) IBOutlet UIImageView *numberImageView;
///图片上按钮
@property (nonatomic, weak) IBOutlet UIButton *coverBtn;

@property (nonatomic, strong) id objectModel;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSIndexPath *idxPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier object:(id)object type:(NSInteger)type;
@end

@protocol ProductCellDelegate <NSObject>

-(void)selectedProduct:(UIButton *)btn cell:(ProductCell *)cell isSelected:(BOOL)animated;
-(void)expandWithButton:(UIButton *)btn Cell:(ProductCell *)cell;
@end