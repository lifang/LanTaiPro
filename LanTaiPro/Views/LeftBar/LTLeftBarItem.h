//
//  LTLeftBarItem.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-15.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 首页侧边栏上面的按钮
 * 设置选中状态
 * by－－－邱成西
 */

@interface LTLeftBarItem : UIView

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, weak) IBOutlet UIButton *itemBtn;

@end
