//
//  LTLocalUserViewController.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-16.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 门店对应的本地用户
 * 用户头像
 * 增加用户
 * 退出帐号
 * by－－－邱成西
 */

#import "UserItem.h"

@protocol LocalUserViewControlDelegate;

@interface LTLocalUserViewController : UIViewController<UIScrollViewDelegate,UserItemDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) AppDelegate *appDel;
@property (nonatomic, assign) id<LocalUserViewControlDelegate>delegate;

///存放item的数组
@property (nonatomic, strong) NSMutableArray *itemsArray;
///存放获取本地user的数组
@property (nonatomic, strong) NSMutableArray *userArray;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollview;
///判定是否页面消失后操作
///  0－消失后到登录页面logView
///  1－消失后到rootView
///  2－不操作
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) UITapGestureRecognizer *singletap;
@end

@protocol LocalUserViewControlDelegate <NSObject>

- (void)disMissViewControl:(LTLocalUserViewController *)viewControl;

@end