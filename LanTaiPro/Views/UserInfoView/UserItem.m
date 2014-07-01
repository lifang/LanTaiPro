//
//  UserItem.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-16.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "UserItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation UserItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)roundView: (UIView *) view
{
    [view.layer setCornerRadius:(view.frame.size.height/2)];
    [view.layer setMasksToBounds:YES];
}
- (id) initWithUser:(UserModel *)userModel atIndex:(NSInteger)aIndex editable:(BOOL)removable
{
    self = [super initWithFrame:CGRectMake(0, 0, 82, 82)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.isEditing = NO;
        _index = aIndex;
        self.isRemovable = removable;
    
        [self roundView:self];
        
        _userImageView = [[UIImageView alloc]initWithFrame:self.frame];
        _userImageView.backgroundColor = [UIColor clearColor];
        if (userModel) {
            self.userModel = userModel;
            [_userImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.userModel.kHost,self.userModel.userImg]] placeholderImage:[UIImage imageNamed:@"nonPic"]];
        }else {
            [_userImageView setImage:[UIImage imageNamed:@"userAdd"]];
        }
        //头像
        [self addSubview:_userImageView];
        
        //item上面加点击按钮
        _pressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pressButton setFrame:self.bounds];
        [_pressButton setBackgroundColor:[UIColor clearColor]];
        [_pressButton addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        //长按事件
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
        [self addGestureRecognizer:longPress];
        longPress = nil;
        [self addSubview:_pressButton];
        
        if (self.isRemovable) {
            _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            float w = 24;
            float h = 24;
            
            [_deleteButton setFrame:CGRectMake((self.frame.size.width-w)/2,(self.frame.size.height-h)/2, w, h)];
            [_deleteButton setImage:[UIImage imageNamed:@"deletbutton.png"] forState:UIControlStateNormal];
            _deleteButton.backgroundColor = [UIColor clearColor];
            [_deleteButton addTarget:self action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_deleteButton setHidden:YES];
            [self addSubview:_deleteButton];
        }
    }
    return self;
}

#pragma mark - UI actions

- (void) clickItem:(id)sender
{
    [_delegate userItemDidClicked:self];
}
- (void) pressedLong:(UILongPressGestureRecognizer *) gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            _point = [gestureRecognizer locationInView:self];
            [_delegate userItemDidEnterEditingMode:self];
            [self setAlpha:1.0];
            break;
        case UIGestureRecognizerStateEnded:
            break;
        case UIGestureRecognizerStateFailed:
            break;
        case UIGestureRecognizerStateChanged:
            break;
        default:
            
            break;
    }
}

- (void) removeButtonClicked:(id) sender  {
    [_delegate userItemDidDeleted:self atIndex:_index];
}

#pragma mark - Custom Methods

- (void) enableEditing {
    
    if (self.isEditing == YES)
        return;
    
    self.isEditing = YES;
    
    [_deleteButton setHidden:NO];
    [_pressButton setEnabled:NO];

    CGFloat rotation = 0.03;
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.13;
    shake.autoreverses = YES;
    shake.repeatCount  = MAXFLOAT;
    shake.removedOnCompletion = NO;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
    shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
    
    [self.layer addAnimation:shake forKey:@"shakeAnimation"];
}

- (void) disableEditing {
    [self.layer removeAnimationForKey:@"shakeAnimation"];
    [_deleteButton setHidden:YES];
    [_pressButton setEnabled:YES];
    self.isEditing = NO;
}

# pragma mark - Overriding UiView Methods
- (void) removeFromSuperview {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        [self setFrame:CGRectMake(self.frame.origin.x+50, self.frame.origin.y+50, 0, 0)];
        [_deleteButton setFrame:CGRectMake(0, 0, 0, 0)];
    }completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
