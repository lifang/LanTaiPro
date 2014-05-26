//
//  LTImageViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-23.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 显示大图
 */

#import "ProductModel.h"
#import "XLCycleScrollView.h"

@interface LTImageViewController : UIViewController <XLCycleScrollViewDatasource,XLCycleScrollViewDelegate>

@property (nonatomic, strong) XLCycleScrollView *scrollView;

@property (nonatomic, strong) ProductModel *productModel;
//分类
@property (nonatomic, assign) NSInteger classifyType;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UIButton *shopButton;
//加入购物车的index
@property (nonatomic, strong) NSMutableArray *selectedArray;
@end
