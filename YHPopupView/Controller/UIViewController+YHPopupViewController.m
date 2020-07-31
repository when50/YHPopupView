//
//  UIViewController+YYPopupViewController.m
//  YYPopupView
//
//  Created by dengyonghao on 15/9/8.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "UIViewController+YHPopupViewController.h"
#import <objc/runtime.h>
#import "YHPopupView.h"
#import "YHBackgroundView.h"

#define kYHPopupView @"kYHPopupView"
#define kYHOverlayView @"kYHOverlayView"
#define kYHPopupAnimation @"kYHPopupAnimation"
#define kYHOverlayBackgroundColor @"kYHOverlayBackgroundColor"
#define BackgoundViewTag 930527

@interface UIViewController ()

@property(nonatomic, retain) UIView *dn_popupView;
@property(nonatomic, retain) UIView *overlayView;
@property(nonatomic, retain) UIColor *overlayBackgroundColor;
@property(nonatomic, retain) id<YHPopupAnimation> popupAnimation;

@end

@implementation UIViewController (YYPopupViewController)


#pragma mark - inline property
- (UIView *)dn_popupView {
    return objc_getAssociatedObject(self, kYHPopupView);
}

- (void)setDn_popupView:(UIView *)popupView {
    objc_setAssociatedObject(self, kYHPopupView, popupView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)overlayView{
    return objc_getAssociatedObject(self, kYHOverlayView);
}

- (void)setOverlayView:(UIView *)overlayView {
    objc_setAssociatedObject(self, kYHOverlayView, overlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<YHPopupAnimation>)popupAnimation{
    return objc_getAssociatedObject(self, kYHPopupAnimation);
}

- (void)setPopupAnimation:(id<YHPopupAnimation>)popupAnimation{
    objc_setAssociatedObject(self, kYHPopupAnimation, popupAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)overlayBackgroundColor {
    return objc_getAssociatedObject(self, kYHOverlayBackgroundColor);
}

- (void)setOverlayBackgroundColor:(UIColor *)backgroundColor {
    objc_setAssociatedObject(self, kYHOverlayBackgroundColor, backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - public method
- (void)presentPopupView:(UIView *)popupView {
    [self p_presentPopupView:popupView];
}

- (void)presentPopupView:(UIView *)popupView animation:(id<YHPopupAnimation>)animation {
    self.popupAnimation = animation;
    [self p_presentPopupView:popupView];
    if (animation) {
        [animation showView:popupView overlayView:self.overlayView];
    }
}

- (void)dismissPopupView {
    [self.overlayView removeFromSuperview];
    [self.dn_popupView removeFromSuperview];
    self.overlayView = nil;
    self.dn_popupView = nil;
    self.popupAnimation = nil;
}

- (void)dismissPopupViewWithAnimation:(id<YHPopupAnimation>)animation {
    if (animation) {
        __weak __typeof(&*self)weakSelf = self;
        [animation dismissView:self.dn_popupView overlayView:self.overlayView completion:^(void) {
            [weakSelf dismissPopupView];
        }];
    }else{
        [self dismissPopupView];
    }
}

#pragma mark - private method
- (void)p_dismissPopupView{
    [self dismissPopupViewWithAnimation:self.popupAnimation];
}

- (void)p_presentPopupView:(UIView *)popupView {
    if ([self.overlayView.subviews containsObject:popupView]) {
        return;
    }
    self.dn_popupView = nil;
    self.dn_popupView = popupView;
    self.popupAnimation = nil;
    
    UIView *sourceView = [self topView];
    
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    
    if (!self.overlayView) {
        UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayView.backgroundColor = [UIColor clearColor];
        
        YHBackgroundView *backgroundView = [[YHBackgroundView alloc] initWithFrame:sourceView.bounds];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.backgroundColor = self.overlayBackgroundColor ?: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        backgroundView.tag = BackgoundViewTag;
        [overlayView addSubview:backgroundView];
        
        if ([popupView isKindOfClass:[YHPopupView class]]) {
            YHPopupView *pv = (YHPopupView *)popupView;
            if (pv.backgroundViewColor) {
                backgroundView.backgroundColor = pv.backgroundViewColor;
            }
            if (pv.clickBlankSpaceDismiss) {
                __weak typeof(self) wself = self;
                backgroundView.hitCallback = ^{
                    [wself p_dismissPopupView];
                };
            }
        }
        
        self.overlayView = overlayView;
    }
    [self.overlayView addSubview:popupView];
    [sourceView addSubview:self.overlayView];
    self.overlayView.alpha = 1.0f;
}

- (UIView *)topView {
    UIViewController *recentView = self;
    
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

@end
