//
//  DONG_LaunchAdView.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/2.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "DONG_LaunchAdView.h"

AdLaunchType state = AdLaunchProgressType;
static NSString *const adImageUrl = @"adImageUrl";
static int const showtime = 3; // 广告显示的时间

@interface DONG_LaunchAdView ()

/** 广告背景 */
@property (nonatomic, strong) UIView *adBackground;
/** 广告图片 */
@property (nonatomic, strong) UIImageView *adImageView;
/** 图片URL */
@property (nonatomic, strong) NSString *imageURL;
/** 跳过按钮 */
@property (nonatomic, strong) UIButton *skipBtn;
/** 前一张图片 */
@property (nonatomic, strong) UIImage *lastPreviousCachedImage;

@property (nonatomic, strong) NSTimer *countDownTimer;
/** 点击标识 */
@property (strong, nonatomic) NSString *clickId;

@end

@implementation DONG_LaunchAdView

#pragma mark - override

- (instancetype) initWithFrame:(CGRect)frame
{
    return self;
}

- (instancetype) initWithFrame: (CGRect)frame type: (AdLaunchType) type
{
    
    state = type;
    self = [super initWithFrame: frame];
    
    
    dispatch_time_t show = dispatch_time(DISPATCH_TIME_NOW, showtime * NSEC_PER_SEC);
    dispatch_after(show, dispatch_get_main_queue(), ^(void){
        [self removeAdvertView];
    });
    
    return self;
}

#pragma mark - 获取广告类型

- (void (^)(AdType adType))getLBlaunchImageAdViewType
{
    __weak typeof(self) weakSelf = self;
    return ^(AdType adType){
        [weakSelf addLaunchImageAdView:adType];
    };
}

- (void)addLaunchImageAdView:(AdType)adType
{
    _adTime = 6;
    [self addSubview: self.adBackground]; // 背景
    [self displayCachedAd:adType]; // 显示广告图片
    [self requestAdvertisementData]; // 获取广告图片
    [self addSkipButton]; // 跳过按钮
}

#pragma mark - 获取本地图片缓存，如果没有广告结束

- (void) displayCachedAd:(AdType)adType
{
    NSString *imageKey = [DONG_UserDefaults valueForKey:adImageUrl];
    DONG_Log(@"imageKeyimageKey-->%@", imageKey);
    _lastPreviousCachedImage = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:imageKey];
    if (!_lastPreviousCachedImage) {
        self.hidden = YES;
    } else {
        [self showImage:adType];
    }
}

#pragma mark - 展示图片

- (void) showImage:(AdType)adType
{
    if (adType == FullScreenAdType) {
        self.adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    } else {
        self.adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kMainScreenWidth/3)];
    }
    [self.adImageView setImage:_lastPreviousCachedImage];
    [self.adImageView setUserInteractionEnabled: YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(clickAd)];
    [self.adImageView addGestureRecognizer: singleTap];
    [self addSubview: _adImageView];
}

#pragma mark - 图片点击事件

- (void)clickAd
{
    [self.delegate clickAdvertisement: self];
    [self removeAdvertView];
}

#pragma mark - 移除广告

- (void)removeAdvertView
{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - 下载图片

- (void) requestAdvertisementData
{
    // 如果缓存有 不下载
    if (![[SDWebImageManager sharedManager].imageCache diskImageExistsWithKey:self.imageURL]) {
        // 如果该图片不存在，则删除老图片，下载新图片
        [[SDWebImageManager sharedManager] downloadImageWithURL: [[NSURL alloc] initWithString: self.imageURL]
                                                        options: SDWebImageAvoidAutoSetImage
                                                       progress:nil
                                                      completed: ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                          
                                                          NSLog(@"图片下载成功");
                                                          NSLog(@"error-->%@", error);
                                                          [self deleteOldImage];
                                                          [DONG_UserDefaults setValue:self.imageURL forKey:adImageUrl];
                                                          [DONG_UserDefaults synchronize];
                                                          
                                                      }];
    }
}

#pragma mark - 删除旧图片

- (void)deleteOldImage
{
    NSString *imageKey = [DONG_UserDefaults valueForKey:adImageUrl];
    if (imageKey) {
        DONG_Log(@"删除旧图片");
        [[SDWebImageManager sharedManager].imageCache removeImageForKey:imageKey fromDisk:YES];
    }
}

#pragma mark - 添加跳过按钮

- (void)addSkipButton
{
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipBtn.frame = CGRectMake(kMainScreenWidth - 70, 20, 60, 30);
    self.skipBtn.backgroundColor = [UIColor brownColor];
    self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.adImageView addSubview:self.skipBtn];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.skipBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.skipBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    self.skipBtn.layer.mask = maskLayer;
   _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_countDownTimer forMode:NSRunLoopCommonModes];
}

- (void)skipBtnClick
{
    _clickId = @"2";
    [self removeAdvertView];
}

- (void)countDown
{
    if (_adTime == 0) {
        [self removeAdvertView];
    } else {
        [self.skipBtn setTitle:[NSString stringWithFormat:@"%@ | 跳过",@(_adTime--)] forState:UIControlStateNormal];
    }
}


#pragma mark - 懒加载

- (UIView *)adBackground
{
    CGRect  scr = [UIScreen mainScreen].bounds;
    CGFloat wid = scr.size.width;
    CGFloat hei = scr.size.height;
    
    UIView *footer = [[UIView alloc] initWithFrame: CGRectMake(0, hei - 128, wid, 128)];
    footer.backgroundColor = [UIColor whiteColor];
    
    UIImageView *slogan = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"LaunchImage"]];
    [footer addSubview: slogan];
    
    [slogan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footer);
    }];
    
    UIView *view = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview: footer];
    return view;
    
    return nil;
}

- (NSString *)imageURL
{
    //    NSString *str = @"http://www.bizhituku.com/file/d/dongmanbizhi/20150309/201503091827501686.jpg";
    NSString *str = @"http://img.shenghuozhe.net/shz/2016/05/07/750w_1224h_043751462609867.jpg";
    str = @"http://192.167.1.6:15414//multimedia/image/EPOSIDE/2017/05/24/2017_05_24_10_05_27_590.jpg";
    return str;
}










//UIButton *showDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//[showDetailBtn setTitle:@"详情>>" forState:UIControlStateNormal];
//[showDetailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//[showDetailBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//showDetailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//showDetailBtn.frame = CGRectMake(f.size.width - 70, 30, 60, 30);
//showDetailBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//showDetailBtn.layer.borderWidth = 1.0f;
//showDetailBtn.layer.cornerRadius = 3.0f;
//[showDetailBtn addTarget:self action:@selector(showAdDetail:) forControlEvents:UIControlEventTouchUpInside];
//[v addSubview:showDetailBtn];

@end
