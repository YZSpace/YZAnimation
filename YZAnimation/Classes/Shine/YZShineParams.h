//
//  YZShineParams.h
//  YZAnimation
//
//  Created by hyz on 2022/8/10.
//

#import "YZAnimationParams.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 太阳光动画参数
 */
@interface YZShineParams : YZAnimationParams

/// 是否需要闪光效果（太阳光点颜色随机变化），默认为NO
@property (nonatomic, assign) BOOL enableFlashing;
/// 太阳光点（大点和小点）个数，默认为8；小于2时修正为8
@property (nonatomic, assign) NSInteger count;
/// 点的大小（大点*100%，小点*60%），默认为8
@property (nonatomic, assign) CGFloat size;
/// 扩散时的旋转角度，值越大，旋转越快，默认为20
@property (nonatomic, assign) CGFloat turnAngle;
/// 扩散时的范围倍数，默认为2
/// @warning 数值不可小于0，否则会被强制修正为2
@property (nonatomic, assign) CGFloat distanceMultiple;
/// 扩散时的旋转偏移角度，默认为20
@property (nonatomic, assign) CGFloat offsetAngle;
/// 动画效果距离显示视图中心点偏移坐标，默认为zore
@property (nonatomic, assign) CGPoint centerOffset;

/// 是否允许使用随机，默认为NO
@property (nonatomic, assign) BOOL allowRandomColor;
/// 大点的颜色，默认为浅红色(255, 102, 102)
@property (nonatomic, strong) UIColor *bigShineColor;
/// 小点的颜色，默认为浅灰色(255, 165, 0)
@property (nonatomic, strong) UIColor *smallShineColor;
/// 点随机颜色集合
@property (nonatomic, strong) NSArray <UIColor *> *colorRandomArr;

/// 圆形扩散形状layer填充颜色，默认为白色(whiteColor)
@property (nonatomic, strong) UIColor *fillColor;
/// 圆形扩散形状layer轨道颜色，默认为浅红色(255, 102, 102)
@property (nonatomic, strong) UIColor *strokeColor;
/// 圆形扩散形状layer轨道宽度，默认为1.5
@property (nonatomic, assign) CGFloat lineWidth;

/// 视图层是否有缩放动画效果，默认为YES
@property (nonatomic, assign) BOOL enableScaleAnim;
/// 缩放因子值，默认为[@0.5f, @1.0f, @0.8f, @1.0f]
@property (nonatomic, strong) NSArray <NSNumber *> *scaleValueArr;

/// 扩散时的旋转偏移角度对应的PI数值
- (CGFloat)offsetAngleMPIValue;

/// 视图层半径
- (CGFloat)layerRadiusSize:(CGSize)layerSize;

/// 太阳光大点尺寸
- (CGFloat)bigShineSize:(CGSize)layerSize;

/// 太阳光小点尺寸，大点尺寸*60%
- (CGFloat)smallShineSize:(CGSize)layerSize;

/// 扩散动画占动画总时长的15%
- (CGFloat)pathAnimationDuration;

/// 缩放动画占动画总时长的15%
- (CGFloat)scaleAnimationDuration;

/// 旋转动画占动画总时长的70%
- (CGFloat)angleAnimationDuration;

/// 尝试随机生成颜色
/// @warning 不支持随机功能时返回空
- (nullable UIColor *)randomColor;

@end

NS_ASSUME_NONNULL_END
