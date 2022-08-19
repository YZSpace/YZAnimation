//
//  YZShineAngleLayer.m
//  YZAnimation
//
//  Created by hyz on 2022/8/10.
//

#import "YZShineAngleLayer.h"
#import "YZShineParams.h"

@interface YZShineAngleLayer ()<CAAnimationDelegate>

/// 动画参数
@property (nonatomic, strong) YZShineParams *params;
/// 太阳光大点层集合
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *shineLayers;
/// 太阳光小点层集合
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *smallShineLayers;

/// 屏幕刷新
@property (nonatomic, strong) CADisplayLink *displayLink;
/// 动画执行完成回调
@property (nonatomic, copy) YZAngleAnimationFinishedBlock finishedBlock;

@end

@implementation YZShineAngleLayer

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame withAnimationParams:(YZShineParams *)params {
    if (self = [super init]) {
        self.frame = frame;
        _params = params;
        
        // 添加旋转层子视图层
        [self setupAngleSubLayer];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - Event Response

/// 屏幕定时刷新处理方法
- (void)handleAngleDisplayLink:(CADisplayLink *)displayLink {
    if (_params.count <= 0) return;

    for (NSInteger i = 0; i < self.params.count; i++) {
        // 大点层视图
        if (self.shineLayers.count > i) {
            // 太阳光点随机颜色
            [self.shineLayers objectAtIndex:i].fillColor = [self.params randomColor].CGColor;
        }
        
        // 小点层视图
        if (self.smallShineLayers.count > i) {
            // 太阳光点随机颜色
            [self.smallShineLayers objectAtIndex:i].fillColor = [self.params randomColor].CGColor;
        }
    }
}

#pragma mark - Public Methods

- (void)startAngleAnimation:(YZAngleAnimationFinishedBlock)block {
    _finishedBlock = block;
    // 扩散半径
    CGFloat radius = [self.params layerRadiusSize:self.bounds.size] *self.params.distanceMultiple;
    CGFloat startAngle = 0.0f;
    CGFloat angle = M_PI*2/self.params.count + startAngle;
    // 奇数时修正开始角度
    if (self.params.count % 2 != 0) {
        startAngle = M_PI*2 - angle/self.params.count;
    }
    
    // 太阳点运动动画
    for (NSInteger i = 0; i < self.params.count; i++) {
        // ******** 太阳光大点视图层  ******** //
        if (self.shineLayers.count > i) {
            CAShapeLayer *bigShine = [self.shineLayers objectAtIndex:i];
            // 运动轨迹动画
            CABasicAnimation *bigAnim = [self angleAnimation:bigShine withAngle:(startAngle + angle*i) withRadius:radius];
            [bigShine addAnimation:bigAnim forKey:@"path"];
            // 闪烁效果
            if (self.params.enableFlashing == YES) {
                [bigShine addAnimation:[self flashAnimation] forKey:@"bigFlash"];
            }
        }
        
        // ******** 太阳光小点视图层  ******** //
        if (self.smallShineLayers.count > i) {
            CAShapeLayer *smallShine = [self.smallShineLayers objectAtIndex:i];
            // 运动轨迹动画
            CABasicAnimation *smallAnim = [self angleAnimation:smallShine withAngle:(startAngle + angle*i - [self.params offsetAngleMPIValue]) withRadius:(radius - [self.params smallShineSize:self.bounds.size] - self.params.offsetDistance)];
            [smallShine addAnimation:smallAnim forKey:@"path"];
            // 闪烁效果
            if (self.params.enableFlashing == YES) {
                [smallShine addAnimation:[self flashAnimation] forKey:@"smallFlash"];
            }
        }
    }
    
    // angle layer 旋转动画
    CABasicAnimation *angleAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    angleAnim.duration = [self.params angleAnimationDuration];
    angleAnim.fromValue = @0.0f;
    angleAnim.toValue = @((self.params.turnAngle / 180.0f) * M_PI);
    angleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    angleAnim.delegate = self;
    [self addAnimation:angleAnim forKey:@"rotation"];
    // 闪烁效果动画
    if (self.params.enableFlashing == YES) {
        [self startAngleFlash];
    }
}

#pragma mark - Private Methods

/// 添加旋转层子视图层
- (void)setupAngleSubLayer {
    CGFloat radius = [self.params layerRadiusSize:self.bounds.size] *self.params.distanceMultiple;
    CGFloat startAngle = 0.0f;
    CGFloat angle = M_PI*2 / self.params.count + startAngle;
    if (self.params.count % 2 != 0) { // 奇数时修正开始角度
        startAngle = M_PI*2 - angle/self.params.count;
    }
    
    // 创建太阳点视图层
    for (NSInteger i = 0; i < self.params.count; i++) {
        // ******* 大点视图层 ******* //
        // 大点尺寸
        CGFloat bigShineSize = [self.params bigShineSize:self.bounds.size];
        // 扩散区域大点的中心位置
        CGPoint center = [self shineCenterPoint:(startAngle + angle*i) withRadius:radius];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:bigShineSize startAngle:0 endAngle:M_PI*2 clockwise:NO];
        CAShapeLayer *bigShine = [[CAShapeLayer alloc] init];
        bigShine.path = path.CGPath;
        bigShine.fillColor = ([self.params randomColor] ?: self.params.bigShineColor).CGColor;
        [self addSublayer:bigShine];
        [self.shineLayers addObject:bigShine];
        
        // ******* 小点视图层 ******* //
        CGFloat smallShineSize = [self.params smallShineSize:self.bounds.size];
        CGPoint smallCenter = [self shineCenterPoint:(startAngle + angle*i - [self.params offsetAngleMPIValue]) withRadius:(radius - bigShineSize - self.params.offsetDistance)];
        UIBezierPath *smallPath = [UIBezierPath bezierPathWithArcCenter:smallCenter radius:smallShineSize startAngle:0 endAngle:M_PI*2 clockwise:NO];
        CAShapeLayer *smallShine = [[CAShapeLayer alloc] init];
        smallShine.path = smallPath.CGPath;
        smallShine.fillColor = ([self.params randomColor] ?: self.params.smallShineColor).CGColor;
        [self addSublayer:smallShine];
        [self.smallShineLayers addObject:smallShine];
    }
}

/// 计算太阳光点的中心位置
/// @param angle 开始角度
/// @param radius 扩散圈半径
- (CGPoint)shineCenterPoint:(CGFloat)angle withRadius:(CGFloat)radius {
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);
    
    NSInteger multiple = 1; // 几个pi/2值
    if (angle >= 0 && angle <= M_PI_2) { // pi/2
        multiple = 1;
    } else if (angle > M_PI_2 && angle <= M_PI) { // pi
        multiple = 2;
    } else if (angle > M_PI && angle <= M_PI*3.0f/2.0f) { // pi *1.5
        multiple = 3;
    } else {
        multiple = 4;
    }
    
    CGFloat resultAngel = multiple*M_PI_2 - angle;
    // 一锐角∠A的对边与斜边的比叫做∠A的正弦，记作sinA，即sinA=∠A的对边/斜边。
    CGFloat sinValue = sin(resultAngel)*radius;
    // 角A的邻边比斜边叫做∠A的余弦，记作cosA，即cosA =x/r。
    CGFloat cosValue = cos(resultAngel)*radius;
    
    // pi/2 < && < pi
    if (multiple == 2) return CGPointMake(centerX + sinValue, centerY + cosValue);
    
    // pi < && < pi*1.5
    if (multiple == 3) return CGPointMake(centerX - cosValue, centerY + sinValue);
    
    // pi*1.5 <
    if (multiple == 4) return CGPointMake(centerX - sinValue, centerY - cosValue);
    
    // 0 < && < pi/2
    return CGPointMake(centerX + cosValue, centerY - sinValue);
}

