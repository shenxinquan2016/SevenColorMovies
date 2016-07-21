//
//  SCSearchViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/20.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCSearchViewController.h"
#import "SCSearchBarView.h"
#import "SCSlideHeaderLabel.h"


const CGFloat TitleHeight = 60.0f;
const CGFloat StatusBarHeight = 20.0f;
const CGFloat LabelWidth = 100;

@interface SCSearchViewController ()<UIScrollViewDelegate>


/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *titleArr;
/** 滑动短线 */
@property (nonatomic, strong) CALayer *bottomLine;

@end

@implementation SCSearchViewController


#pragma mark-  ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;//很大的坑
    self.view.backgroundColor = [UIColor colorWithHex:@"dddddd"];
    
    //1.返回按钮
    [self addLeftBBI];
    //2.添加搜索框
    [self addSearchBBI];
    //3.初始化数组
    self.titleArr = [@[@"点播",@"回看"] copy];
    //4.添加滑动headerView
    [self constructSlideHeaderView];
    //5.添加contentScrllowView
    [self constructContentView];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillLayoutSubviews{
}


#pragma mark- private methods
- (void)addSearchBBI {
    SCSearchBarView *searchView = [[SCSearchBarView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    UIButton *btn = (UIButton *)searchView;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -5;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];
    _searchBBI = btn;
    
}
- (void)addLeftBBI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 22);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn setImage:[UIImage imageNamed:@"Back_Arrow"] forState:UIControlStateNormal];
    [btn setTitle: @"搜索" forState: UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 19.0];
    [btn setTitleColor:[UIColor colorWithHex:@"#878889"]forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    leftNegativeSpacer.width = -6;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftNegativeSpacer,item, nil];
    _leftBBI = btn;
    
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 添加滚动标题栏*/
- (void)constructSlideHeaderView{
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, kMainScreenWidth, TitleHeight)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    self.titleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 0, 200, TitleHeight)];//滚动窗口
    self.titleScroll.showsHorizontalScrollIndicator = NO;
    self.titleScroll.showsVerticalScrollIndicator = NO;
    self.titleScroll.scrollsToTop = NO;
    self.titleScroll.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:_titleScroll];
    
    //0.添加lab
    [self addLabel];//添加标题label
    //1、底部滑动短线
    _bottomLine = [CALayer layer];
    [_bottomLine setBackgroundColor:[UIColor redColor].CGColor];
    _bottomLine.frame = CGRectMake(0, _titleScroll.frame.size.height-22+StatusBarHeight, LabelWidth, 2);
    
    [_titleScroll.layer addSublayer:_bottomLine];
    
}

/** 添加标题栏label */
- (void)addLabel{
    for (int i = 0; i < _titleArr.count; i++) {
        CGFloat lbW = LabelWidth;                //宽
        CGFloat lbH = TitleHeight;       //高
        CGFloat lbX = i * lbW;           //X
        CGFloat lbY = 0;                 //Y
        SCSlideHeaderLabel *label = [[SCSlideHeaderLabel alloc] initWithFrame:(CGRectMake(lbX, lbY, lbW, lbH))];
        //        UIViewController *vc = self.childViewControllers[i];
        label.text =_titleArr[i];
        label.font = [UIFont fontWithName:@"HYQiHei" size:19];
        [self.titleScroll addSubview:label];
        label.tag = i;
        label.userInteractionEnabled = YES;
        label.backgroundColor = [UIColor greenColor];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick:)]];
    }
    
    _titleScroll.contentSize = CGSizeMake(LabelWidth * _titleArr.count, 0);
    
}

/** 添加正文内容页 */
- (void)constructContentView{
    _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusBarHeight+TitleHeight+63, kMainScreenWidth, kMainScreenHeight-StatusBarHeight-TitleHeight-63)];//滚动窗口
    _contentScroll.scrollsToTop = NO;
    _contentScroll.showsHorizontalScrollIndicator = NO;
    _contentScroll.pagingEnabled = YES;
    _contentScroll.delegate = self;

    [self.view addSubview:_contentScroll];
    
    //添加子控制器
    for (int i=0 ; i<_titleArr.count ;i++){
        UIViewController *vc = [[UIViewController alloc] init];
        
        
        UILabel *lab = [[UILabel alloc] init];
        [lab setFrame:CGRectMake(140, 200, 100, 40)];
        [vc.view addSubview:lab];
        lab.text = [NSString stringWithFormat:@"%d",i+1];
        lab.font = [UIFont fontWithName:@"HYQiHei" size:19];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = [UIColor grayColor];
        
        [self addChildViewController:vc];
    }
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    _contentScroll.contentSize = CGSizeMake(contentX, 0);
}


#pragma mark- Event reponse
- (void)labelClick:(UITapGestureRecognizer *)recognizer{
    SCSlideHeaderLabel *label = (SCSlideHeaderLabel *)recognizer.view;
    CGFloat offsetX = label.tag * _contentScroll.frame.size.width;
    
    CGFloat offsetY = _contentScroll.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [_contentScroll setContentOffset:offset animated:YES];
}


#pragma mark - UIScrollViewDelegate
/** 滚动结束后调用（代码导致的滚动停止） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / _contentScroll.frame.size.width;
    // 滚动标题栏
    SCSlideHeaderLabel *titleLable = (SCSlideHeaderLabel *)_titleScroll.subviews[index];
    //把下划线与titieLabel的frame绑定(下划线滑动方式)
    _bottomLine.frame = CGRectMake(titleLable.frame.origin.x, _titleScroll.frame.origin.y+StatusBarHeight-1, LabelWidth, 1);
    
    CGFloat offsetx = titleLable.center.x - _titleScroll.frame.size.width * 0.5;
    
    CGFloat offsetMax = _titleScroll.contentSize.width - _titleScroll.frame.size.width;
    
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, _titleScroll.contentOffset.y);
    [_titleScroll setContentOffset:offset animated:YES];
    
    // 将控制器添加到contentScroll
    UIViewController *vc = self.childViewControllers[index];
    //    vc.index = index;
    
    [_titleScroll.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            SCSlideHeaderLabel *temlabel = _titleScroll.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];
    
    //    [self setScrollToTopWithTableViewIndex:index];
    
    if (vc.view.superview) return;//阻止vc重复添加
    vc.view.frame = scrollView.bounds;
    [_contentScroll addSubview:vc.view];
    
    
}

/** 滚动结束（手势导致的滚动停止） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    SCSlideHeaderLabel *labelLeft = _titleScroll.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < _titleScroll.subviews.count) {
        SCSlideHeaderLabel *labelRight = _titleScroll.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
    //下划线即时滑动
    float modulus = scrollView.contentOffset.x/_contentScroll.contentSize.width;
    //    _bottomLine.frame = CGRectMake(modulus * _titleScroll.contentSize.width, _titleScroll.frame.origin.y+StatusBarHeight-1, LabelWidth, 1);
    
    //自定义滑条
    _bottomLine.frame = CGRectMake(modulus * _titleScroll.contentSize.width + LabelWidth/2, _titleScroll.frame.origin.y+StatusBarHeight-4, 7, 4);
}

@end
