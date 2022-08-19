//
//  YZLoadingAnimation.m
//  YZAnimation
//
//  Created by hyz on 2022/8/17.
//

#import "YZLoadingAnimation.h"
#import "YZLoadingCircleShapeLayer.h"

@interface YZLoadingAnimation ()
/// 圆形加载形状层
@property (nonatomic, strong) YZLoadingCircleShapeLayer *shapeLayer;
/// 需要显示动画的目标视图layer
@property (nonatomic, weak) CALayer *targetLayer;

/// 加载动画参数
@property (nonatomic, strong) YZLoadingParams *params;
/// 动画是否正在运行
@property (nonatomic, assign, readwrite) BOOL running;

@end

@implementation YZLoadingAnimation

#pragma mark - Init

- (instancetype)initWithAnimationViewLayer:(CALayer *)layer withLoadingParams:(nullable YZLoadingParams *)params {
    if (self = [super init]) {
        _running = NO;
        _targetLayer = layer;
        
        // 动画参数为空时，创建默认参数数据
        if (params == nil) params = [[YZLoadingParams alloc] init];
        // 修正动画参数数值
        if (params.animDuration <= 0.0f) params.animDuration = 2.0f;
        
        _params = params;
        
        // 添加子视图
        [self setupSubLayer];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - Event Response

#pragma mark - Public Methods

+ (YZLoadingAnimation *)startLoadingAnimation:(CALayer *)layer {
    YZLoadingAnimation *anim = [[YZLoadingAnimation alloc] initWithAnimationViewLayer:layer withLoadingParams:nil];
    [anim startLoadingAnimation];
    
    return anim;
}

+ (void)stopAllLoadingAnimation:(CALayer *)layer {
    if (layer == nil || layer.sublayers.count <= 0) return;
    
    // 移除子视图层中有关加载视图层
    NSMutableArray <YZLoadingCircleShapeLayer *> *arrM = [NSMutableArray arrayWithCapacity:layer.sublayers.count];
    for (CALayer *subLayer in layer.sublayers) {
        if ([subLayer isKindOfClass:[YZLoadingCircleShapeLayer class]] == YES) {
            [arrM addObject:((YZLoadingCircleShapeLayer *)subLayer)];
        }
    }
    // 停止加载视图层
    if (arrM.count > 0) {
        [arrM makeObjectsPerformSelector:@selector(stopCircleStrokeAnimation)];
        [arrM removeAllObjects];
        arrM = nil;
    }
}

- (void)startLoadingAnimation {
    // 动画开始运行
    self.running = YES;
    
    switch (self.params.animType) {
        case YZLoadingAnimTypeCircleStroke: {
            [self.shapeLayer startShapeLayerStrokeAnimation:self.params.animDuration withStrokeEndAnimDurationProportion:self.params.strokeEndAnimDurationProportion];
        }
            break;
        case YZLoadingAnimTypeCircleGradient: {
            [self.shapeLayer startGradientShapeLayerRotationAnimation:self.params.animDuration];
        }
            break;
        default: {
            [self.shapeLayer startShapeLayerStrokeEndAnimation:self.params.animDuration];
        }
            break;
    }
}

- (void)stopLoadingAnimation {
    // 移除加载动画
    [self removeLoadingAnimation];
    // 移除加载形状视图层
    [self removeShapeLayer];
}

#pragma mark - Private Methods

/// 添加子视图
- (void)setupSubLayer {
    // 是否需要停止显示层加载动画
    if (self.params.stopAnim == YES) {
        [YZLoadingAnimation stopAllLoadingAnimation:self.targetLayer];
    }
    
    // 圆形加载形状视图层
    self.shapeLayer = [[YZLoadingCircleShapeLayer alloc] initWithParams:self.params];
    self.shapeLayer.frame = [self.params layerFrame:self.targetLayer.frame.size];
    // 添加到显示视图层
    [self.targetLayer addSublayer:self.shapeLayer];
}

/// 移除加载形状视图层
- (void)removeShapeLayer {
    if (_shapeLayer == nil) return;
    
    [_shapeLayer stopCircleStrokeAnimation];
    _shapeLayer = nil;
}

/// 移除加载动画
- (void)removeLoadingAnimation {
    // 动画运行结束
    self.running = NO;
    
    if (_shapeLayer == nil) return;

    [_shapeLayer removeAllAnimations];
}

#pragma mark - Setter & Getter

@end
