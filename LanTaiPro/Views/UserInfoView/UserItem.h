//
//  UserItem.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-16.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

typedef enum{
    UserItemTypeNormalMode = 0,//正常模式
    UserItemTypeEditingMode = 1//进入编辑状态
}UserItemTypes;

@protocol UserItemDelegate;

@interface UserItem : UIView

@property (nonatomic, strong) UserModel *userModel;
///头像
@property (nonatomic, strong) UIImageView *userImageView;
//删除按钮
@property (nonatomic, strong) UIButton *deleteButton;
//点击按钮
@property (nonatomic, strong) UIButton *pressButton;
///长按坐标
@property (nonatomic) CGPoint point;
///编辑
@property (nonatomic) BOOL isEditing;
///移动
@property (nonatomic) BOOL isRemovable;
@property (nonatomic) NSInteger index;

@property(nonatomic)id<UserItemDelegate> delegate;

- (id) initWithUser:(UserModel *)userModel atIndex:(NSInteger)aIndex editable:(BOOL)removable;
- (void) enableEditing;
- (void) disableEditing;

@end


@protocol UserItemDelegate <NSObject>

- (void) userItemDidClicked:(UserItem *) gridItem;
- (void) userItemDidEnterEditingMode:(UserItem *) gridItem;
- (void) userItemDidDeleted:(UserItem *) gridItem atIndex:(NSInteger)index;
@end