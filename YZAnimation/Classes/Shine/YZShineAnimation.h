//
//  YZShineAnimation.h
//  YZAnimation
//
//  Created by hyz on 2022/8/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "YZShineParams.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * @abstract 视图太阳光动画处理器
 *
 * @discussion 以MAX(layer.size.width, layer.size.height) / 2.0f为半径扩散
 *
 * @warning 动画将添加到视图的父层中，请确保layer.superLayer不为空且注意视图size，否则无法正常展示动画效果
 *
 */
@interface YZShineAnimation : NSObject

/// 使用默认动画参数开启视图太阳光动画
/// @warning 动画会根据layer的size创建动画，添加动画前请先设置size
/// @param layer 需要显示动画的视图layer
+ (YZShineAnimation *)startShineAnimation:(CALayer *)layer;

/// 停止某个视图层中的太阳光动画
/// @warning 请注意这里的layer是【添加动画视图的父层】（layer.superLayer）
/// @param layer 某个触发动画的父视图层
+ (void)stopAllShineAnimation:(CALayer *)layer;

/// 初始化动画视图层级
/// @warning 动画会根据layer的size创建动画，添加动画前请先设置size
/// @param layer layer 需要显示动画的视图layer
/// @param params 动画参数
- (instancetype)initWithAnimationViewLayer:(CALayer *)layer withShineParams:(nullable YZShineParams *)params;

/// 开启视图动画
- (void)startShineAnimation;

/// 停止视图动画
/// @param layer 需要停止的视图层
- (void)stopShineAnimation:(CALayer *)layer;

@end

NS_ASSUME_NONNULL_END
