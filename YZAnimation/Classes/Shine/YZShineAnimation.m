//
//  YZShineAnimation.m
//  YZAnimation
//
//  Created by hyz on 2022/8/10.
//

#import "YZShineAnimation.h"
#import "YZShineLayer.h"

@interface YZShineAnimation ()

/// 展示shine动画的layer
@property (nonatomic, strong) YZShineLayer *shineLayer;

@end

@implementation YZShineAnimation

#pragma mark - Init

- (instancetype)initWithAnimationViewLayer:(CALayer *)layer withShineParams:(nullable YZShineParams *)params {
    if (self = [super init]) {
        // 动画参数为空时，创建默认参数数据
        if (params == nil) params = [[YZShineParams alloc] init];
        
        // 修正参数数值
        if (params.count < 2)  params.count = 8;
        if (params.distanceMultiple <= 0.0f) params.distanceMultiple = 2.0f;
        if (params.offsetDistance <= 0.0f) params.offsetDistance = 0.0f;
        
        // 添加shine动画视图层
        [self setupAnimationLayer:layer withShineParams:params];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - Public Methods

+ (YZShineAnimation *)startShineAnimation:(CALayer *)layer {
    YZShineAnimation *anmiation = [[YZShineAnimation alloc] initWithAnimationViewLayer:layer withShineParams:nil];
    [anmiation startShineAnimation];
    
    return anmiation;
}

+ (void)stopAllShineAnimation:(CALayer *)layer {
    if (layer == nil || layer.sublayers.count <= 0) return;
    
    // 移除子视图层中有关shine视图层
    NSMutableArray <YZShineLayer *> *arrM = [NSMutableArray arrayWithCapacity:layer.sublayers.count];
    for (CALayer *subLayer in layer.sublayers) {
        if ([subLayer isKindOfClass:[YZShineLayer class]] == YES) {
            [arrM addObject:((YZShineLayer *)subLayer)];
        }
    }
    // 停止shine视图层
    if (arrM.count > 0) {
        [arrM makeObjectsPerformSelector:@selector(stopAnimation)];
        [arrM removeAllObjects];
        arrM = nil;
    }
}

- (void)startShineAnimation {
    [self.shineLayer startAnimation];
}

- (void)stopShineAnimation:(CALayer *)layer {
    if (layer == nil) return;
    // 移除目标视图层动画
    [layer removeAllAnimations];
    
    if (layer.superlayer == nil) return;
    // 移除目标视图父视图层动画
    for (CALayer *subLayer in layer.superlayer.sublayers) {
        if ([subLayer isKindOfClass:[YZShineLayer class]] == YES) {
            YZShineLayer *shineLayer = (YZShineLayer *)subLayer;
            if (shineLayer.targetLayer == layer) { // 同一目标视图，停止太阳光动画
                [shineLayer stopAnimation];
                break;
            }
        }
    }
}

#pragma mark - Private Methods

/// 添加shine动画视图层
/// @param layer 需要显示动画的视图layer
/// @param params 动画参数
- (void)setupAnimationLayer:(CALayer *)layer withShineParams:(YZShineParams *)params {
    // 先停止显示层动画
    if (params.stopAnim == YES) {
        [self stopShineAnimation:layer];
    }
    
    // 所要显示动画的视图层不存在父级层，违背设计逻辑，无法处理
    if (layer.superlayer == nil) return;
    
    // 创建一个与layer frame相同的shine动画的layer
    self.shineLayer = [[YZShineLayer alloc] initWithShineParams:params];
    self.shineLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.shineLayer.masksToBounds = NO;
    // 设置动画视图层frame
    self.shineLayer.frame = CGRectMake(layer.frame.origin.x + params.centerOffset.x, layer.frame.origin.y + params.centerOffset.y, layer.bounds.size.width, layer.bounds.size.height);
    [layer.superlayer addSublayer:self.shineLayer];
    self.shineLayer.targetLayer = layer;
}

#pragma mark - Setter & Getter

#pragma mark - Lazy Loading

@end
