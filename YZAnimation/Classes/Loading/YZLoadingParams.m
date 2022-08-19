//
//  YZLoadingParams.m
//  YZAnimation
//
//  Created by hyz on 2022/8/17.
//

#import "YZLoadingParams.h"

@implementation YZLoadingParams

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        // 默认不停止显示层动画效果
        self.stopAnim = NO;
        _animType = YZLoadingAnimTypeCircleStrokeEnd;
        _strokeRadius = 44.0f;
        _lineWidth = 2.5f;
        _strokeColor = YZ_RGB_COLOR(255.0f, 102.0f, 102.0f);
        _strokeEndAnimDurationProportion = 2.0f / 3.0f;
        _origin = CGPointZero;
    }
    
    return self;
}

#pragma mark - Public Methods

- (CGRect)layerFrame:(CGSize)superSize {
    // 宽度
    CGFloat width = self.strokeRadius;
    // 坐标点不是zero时
    if (CGPointEqualToPoint(self.origin, CGPointZero) == NO) {
        return CGRectMake(self.origin.x, self.origin.y, width, width);
    }
    
    return CGRectMake((superSize.width - width) / 2.0f, (superSize.height - width) / 2.0f, width, width);
}

#pragma mark - Private Methods

#pragma mark - Setter & Getter

@end
