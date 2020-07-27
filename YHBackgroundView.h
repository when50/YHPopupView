//
//  YHBackgroundView.h
//  AFNetworking
//
//  Created by oneko on 2020/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHBackgroundView : UIView
@property (nonatomic, copy, nullable) void (^hitCallback)(void);
@end

NS_ASSUME_NONNULL_END
