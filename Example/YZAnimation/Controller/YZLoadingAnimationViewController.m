//
//  YZLoadingAnimationViewController.m
//  YZAnimation
//
//  Created by hyz on 2022/8/17.
//  Copyright © 2022 zone1026. All rights reserved.
//

#import "YZLoadingAnimationViewController.h"
#import "YZLoadingAnimation.h"
#import "YZAnimation.h"

@interface YZLoadingAnimationViewController ()

@end

@implementation YZLoadingAnimationViewController

#pragma mark - Init

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    
    self.navigationItem.title = @"Loading Animation";
    self.view.backgroundColor = [UIColor whiteColor];
    // 添加加载动画
    [self addLoadingAnimation];
    
    // 5秒后停止所用YZAnimation下的动画效果
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [YZAnimation stopAllAnimations:self.view.layer];
//    });
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Public Methods

#pragma mark - Private Methods

/// 添加加载动画
- (void)addLoadingAnimation {
    // ****** StrokeEnd Animation ****** //
    UILabel *strokeEndTitleLbl = [self createTitleLabel:@"StrokeEnd Animation:" withFrame:CGRectMake(15.0f, [UIApplication sharedApplication].statusBarFrame.size.height + 44.0f + 64.0f, 150.0f, 22.0f)];
    [self.view addSubview:strokeEndTitleLbl];
    
    YZLoadingParams *params = [[YZLoadingParams alloc] init];
    params.animDuration = 1.0f;
    params.strokeRadius = 64.0f;
    params.origin = CGPointMake(CGRectGetMaxX(strokeEndTitleLbl.frame) + 15.0f, CGRectGetMidY(strokeEndTitleLbl.frame) - params.strokeRadius / 2.0f);
    YZLoadingAnimation *strokeEndAnim = [[YZLoadingAnimation alloc] initWithAnimationViewLayer:self.view.layer withLoadingParams:params];
    [strokeEndAnim startLoadingAnimation];
    
    // ****** Stroke End to Start Animation ****** //
    
    UILabel *strokeTitleLbl = [self createTitleLabel:@"Stroke End to Start Animation:" withFrame:CGRectMake(CGRectGetMinX(strokeEndTitleLbl.frame), CGRectGetMaxY(strokeEndTitleLbl.frame) + 64.0f, 210.0f, 22.0f)];
    [self.view addSubview:strokeTitleLbl];
    
    params = [[YZLoadingParams alloc] init];
    params.animType = YZLoadingAnimTypeCircleStroke;
    params.strokeColor = [UIColor orangeColor];
    params.origin = CGPointMake(CGRectGetMaxX(strokeTitleLbl.frame) + 15.0f, CGRectGetMidY(strokeTitleLbl.frame) - params.strokeRadius / 2.0f);
    YZLoadingAnimation *strokeAnim = [[YZLoadingAnimation alloc] initWithAnimationViewLayer:self.view.layer withLoadingParams:params];
    [strokeAnim startLoadingAnimation];
    
    // ****** Stroke End to Start Animation ****** //
    
    UILabel *gradientStrokeTitleLbl = [self createTitleLabel:@"Gradient Stroke Animation:" withFrame:CGRectMake(CGRectGetMinX(strokeTitleLbl.frame), CGRectGetMaxY(strokeTitleLbl.frame) + 64.0f, 190.0f, 22.0f)];
    [self.view addSubview:gradientStrokeTitleLbl];
    
    params = [[YZLoadingParams alloc] init];
    params.animType = YZLoadingAnimTypeCircleGradient;
    params.strokeRadius = 26.0f;
    params.strokeColor = YZ_RGB_COLOR(230.0f, 0.0f, 18.0f);
    params.origin = CGPointMake(CGRectGetMaxX(gradientStrokeTitleLbl.frame) + 15.0f, CGRectGetMidY(gradientStrokeTitleLbl.frame) - params.strokeRadius / 2.0f);
    params.animDuration = 1.5f;
    YZLoadingAnimation *gradientStrokeAnim = [[YZLoadingAnimation alloc] initWithAnimationViewLayer:self.view.layer withLoadingParams:params];
    [gradientStrokeAnim startLoadingAnimation];
}

- (UILabel *)createTitleLabel:(NSString *)title withFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.userInteractionEnabled = NO;
    label.clipsToBounds = NO;
    label.text = title;
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    return label;
}

#pragma mark - Setter & Getter

#pragma mark - Lazy Loading

@end
