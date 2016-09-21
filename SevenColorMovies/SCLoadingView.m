//
//  SCLoadingView.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/27.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCLoadingView.h"

@interface SCLoadingView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end


@implementation SCLoadingView

+ (instancetype)shareManager {
    static SCLoadingView *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NSBundle mainBundle] loadNibNamed:(NSStringFromClass([self class])) owner:nil options:nil][0];
        manager.backgroundColor = [UIColor colorWithHex:@"#000000" alpha:0.0];
        manager.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        [[UIApplication sharedApplication].keyWindow addSubview:manager];
    });
    
    //manager.hidden = NO;
    return manager;
}


- (void)showLoadingTitle:(NSString *)title {
    _titleLabel.text = title;
    //self.hidden = NO;
    BOOL _show = YES;
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[SCLoadingView class]]) {
            _show = NO;
        }
    }
    
    if (_show) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    [_imageView startAnimating];
}

- (void)dismiss {
    //self.hidden = YES;
    [self removeFromSuperview];
    [_imageView stopAnimating];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //gif动画播放
    //    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"加载gif" ofType:@"gif"]]];
    //    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    //    imageView.animatedImage = image;
    //    imageView.frame = CGRectMake((WScreen-75)/2, (HScreen-75)/2 - 30, 75, 75);
    //    [self addSubview:imageView];
    
    
    NSArray *gifArray = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"loading_1"],
                         [UIImage imageNamed:@"loading_2"],
                         [UIImage imageNamed:@"loading_3"],
                         [UIImage imageNamed:@"loading_4"],
                         [UIImage imageNamed:@"loading_5"],
                         [UIImage imageNamed:@"loading_6"],
                         [UIImage imageNamed:@"loading_7"],
                         [UIImage imageNamed:@"loading_8"],
                         nil];
    _imageView.animationImages = gifArray; //动画图片数组
    _imageView.animationDuration = 1; //执行一次完整动画所需的时长
    _imageView.animationRepeatCount = 0;  //动画重复次数
    [_imageView startAnimating];
    
}

@end
