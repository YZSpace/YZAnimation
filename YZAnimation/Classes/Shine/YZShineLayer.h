//
//  YZShineLayer.h
//  YZAnimation
//
//  Created by hyz on 2022/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YZShineParams;

/**
 * 展示shine动画的layer
 */
@interface YZShineLayer : CALayer
/// 需要显示动画的目标视图layer
@property (nonatomic, weak) CALayer *targetLayer;

/// 初始化shine动画的layer
/// @param params 动画参数
- (instancetype)initWithShineParams:(YZShineParams *)params;

/// 开启视图动画
- (void)startShineAnimation;

/// 停止视图动画
- (void)stopShineAnimation;

@end

NS_ASSUME_NONNULL_END
