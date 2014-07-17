//
//  PaySvcardCell.h
//  LanTaiPro
//
//  Created by comdosoft on 14-7-4.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySvcardCell : UITableViewCell

@property (nonatomic, strong) UILabel *lblPrice,*nameLab;
@property (nonatomic, strong) NSMutableDictionary *prod;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, strong) NSMutableArray *selectedArr;
@property (nonatomic, assign) int type;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier with:(NSMutableDictionary *)product indexPath:(NSIndexPath *)idx type:(int)type;

@end
