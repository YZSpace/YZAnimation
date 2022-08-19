//
//  YZShineParams.m
//  YZAnimation
//
//  Created by hyz on 2022/8/10.
//

#import "YZShineParams.h"

@implementation YZShineParams

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        _enableFlashing = NO;
        _count = 8;
        _bigRadius = 8.0f;
        _smallRadius = 0.0f;
        _turnAngle = 20.0f;
        _distanceMultiple = 2.0f;
        _offsetAngle = 20.0f;
        _offsetDistance = 0.0f;
        _centerOffset = CGPointZero;
        
        _allowRandomColor = NO;
        _bigShineColor = YZ_RGB_COLOR(255.0f, 102.0f, 102.0f);
        _smallShineColor = YZ_RGB_COLOR(255.0f, 165.0f, 0.0f);
        
        _fillColor = [UIColor whiteColor];
        _strokeColor = YZ_RGB_COLOR(255.0f, 102.0f, 102.0f);
        _lineWidth = 1.5f;
     
        _enableScaleAnim = YES;
        _scaleValueArr = @[@0.5f, @1.0f, @0.8f, @1.0f];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    // 清空数组
    _colorRandomArr = nil;
    _scaleValueArr = nil;
}

#pragma mark - Public Methods

- (CGFloat)offsetAngleMPIValue {
    return (self.offsetAngle / 180.0f)*M_PI;
}

- (CGFloat)layerRadiusSize:(CGSize)layerSize {
    return MAX(layerSize.width, layerSize.height) / 2.0f;
}

- (CGFloat)bigShineSize:(CGSize)layerSize {
    if (self.bigRadius > 0.0f) return self.bigRadius;
    
    CGFloat maxSize = MAX(layerSize.width, layerSize.height);
    return maxSize * 0.15f;
}

- (CGFloat)smallShineSize:(CGSize)layerSize {
    if (self.smallRadius > 0.0f) return self.smallRadius;
    
    CGFloat bigSize = [self bigShineSize:layerSize];
    return bigSize * 0.6f;
}

- (CGFloat)pathAnimationDuration {
    return self.animDuration * 0.15f;
}

- (CGFloat)scaleAnimationDuration {
    return self.animDuration * 0.15f;
}

- (CGFloat)angleAnimationDuration {
    return self.animDuration * 0.7f;
}

- (nullable UIColor *)randomColor {
    // 不支持随机颜色
    if (self.allowRandomColor == NO) return nil;
    
    // 随机颜色数组为空时，使用arc4random_uniform随机颜色
    if (self.colorRandomArr == nil || self.colorRandomArr.count <= 0) {
        return YZ_RGB_COLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    }
    
    // 随机颜色
    NSInteger index = arc4random() % self.colorRandomArr.count;
    return [self.colorRandomArr objectAtIndex:index];
}
    
#pragma mark - Private Methods

#pragma mark - Setter & Getter

@end
