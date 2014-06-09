//
//  SelectedView.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-29.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "SelectedView.h"

@implementation SelectedView

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - 性别
+(SelectedView *)defaultSelectedViewWithFrame:(CGRect)frame type:(NSInteger)type withDefault:(NSString*)string selected:(void (^)(NSInteger tag))block
{
    SelectedView *selectedView = [[SelectedView alloc]initWithFrame:frame];
    
    UIImageView *imgView1 = [[UIImageView alloc]initWithFrame:(CGRect){20,10,64,62}];
    UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:(CGRect){136,10,64,62}];
    [selectedView addSubview:imgView1];
    [selectedView addSubview:imgView2];
    
    if (type==102) {//属性
        imgView1.image = [UIImage imageNamed:@"person"];
        QRadioButton *btn1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"property"];
        btn1.frame = (CGRect){94,50,22,22};
        btn1.tag = 0;
        [selectedView addSubview:btn1];
        btn1.delegate = selectedView;
        selectedView.button1 = btn1;
        
        imgView2.image = [UIImage imageNamed:@"company"];
        QRadioButton *btn2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"property"];
        btn2.frame = (CGRect){210,50,22,22};
        btn2.tag = 1;
        [selectedView addSubview:btn2];
        btn2.delegate = selectedView;
        selectedView.button2 = btn2;
        
    }else if (type==103){
        imgView1.image = [UIImage imageNamed:@"man"];
        QRadioButton *btn1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"sex"];
        btn1.frame = (CGRect){94,50,22,22};
        btn1.tag = 0;
        [selectedView addSubview:btn1];
        btn1.delegate = selectedView;
        selectedView.button1 = btn1;
        
        imgView2.image = [UIImage imageNamed:@"woman"];
        QRadioButton *btn2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"sex"];
        btn2.frame = (CGRect){210,50,22,22};
        btn2.tag = 1;
        [selectedView addSubview:btn2];
        btn2.delegate = selectedView;
        selectedView.button2 = btn2;
    }
    
    if (string) {
        if ([string integerValue]==0) {
            [selectedView.button1 setChecked:YES];
            [selectedView.button2 setChecked:NO];
        }else{
            [selectedView.button1 setChecked:NO];
            [selectedView.button2 setChecked:YES];
        }
    }else{
        [selectedView.button1 setChecked:YES];
        [selectedView.button2 setChecked:NO];
    }
    
    selectedView.selectedBlock = block;
    return selectedView;
}

#pragma mark QRadioButtonDelegate
-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    if (self.selectedBlock) {
        self.selectedBlock(radio.tag);
    }
}

@end
