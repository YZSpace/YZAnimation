//
//  YZAnimation.m
//  YZAnimation
//
//  Created by hyz on 2022/8/15.
//

#import "YZAnimation.h"
#import "YZShineAnimation.h"
#import "YZLoadingAnimation.h"

@implementation YZAnimation

#pragma mark - Public Methods

+ (void)stopAllAnimations:(CALayer *)layer {
    NSLog(@"即将停止和YZAnimation有关的动画效果");
    
    // 太阳光动画
    [YZShineAnimation stopAllShineAnimation:layer];
    // 加载动画
    [YZLoadingAnimation stopAllLoadingAnimation:layer];
    
    NSLog(@"已停止和YZAnimation有关的动画效果");
}

#pragma mark - Private Methods

#pragma mark - Setter & Getter

#pragma mark - Lazy Loading

@end
