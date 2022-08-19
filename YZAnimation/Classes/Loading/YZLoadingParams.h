//
//  YZLoadingParams.h
//  YZAnimation
//
//  Created by hyz on 2022/8/17.
//

#import "YZAnimationParams.h"

NS_ASSUME_NONNULL_BEGIN

/// 加载动画类型
typedef NS_ENUM(NSInteger, YZLoadingAnimType) {
    /// stroke end 类型 加载动画圈
    YZLoadingAnimTypeCircleStrokeEnd = 1 << 0,
    /// stroke end to start 类型 加载动画
    YZLoadingAnimTypeCircleStroke = 1 << 1,
    /// 圈渐变旋转 加载动画
    YZLoadingAnimTypeCircleGradient = 1 << 2,
};

@interface YZLoadingParams : YZAnimationParams

/// 加载动画类型，默认YZLoadingAnimTypeCircleStrokeEnd
@property (nonatomic, assign) YZLoadingAnimType animType;
/// 加载视图圆形半径，默认44
@property (nonatomic, assign) CGFloat strokeRadius;
/// 加载视图圆形轨迹宽度，默认2.5
@property (nonatomic, assign) CGFloat lineWidth;
/// 圆形轨迹颜色值，默认为浅红色(255, 102, 102)
@property (nonatomic, strong) UIColor *strokeColor;
/// stroke end动画占用动画总时长的比例，默认为2/3
@property (nonatomic, assign) CGFloat strokeEndAnimDurationProportion;
/// 视图层坐标，默认为zero,使用显示层的中心点位置
@property (nonatomic, assign) CGPoint origin;

/// 动画视图层frame
/// @param superSize 显示动画视图的尺寸
- (CGRect)layerFrame:(CGSize)superSize;

@end

NS_ASSUME_NONNULL_END
