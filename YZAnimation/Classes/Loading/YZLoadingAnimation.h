//
//  YZLoadingAnimation.h
//  YZAnimation
//
//  Created by hyz on 2022/8/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "YZLoadingParams.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * @abstract 加载视图动画处理器
 *
 * @discussion 根据params.animType展示不同类型的加载方式
 *
 */
@interface YZLoadingAnimation : NSObject

/// 动画是否正在运行
@property (nonatomic, assign, readonly) BOOL running;

/// 使用默认动画参数开启视图加载动画
/// @param layer 需要显示动画的视图layer
+ (YZLoadingAnimation *)startLoadingAnimation:(CALayer *)layer;

/// 停止某个视图层中的加载层
/// @param layer 某个视图层
+ (void)stopAllLoadingAnimation:(CALayer *)layer;

/// 初始化动画视图层级
/// @warning 动画会根据layer的size创建动画，添加动画前请先设置size
/// @param layer layer 需要显示动画的视图layer
/// @param params 动画参数
- (instancetype)initWithAnimationViewLayer:(CALayer *)layer withLoadingParams:(nullable YZLoadingParams *)params;

/// 开启加载动画
- (void)startLoadingAnimation;

/// 停止加载动画
- (void)stopLoadingAnimation;

@end

NS_ASSUME_NONNULL_END
