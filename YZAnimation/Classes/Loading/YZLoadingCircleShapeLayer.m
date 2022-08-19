//
//  YZLoadingCircleShapeLayer.m
//  YZAnimation
//
//  Created by hyz on 2022/8/18.
//

#import "YZLoadingCircleShapeLayer.h"
#import "YZLoadingParams.h"

@implementation YZLoadingCircleShapeLayer

#pragma mark - Init

- (instancetype)initWithParams:(YZLoadingParams *)params {
    if (self = [super init]) {
        self.frame = CGRectMake(0.0f, 0.0f, params.strokeRadius, params.strokeRadius);
        // clearColor背景色
        self.backgroundColor = [UIColor clearColor].CGColor;
        // 形状轨迹
        self.path = [UIBezierPath bezierPathWithOvalInRect:self.frame].CGPath;
        // 轨迹起点值
        self.strokeStart = 0.0f;
        // 轨迹终点值
        self.strokeEnd = 1.0f;
        // 轨迹宽度
        self.lineWidth = params.lineWidth;
        // 圆形轨迹描边色
        self.strokeColor = (params.strokeColor ?: YZ_RGB_COLOR(255.0f, 102.0f, 102.0f)).CGColor;
        // 圆形填充色
        self.fillColor = [UIColor clearColor].CGColor;
        
        // 创建渐变层
        if (params.animType == YZLoadingAnimTypeCircleGradient) {
            [self createGradientShapeLayer:params];
        }
    }
    
    return self;
}

/// 创建渐变层作为ShapeLayer的mask
/// @warning 此方案有个缺点，当ShapeLayer的lineWidth足够大时，可以看到两个分渐变层的分割节点
/// @param params 动画参数
- (void)createGradientShapeLayer:(YZLoadingParams *)params {
    // 设置mask遮罩图层
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(-self.lineWidth / 2.0f, -self.lineWidth / 2.0f, self.bounds.size.width + self.lineWidth, self.bounds.size.height + self.lineWidth);
    self.mask = maskLayer;

    // 把ShapeLayer一分为二，创建两个两个渐变层，（上下 or 左右）方向都可以，注意startPoint & endPoint数值就行
    /// @warning 注意CAGradientLayer的colors，alpha必须为0～1，否则无法看到渐变效果
    /// alpha 为0时，maskLayer完全展示，ShapeLayer被遮挡，alpha 为1时，ShapeLayer完全展示
    CGSize size = maskLayer.frame.size;
    // 顶部maskLayer图层添加渐变图层
    CAGradientLayer *topGradientLayer = [CAGradientLayer layer];
    topGradientLayer.frame = CGRectMake(0.0f, 0.0f, size.width, size.height / 2.0f);
    topGradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    topGradientLayer.endPoint = CGPointMake(1.0f, 0.0f);
    topGradientLayer.colors = @[
        (__bridge id)[UIColor whiteColor].CGColor,
        (__bridge id)[UIColor colorWithWhite:1.0f alpha:0.5f].CGColor
    ];
    topGradientLayer.locations = @[@0, @1];

    // 底部maskLayer图层添加渐变图层
    CAGradientLayer *bottomGradientLayer = [CAGradientLayer layer];
    bottomGradientLayer.frame = CGRectMake(CGRectGetMinX(topGradientLayer.frame), CGRectGetMaxY(topGradientLayer.frame), size.width, size.height / 2.0f);
    bottomGradientLayer.startPoint = CGPointMake(1.0f, 1.0f);
    bottomGradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
    bottomGradientLayer.colors = @[
        (__bridge id)[UIColor colorWithWhite:1.0f alpha:0.5f].CGColor,
        (__bridge id)[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor
    ];
    bottomGradientLayer.locations = @[@0, @1];
    // 将渐变层添加到maskLayer中
    [maskLayer addSublayer:topGradientLayer];
    [maskLayer addSublayer:bottomGradientLayer];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    
    [self stopCircleStrokeAnimation];
}

#pragma mark - Public Methods

- (void)startShapeLayerStrokeEndAnimation:(CGFloat)animDuration {
    // 【从无到有】运动动画
    CABasicAnimation *strokeEndAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnim.fromValue = @0.0f;
    strokeEndAnim.toValue = @1.0f;
    strokeEndAnim.duration = animDuration;
    strokeEndAnim.removedOnCompletion = NO;
    strokeEndAnim.repeatCount = INFINITY;
    strokeEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    // 保存fromValue数值
    strokeEndAnim.fillMode = kCAFillModeForwards;
    // strokeEnd动画
    [self addAnimation:strokeEndAnim forKey:nil];
}

- (void)startShapeLayerStrokeAnimation:(CGFloat)animDuration withStrokeEndAnimDurationProportion:(CGFloat)proportion {
    // 【从无到有】运动动画
    CABasicAnimation *strokeEndAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnim.fromValue = @0.0f;
    strokeEndAnim.toValue = @1.0f;
    strokeEndAnim.duration = animDuration * proportion;
    
    // 【从有到无】运动动画
    CABasicAnimation *strokeStartAnim = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnim.fromValue = @0.0f;
    strokeStartAnim.toValue = @1.0f;
    // 设置strokeEnd后开始strokeStart的时间
    strokeStartAnim.beginTime = strokeEndAnim.duration;
    strokeStartAnim.duration = (animDuration - strokeEndAnim.duration);
    
    // 动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = animDuration;
    group.removedOnCompletion = NO;
    group.repeatCount = INFINITY;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    // 保存fromValue数值
    group.fillMode = kCAFillModeForwards;
    group.animations = @[strokeEndAnim, strokeStartAnim];
    [self addAnimation:group forKey:nil];
}

- (void)startGradientShapeLayerRotationAnimation:(CGFloat)animDuration {
    // 旋转动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = @(0.0f);
    animation.toValue = @(M_PI*2);
    animation.duration = animDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    animation.repeatCount = INFINITY;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    [self addAnimation:animation forKey:nil];
}

- (void)stopCircleStrokeAnimation {
    [self removeAllAnimations];
    [self removeFromSuperlayer];
}

#pragma mark - Private Methods

#pragma mark - Setter & Getter

#pragma mark - Lazy Loading

@end
