//
//  YZAnimationParams.h
//  YZAnimation
//
//  Created by hyz on 2022/8/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// RGBA颜色配值
#define YZ_RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
/// RGB颜色配值
#define YZ_RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

@interface YZAnimationParams : NSObject

/// 整个动画过程时间，默认为2.0
@property (nonatomic, assign) CGFloat animDuration;

@end

NS_ASSUME_NONNULL_END
