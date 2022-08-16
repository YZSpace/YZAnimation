//
//  YZShineAngleLayer.h
//  YZAnimation
//
//  Created by hyz on 2022/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YZShineParams;

/// 旋转动画执行完成回调
typedef void (^YZAngleAnimationFinishedBlock) (BOOL finished);

/**
 * 太阳光转角视图层
 */
@interface YZShineAngleLayer : CALayer

/// 初始化旋转视图层
/// @param frame 层frame
/// @param params 动画参数
- (instancetype)initWithFrame:(CGRect)frame withAnimationParams:(YZShineParams *)params;

/// 开启旋转动画
/// @param block 动画执行完成回调
- (void)startAngleAnimation:(YZAngleAnimationFinishedBlock)block;

@end

NS_ASSUME_NONNULL_END
