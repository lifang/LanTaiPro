//
// SVPullToRefresh.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "SVPullToRefresh.h"

enum {
    SVPullToRefreshStateHidden = 1,
	SVPullToRefreshStateVisible,
    SVPullToRefreshStateTriggered,
    SVPullToRefreshStateLoading
};

typedef NSUInteger SVPullToRefreshState;

@interface SVPullToRefresh ()

- (id)initWithScrollView:(UIScrollView*)scrollView;
- (void)rotateArrow:(float)degrees hide:(BOOL)hide;
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset;
- (void)scrollViewDidScroll:(CGPoint)contentOffset;

@property (nonatomic, copy) void (^actionHandler)(void);
@property (nonatomic, readwrite) SVPullToRefreshState state;
@property (nonatomic, retain) UILabel *lastUpdatedLabel;
@property (nonatomic, retain) UIImageView *arrow;
@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, readwrite) UIEdgeInsets originalScrollViewContentInset;

@end


@implementation SVPullToRefresh

// public properties
@synthesize actionHandler, arrowColor, textColor;

@synthesize state;
@synthesize scrollView = _scrollView;
@synthesize originalScrollViewContentInset;

- (id)initWithScrollView:(UIScrollView *)scrollView {
    self = [super initWithFrame:CGRectZero];
    self.scrollView = scrollView;
    [_scrollView addSubview:self];
    self.frame = CGRectMake(0, -60, scrollView.bounds.size.width, 60);
    
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-140)/2, 45, 140, 15)]autorelease];
    self.titleLabel.text = NSLocalizedString(@"使劲...",);
    self.titleLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:12];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    // default styling values
    self.arrowColor = [UIColor whiteColor];
    self.lastUpdatedLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.arrow];
    
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    self.originalScrollViewContentInset = scrollView.contentInset;
    
    self.state = SVPullToRefreshStateHidden;    
    

    return self;
}


#pragma mark - Getters
#warning 更改logo
- (UIImageView *)arrow {
    if(!_arrow) {
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userInfo-active"]];
        _arrow.frame = CGRectMake((self.frame.size.width-40)/2, 5, 40, 40);
        _arrow.backgroundColor = [UIColor clearColor];
    }
    return _arrow;
}
#pragma mark - Setters

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollView.contentInset = contentInset;
    } completion:NULL];
}


#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {    
    CGFloat scrollOffsetThreshold = self.frame.origin.y-self.originalScrollViewContentInset.top;
    
    if(!self.scrollView.isDragging && self.state == SVPullToRefreshStateTriggered)
        self.state = SVPullToRefreshStateLoading;
    else if(contentOffset.y > scrollOffsetThreshold && contentOffset.y < -self.originalScrollViewContentInset.top && self.scrollView.isDragging && self.state != SVPullToRefreshStateLoading)
        self.state = SVPullToRefreshStateVisible;
    else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == SVPullToRefreshStateVisible)
        self.state = SVPullToRefreshStateTriggered;
    else if(contentOffset.y >= -self.originalScrollViewContentInset.top && self.state != SVPullToRefreshStateHidden)
        self.state = SVPullToRefreshStateHidden;
}

- (void)stopAnimating {
    self.state = SVPullToRefreshStateHidden;
}
- (void)spin
{
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.byValue = [NSNumber numberWithFloat:2*M_PI];
    spinAnimation.duration = 1.0f;
    spinAnimation.delegate = self;
    [self.arrow.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
}
- (void)setState:(SVPullToRefreshState)newState {
    state = newState;
    
    switch (newState) {
        case SVPullToRefreshStateHidden:
            self.titleLabel.text = NSLocalizedString(@"使劲...",);
            [self setScrollViewContentInset:self.originalScrollViewContentInset];
            break;
            
        case SVPullToRefreshStateVisible:
            self.titleLabel.text = NSLocalizedString(@"使劲...",);
            [self setScrollViewContentInset:self.originalScrollViewContentInset];
            break;
            
        case SVPullToRefreshStateTriggered:
            self.titleLabel.text = NSLocalizedString(@"放手,是一种态度.",);
            break;
            
        case SVPullToRefreshStateLoading:
            self.titleLabel.text = NSLocalizedString(@"放手,是一种态度.",);
            [self setScrollViewContentInset:UIEdgeInsetsMake(self.frame.origin.y*-1+self.originalScrollViewContentInset.top, 0, 0, 0)];
            [self spin];
            if(actionHandler)
                actionHandler();
            break;
    }
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
        self.arrow.layer.opacity = !hide;
    } completion:NULL];
}

@end


#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (SVPullToRefresh)

@dynamic pullToRefreshView;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    SVPullToRefresh *pullToRefreshView = [[[SVPullToRefresh alloc] initWithScrollView:self]autorelease];
    pullToRefreshView.actionHandler = actionHandler;
    self.pullToRefreshView = pullToRefreshView;
}

- (void)setPullToRefreshView:(SVPullToRefresh *)pullToRefreshView {
    [self willChangeValueForKey:@"pullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"pullToRefreshView"];
}

- (SVPullToRefresh *)pullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

@end
