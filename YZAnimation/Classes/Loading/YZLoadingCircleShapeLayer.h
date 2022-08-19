//
//  YZLoadingCircleShapeLayer.h
//  YZAnimation
//
//  Created by hyz on 2022/8/18.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@class YZLoadingParams;

@interface YZLoadingCircleShapeLayer : CAShapeLayer

/// 初始化圆形ShapeLayer形状层
/// @param params 加载动画参数
- (instancetype)initWithParams:(YZLoadingParams *)params;

/// YZLoadingAnimTypeCircleStrokeEnd 类型下的动画
/// @param animDuration 动画时长
- (void)startShapeLayerStrokeEndAnimation:(CGFloat)animDuration;

/// YZLoadingAnimTypeCircleStroke 类型下的动画
/// @param animDuration 动画时长
/// @param proportion StrokeEnd占用动画总时长的比例
- (void)startShapeLayerStrokeAnimation:(CGFloat)animDuration withStrokeEndAnimDurationProportion:(CGFloat)proportion;

/// YZLoadingAnimTypeCircleGradient 类型下的动画
/// @param animDuration 动画时长
- (void)startGradientShapeLayerRotationAnimation:(CGFloat)animDuration;

/// 停止圆形stroke动画
- (void)stopCircleStrokeAnimation;

@end

NS_ASSUME_NONNULL_END