/// 运动轨迹动画
/// @param layer 太阳光点视图层
/// @param angle 开始角度
/// @param radius 扩散圈半径
- (CABasicAnimation *)angleAnimation:(CAShapeLayer *)layer withAngle:(CGFloat)angle withRadius:(CGFloat)radius {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = [self.params angleAnimationDuration];
    animation.fromValue = (id)layer.path;
    
    CGPoint center = [self shineCenterPoint:angle withRadius:radius];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:0.1f startAngle:0 endAngle:M_PI*2 clockwise:NO];
    animation.toValue = (id)path.CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

/// 闪烁效果动画
- (CABasicAnimation *)flashAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @1.0f;
    animation.toValue = @0.0f;
    animation.duration = (arc4random() % 20 + 60) / 1000.0f;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.autoreverses = YES;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

/// 移除旋转子视图层
- (void)removeAngleSubLayer {
    // 移除大点视图层动画
    [self.shineLayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    [self.shineLayers removeAllObjects];
    
    // 移除小点视图层动画
    [self.smallShineLayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    [self.smallShineLayers removeAllObjects];
    
    // 移除子视图层
    [self.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

/// 开启旋转层闪烁动画效果
- (void)startAngleFlash {
    [self stopAngleDisplayLink];
    // 在mainRunLoop执行
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

/// 停止旋转屏幕刷新定时器
- (void)stopAngleDisplayLink {
    if (_displayLink == nil) return;
    
    [_displayLink invalidate];
    _displayLink = nil;
}

#pragma mark - CAAnimationDelegate

/// 旋转视图层动画开始代理方法
- (void)animationDidStart:(CAAnimation *)anim {
    
}

/// 旋转视图层动画停止代理方法
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self stopAngleDisplayLink];
    [self removeAngleSubLayer];
    
    if (_finishedBlock != nil) {
        _finishedBlock(flag);
    }
}

#pragma mark - Setter & Getter

- (CADisplayLink *)displayLink {
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleAngleDisplayLink:)];
        if (@available(iOS 10.0, *)) {
            // 首选10秒钟刷新一次
            _displayLink.preferredFramesPerSecond = 10;
        } else {
            // 设置定时器周期
            _displayLink.frameInterval = 6;
        }
    }
    
    return _displayLink;
}

- (NSMutableArray <CAShapeLayer *> *)shineLayers {
    if (_shineLayers == nil) {
        _shineLayers = [NSMutableArray arrayWithCapacity:MAX(_params.count, 3)];
    }
    
    return _shineLayers;
}

- (NSMutableArray <CAShapeLayer *> *)smallShineLayers {
    if (_smallShineLayers == nil) {
        _smallShineLayers = [NSMutableArray arrayWithCapacity:MAX(_params.count, 3)];
    }
    
    return _smallShineLayers;
}

#pragma mark - Lazy Loading

@end
