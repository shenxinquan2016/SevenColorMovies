//
//  Dong_RunLabel.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/7.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "Dong_RunLabel.h"

CGFloat const labelMargin = 100;
CGFloat const padding = 1;

@interface Dong_RunLabel () {
    UILabel *_firstLabel;
    UILabel *_secondLabel;
    UIScrollView *_scrollView;
    NSTimer *_myTimer;
    CGFloat _textWidth;
}

@end


@implementation Dong_RunLabel

- (instancetype)initWithTitle:(NSString *)titleName
{
    self = [super init];
    if (self) {
        self.titleName = titleName;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    UILabel * labelFirst = [[UILabel alloc]init];
    labelFirst.textAlignment = NSTextAlignmentCenter;
    _firstLabel = labelFirst;
    [scrollView addSubview:labelFirst];
    
    UILabel * labelSecond = [[UILabel alloc]init];
    labelSecond.textAlignment = NSTextAlignmentCenter;
    _secondLabel = labelSecond;
    [scrollView addSubview:labelSecond];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    NSAssert(_titleName.length, @"");
    
    if (_titleColor == nil) {
        _titleColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    }
    
    if (_titleFont == nil) {
        _titleFont = [UIFont systemFontOfSize:17];
    }
    
    _firstLabel.textColor = _titleColor;
    _secondLabel.textColor = _titleColor;
    
    _firstLabel.font = _titleFont;
    _secondLabel.font = _titleFont;
    
    _firstLabel.text = self.titleName;
    _secondLabel.text = self.titleName;
    
    CGRect rect = [_titleName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_titleFont} context:nil];
    
    _textWidth = rect.size.width + labelMargin + _scrollView.frame.size.width;
    
    _scrollView.frame = self.bounds;
    
    if (rect.size.width <= self.frame.size.width) {
        _scrollView.contentSize = self.frame.size;
        _firstLabel.frame = self.bounds;
        [_secondLabel removeFromSuperview];
    } else {
        _scrollView.contentSize = CGSizeMake(rect.size.width * 2 + labelMargin, self.frame.size.height);
        _firstLabel.frame = CGRectMake(0, 0, rect.size.width, self.frame.size.height);
        _secondLabel.frame = CGRectMake(rect.size.width+labelMargin, 0 , rect.size.width, self.frame.size.height);
        if (_myTimer == nil) {
            [self addTimer];
        }
    }
}

//添加计时器
- (void)addTimer {
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
}

//移除计时器
- (void)removeTimer {
    [_myTimer invalidate];
    _myTimer = nil;
}

//计时器运行的方法
-(void)runTimer{
    
    CGFloat x = _scrollView.contentOffset.x;
    
    x += padding;
    
    if (x <= _textWidth && x + padding >= _textWidth) {
        x = 0;
    }
    
    [_scrollView setContentOffset:CGPointMake(x, 0) animated:NO];
}

- (void)dealloc{
    [self removeTimer];
}



@end
