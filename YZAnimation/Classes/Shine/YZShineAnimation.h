//
//  YZShineAnimation.h
//  YZAnimation
//
//  Created by hyz on 2022/8/10.
//

#import "YZAnimation.h"
#import "YZShineParams.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * @abstract 视图太阳光动画处理器
 *
 * @discussion 以MAX(layer.size.width, layer.size.height) / 2.0f为半径扩散
 *
 * @warning 请确保layer.superLayer不为空，否则无法正常展示动画效果
 *
 */
@interface YZShineAnimation : YZAnimation

/// 使用默认动画参数开启视图太阳光动画
/// @warning 动画会根据layer的size创建动画，添加动画前请先设置size
/// @param layer 需要显示动画的视图layer
+ (YZShineAnimation *)startShineAnimation:(CALayer *)layer;

/// 初始化动画视图层级
/// @warning 动画会根据layer的size创建动画，添加动画前请先设置size
/// @param layer layer 需要显示动画的视图layer
/// @param params 动画参数
- (instancetype)initWithAnimationViewLayer:(CALayer *)layer withShineParams:(nullable YZShineParams *)params;

@end

NS_ASSUME_NONNULL_END
