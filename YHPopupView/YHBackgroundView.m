//
//  YHBackgroundView.m
//  AFNetworking
//
//  Created by oneko on 2020/7/27.
//

#import "YHBackgroundView.h"

@interface YHBackgroundView() <UIGestureRecognizerDelegate>

@end

@implementation YHBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (self.hitCallback) {
        self.hitCallback();
    }
}

@end
