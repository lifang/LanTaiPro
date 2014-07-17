//
//  UIViewController+MJPopupViewController.h
//  MJModalViewController
//
//  Created by Martin Juhasz on 11.05.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MJPopupViewAnimationSlideBottomTop = 1,
    MJPopupViewAnimationSlideRightLeft,
    MJPopupViewAnimationSlideBottomBottom,
    MJPopupViewAnimationFade
} MJPopupViewAnimation;

typedef void(^DismissCallBack)(BOOL isFinish);
typedef void(^FinishCallBack)(BOOL isFinish);

@interface UIViewController (MJPopupViewController)

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(MJPopupViewAnimation)animationType width:(CGFloat)width;
- (void)dismissPopupViewControllerWithanimationType:(MJPopupViewAnimation)animationType  dismissBlock:(DismissCallBack)dismissBlock;

@end