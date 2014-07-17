//
//  DrawView.h
//  LanTaiPro
//
//  Created by comdosoft on 14-6-20.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView
///保存线条颜色
@property (nonatomic, strong) NSMutableArray *colorArray;
///保存被移除的线条颜色
@property (nonatomic, strong) NSMutableArray *deleColorArray;
///每次触摸结束前经过的点，形成线的点数组
@property (nonatomic, strong) NSMutableArray *pointArray;
///删除的线的数组，方便重做时取出来
@property (nonatomic, strong) NSMutableArray *deleArray;
///删除线条时删除的线条宽度储存的数组
@property (nonatomic, strong) NSMutableArray *deleWidthArray;
///每次触摸结束后的线数组
@property (nonatomic, strong) NSMutableArray *lineArray;
///正常存储的线条宽度的数组
@property (nonatomic, strong) NSMutableArray *WidthArray;

-(void)addPA:(CGPoint)nPoint;
-(void)addLA;
-(void)revocation;
-(void)refrom;
-(void)clear;
-(void)setLineColor:(NSInteger)color;
-(void)setlineWidth:(NSInteger)width;

@end
