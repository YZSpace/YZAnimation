//
//  YZShineAnimationViewController.m
//  YZAnimation
//
//  Created by hyz on 2022/8/15.
//  Copyright © 2022 zone1026. All rights reserved.
//

#import "YZShineAnimationViewController.h"
#import "YZShineAnimation.h"

@interface YZShineAnimationViewController ()

@property (nonatomic, strong) UIView *shineView;

@property (nonatomic, strong) UIButton *shineBtn;

@property (nonatomic, strong) UILabel *shineLbl;

@property (nonatomic, strong) UIImageView *shineImgView;

@end

@implementation YZShineAnimationViewController

#pragma mark - Init

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    
    self.navigationItem.title = @"Shine Animation";
    self.view.backgroundColor = [UIColor whiteColor];
    // 添加子视图
    [self setupSubViews];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Event Response

- (void)shineViewSingleTap:(UIGestureRecognizer *)sender {
    YZShineParams *param = [[YZShineParams alloc] init];
    param.allowRandomColor = YES;
    param.enableFlashing = YES;
    param.animDuration = 4.0f;
    YZShineAnimation *animation = [[YZShineAnimation alloc] initWithAnimationViewLayer:sender.view.layer withShineParams:param];
    [animation startAnimation];
}

- (void)shineBtnDidClick:(UIButton *)sender {
    [YZShineAnimation startShineAnimation:sender.layer];
}

- (void)shineLblDoubleTap:(UIGestureRecognizer *)sender {
    YZShineParams *param = [[YZShineParams alloc] init];
    param.bigShineColor = [UIColor redColor];
    param.fillColor = [UIColor whiteColor];
    param.strokeColor = [UIColor greenColor];
    param.animDuration = 2.0f;
    param.distanceMultiple = 0.25f;
    param.enableScaleAnim = NO;
    param.lineWidth = 0.5f;
    // 设定动画中心偏移量
    CGPoint touchPoint = [sender locationInView:sender.view];
    param.centerOffset = CGPointMake(touchPoint.x - sender.view.bounds.size.width / 2.0f, touchPoint.y - sender.view.bounds.size.height / 2.0f);
    
    YZShineAnimation *animation = [[YZShineAnimation alloc] initWithAnimationViewLayer:sender.view.layer withShineParams:param];
    [animation startAnimation];
}

- (void)shineImgViewSingleTap:(UIGestureRecognizer *)sender {
    YZShineParams *param = [[YZShineParams alloc] init];
//    param.bigShineColor = [UIColor redColor];
//    param.fillColor = [UIColor cyanColor];
//    param.strokeColor = [UIColor greenColor];
    param.animDuration = 5.0f;
    param.lineWidth = 8.0f;
    param.count = 15;
    param.size = 0.0f;
    param.offsetAngle = 85.0f;
    param.distanceMultiple = 3.0f;
    param.allowRandomColor = YES;
    
    YZShineAnimation *animation = [[YZShineAnimation alloc] initWithAnimationViewLayer:sender.view.layer withShineParams:param];
    [animation startAnimation];
}

#pragma mark - Public Methods

#pragma mark - Private Methods

/// 添加子视图
- (void)setupSubViews {
    UILabel *tipsLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    tipsLbl.text = @"点击下列 UIView or UIButton or UILabel or UIImageView 开启动画效果";
    tipsLbl.font = [UIFont systemFontOfSize:15.0f];
    tipsLbl.textColor = [UIColor blackColor];
    tipsLbl.numberOfLines = 0;
    tipsLbl.textAlignment = NSTextAlignmentCenter;
    tipsLbl.frame = CGRectMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height + 44.0f + 15.0f, [UIScreen mainScreen].bounds.size.width, 44.0f);
    [self.view addSubview:tipsLbl];
    
    [self.view addSubview:self.shineView];
    [self.view addSubview:self.shineBtn];
    [self.view addSubview:self.shineLbl];
    [self.view addSubview:self.shineImgView];
    
    self.shineView.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - 64.0f/2.0f, CGRectGetMaxY(tipsLbl.frame) + 64.0f, 64.0f, 44.0f);
    self.shineBtn.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - 44.0f/2.0f, CGRectGetMaxY(self.shineView.frame) + 64.0f, 44.0f, 44.0f);
    self.shineLbl.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - 260.0f/2.0f, CGRectGetMaxY(self.shineBtn.frame) + 64.0f, 260.0f, 30.0f);
    self.shineImgView.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - 60.0f/2.0f, CGRectGetMaxY(self.shineLbl.frame) + 64.0f, 60.0f, 60.0f);
}

#pragma mark - Setter & Getter

#pragma mark - Lazy Loading

- (UIView *)shineView {
    if (_shineView == nil) {
        _shineView = [[UIView alloc] initWithFrame:CGRectZero];
        _shineView.backgroundColor = [UIColor redColor];
        _shineView.userInteractionEnabled = YES;
        
        _shineView.layer.masksToBounds = YES;
        _shineView.layer.cornerRadius = 4.0f;
        
        UITapGestureRecognizer *singleTapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shineViewSingleTap:)];
        singleTapGest.numberOfTapsRequired = 1;
        [_shineView addGestureRecognizer:singleTapGest];
    }
    
    return _shineView;
}

- (UIButton *)shineBtn {
    if (_shineBtn == nil) {
        _shineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shineBtn.backgroundColor = [UIColor orangeColor];
        if (@available(iOS 13.0, *)) {
            UIImage *imgBtn = [UIImage systemImageNamed:@"camera.macro" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:22.0f weight:UIImageSymbolWeightSemibold scale:UIImageSymbolScaleDefault]];
            [_shineBtn setImage:imgBtn forState:UIControlStateNormal];
            _shineBtn.tintColor = [UIColor whiteColor];
        }
        
        [_shineBtn addTarget:self action:@selector(shineBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shineBtn;
}

- (UILabel *)shineLbl {
    if (_shineLbl == nil) {
        _shineLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _shineLbl.backgroundColor = [UIColor orangeColor];
        _shineLbl.userInteractionEnabled = YES;
        _shineLbl.clipsToBounds = YES;
        _shineLbl.text = @"双击开启动画效果";
        _shineLbl.font = [UIFont systemFontOfSize:15.0f];
        _shineLbl.textColor = [UIColor blackColor];
        _shineLbl.numberOfLines = 1;
        _shineLbl.textAlignment = NSTextAlignmentCenter;
        _shineLbl.lineBreakMode = NSLineBreakByTruncatingTail;
        
        UITapGestureRecognizer *doubleTapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shineLblDoubleTap:)];
        doubleTapGest.numberOfTapsRequired = 2;
        [_shineLbl addGestureRecognizer:doubleTapGest];
    }
    
    return _shineLbl;
}

- (UIImageView *)shineImgView {
    if (_shineImgView == nil) {
        _shineImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _shineImgView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
        _shineImgView.userInteractionEnabled = YES;
        _shineImgView.contentMode = UIViewContentModeScaleToFill;
        _shineImgView.clipsToBounds = NO;
        if (@available(iOS 13.0, *)) {
            UIImage *image = [UIImage systemImageNamed:@"gamecontroller.fill" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:32.0f weight:UIImageSymbolWeightThin scale:UIImageSymbolScaleDefault]];
            _shineImgView.image = image;
        }
        
        UITapGestureRecognizer *singleTapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shineImgViewSingleTap:)];
        singleTapGest.numberOfTapsRequired = 1;
        [_shineImgView addGestureRecognizer:singleTapGest];
    }
    
    return _shineImgView;
}

@end
