//
//  YZShineLayer.m
//  YZAnimation
//
//  Created by hyz on 2022/8/10.
//

#import "YZShineLayer.h"
#import "YZShineParams.h"
#import "YZShineAngleLayer.h"

/// 扩散动画key
static NSString * const kPathAnimationKeyPath = @"path";

@interface YZShineLayer () <CAAnimationDelegate>

/// 扩散形状层
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

/// 屏幕刷新
@property (nonatomic, strong) CADisplayLink *displayLink;
/// 动画参数
@property (nonatomic, strong) YZShineParams *params;

@end

@implementation YZShineLayer

#pragma mark - Init

- (instancetype)initWithShineParams:(YZShineParams *)params {
    if (self = [super init]) {
        _params = params;
        
        // 添加子视图层
        [self setupLayers];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - Event Response

/// 屏幕刷新处理方法
- (void)handleDisplayLink:(CADisplayLink *)displayLink {
    // 随机颜色
    UIColor *color = [self.params randomColor];
    // 无随机颜色数据
    if (color == nil) return;
    
    // 随机轨道颜色
    _shapeLayer.strokeColor = color.CGColor;
}

#pragma mark - Public Methods

- (void)startShineAnimation {
    // 扩散半径动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:kPathAnimationKeyPath];
    // 扩散动画时长
    animation.duration = [self.params pathAnimationDuration];
    // 视图层尺寸
    CGSize size = self.frame.size;
    // 扩散中心点
    CGPoint center = CGPointMake(size.width / 2.0f, size.height / 2.0f);
    // 从半径为2开始扩散
    UIBezierPath *fromPath = [UIBezierPath bezierPathWithArcCenter:center radius:2.0f startAngle:0.0f endAngle:M_PI*2.0f clockwise:NO];
    // 扩散范围的最大半径（扩散范围的80%）
    CGFloat toRadius = [self.params layerRadiusSize:size]*self.params.distanceMultiple*0.8f;
    UIBezierPath *toPath = [UIBezierPath bezierPathWithArcCenter:center radius:toRadius startAngle:0.0f endAngle:M_PI*2.0f clockwise:NO];
    animation.delegate = self;
    animation.values = @[(id)fromPath.CGPath, (id)toPath.CGPath];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    // 视图层添加扩散动画
    [self.shapeLayer addAnimation:animation forKey:@"path"];
    
    // 处理扩散轨道的闪烁动画
    if (self.params.enableFlashing == YES) {
        [self startFlash];
    }
}

- (void)stopShineAnimation {
    // 停止屏幕频率定时器
    [self stopDisplayLink];
    // 移除扩散视图层
    [self removeShapeLayer];
    // 移除太阳光动画视图层
    [self removeShineLayer];
}

#pragma mark - Private Methods

/// 添加子视图层
- (void)setupLayers {
    // 扩散视图层
    self.shapeLayer = [[CAShapeLayer alloc] init];
    self.shapeLayer.fillColor = ([self.params randomColor] ?: self.params.fillColor).CGColor;
    self.shapeLayer.strokeColor = ([self.params randomColor] ?: self.params.strokeColor).CGColor;
    self.shapeLayer.lineWidth = self.params.lineWidth;
    // 添加视图层
    [self addSublayer:self.shapeLayer];
}

/// 开启扩散层闪烁 刷新频率定时器
- (void)startFlash {
    // 停止屏幕频率定时器
    [self stopDisplayLink];
    
    // 无随机颜色数据时，不添加屏幕刷新处理
    if (_params.colorRandomArr == nil || _params.colorRandomArr.count <= 0) return;
    
    // 在mainRunLoop执行
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

/// 停止屏幕频率定时器
- (void)stopDisplayLink {
    if (_displayLink == nil) return;
    
    // 使定时器失效
    [_displayLink invalidate];
    _displayLink = nil;
}

/// 移除扩散视图层
- (void)removeShapeLayer {
    if (_shapeLayer == nil) return;
    
    [_shapeLayer removeAllAnimations];
    [_shapeLayer removeFromSuperlayer];
    _shapeLayer = nil;
}

/// 缩放动画
- (void)startScalAnimation {
    // 不展示缩放动画效果
    if (self.params.enableScaleAnim == NO) return;
        
    // 缩放动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    // 缩放动画时长
    animation.duration = [self.params scaleAnimationDuration];
    animation.values = self.params.scaleValueArr ?: @[@0.5f, @1.0f, @0.8f, @1.0f];;
    animation.calculationMode = kCAAnimationCubic;
    // 目标视图层添加缩放动画
    [self.targetLayer addAnimation:animation forKey:@"scale"];
}

/// 开启旋转动画
- (void)startAngleLayerAnimation {
    // 添加旋转视图层
    YZShineAngleLayer *angleLayer = [[YZShineAngleLayer alloc] initWithFrame:self.bounds withAnimationParams:self.params];
    [self addSublayer:angleLayer];
    // 开启旋转动画
    __weak typeof(self) weakSelf = self;
    [angleLayer startAngleAnimation:^(BOOL finished) {
        [weakSelf removeShineLayer];
    }];
}

/// 移除太阳光动画视图层
- (void)removeShineLayer {
    // 移除目标视图layer动画
    [self.targetLayer removeAllAnimations];
    self.targetLayer = nil;
    // 移除子视图层动画
    [self.sublayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    // 移除子视图层
    [self.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    // 移除shine层动画
    [self removeAllAnimations];
    // 移除shine层
    [self removeFromSuperlayer];
}

#pragma mark - CAAnimationDelegate

/// 扩散动画开始代理方法
- (void)animationDidStart:(CAAnimation *)anim {
    
}

/// 扩散动画结束代理方法
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // 是否是扩散动画
    BOOL pathAnim = NO;
    if ([anim isKindOfClass:[CAKeyframeAnimation class]] == YES) {
        pathAnim = [((CAKeyframeAnimation *)anim).keyPath isEqualToString:kPathAnimationKeyPath];
    }
    
    // 停止屏幕频率定时器
    [self stopDisplayLink];
    // 移除扩散视图层
    [self removeShapeLayer];
    
    // 非扩散动画，不处理后续动画
    if (pathAnim == NO) return;
    
    // 开启扩散动画后续动画
    if (flag == YES) {
        // 开启缩放动画
        [self startScalAnimation];
        // 开启旋转动画
        [self startAngleLayerAnimation];
    }
}

#pragma mark - Setter & Getter

- (CADisplayLink *)displayLink {
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
        if (@available(iOS 10.0, *)) {
            // 首选6秒钟刷新一次
            _displayLink.preferredFramesPerSecond = 6;
        } else {
            // 设置定时器周期
            _displayLink.frameInterval = 10;
        }
    }
    
    return _displayLink;
}

#pragma mark - Lazy Loading

@end
