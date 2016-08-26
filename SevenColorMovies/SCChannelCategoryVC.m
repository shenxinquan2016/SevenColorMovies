//
//  SCChannelCategoryVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
// 点播节目频道分类

#import "SCChannelCategoryVC.h"
#import "SCSlideHeaderLabel.h"
#import "SCPlayerViewController.h"
#import "SCSiftViewController.h"
#import "SCFilmClassModel.h"
#import "SCFilmModel.h"
#import "SCCollectionViewPageCell.h"

#import "SCCollectionViewPageVC.h"



static const CGFloat TitleHeight = 41.0f;
static const CGFloat StatusBarHeight = 20.0f;
static const CGFloat LabelWidth = 95.f;


@interface SCChannelCategoryVC ()<UIScrollViewDelegate>

/** 标题栏scrollView */
@property (nonatomic, strong) UIScrollView *titleScroll;
/** 内容栏scrollView */
@property (nonatomic, strong) UIScrollView *contentScroll;
/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *titleArr;
/** ... */
@property (nonatomic, strong) NSMutableArray *filmClassModelArr;
/** filmClassUrl数组 */
@property (nonatomic, strong) NSMutableArray *FilmClassUrlArr;
/** ... */
@property (nonatomic, strong) NSMutableArray *filmModelArr;
/** 滑动短线 */
@property (nonatomic, strong) CALayer *bottomLine;
/** 筛选按钮 */
@property (nonatomic, strong) UIButton *siftBtn;
/** collectionView加载标识 */
@property (nonatomic, assign) int tag;
/** 在当前页设置点击顶部滚动复位 */
@property (nonatomic, strong) SCCollectionViewPageVC *needScrollToTopPage;

@end

@implementation SCChannelCategoryVC

static NSString *const cellId = @"cellId";


#pragma mark-  ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //1.筛选按钮
    [self addSiftBtn];
    
    //2.初始化数组
    self.titleArr = [NSMutableArray arrayWithCapacity:0];
    self.filmClassModelArr = [NSMutableArray arrayWithCapacity:0];
    self.filmModelArr = [NSMutableArray arrayWithCapacity:0];
    self.FilmClassUrlArr = [NSMutableArray arrayWithCapacity:0];
    
    //3.网络请求
    [self getFilmClassData];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark- private methods
// 添加筛选
- (void)addSiftBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 29, 29);
    [btn setBackgroundImage:[UIImage imageNamed:@"Sift"] forState:UIControlStateNormal];
    _siftBtn.selected = NO;
    [btn addTarget:self action:@selector(doSiftingAction) forControlEvents:UIControlEventTouchUpInside];
    //    btn.backgroundColor = [UIColor redColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];
    
    _siftBtn = btn;
}

//
- (void)getFilmClassData{
    
    //域名转换成IP
    NSString *url = [[NetUrlManager.interface5 stringByAppendingString:NetUrlManager.commonPort] stringByAppendingString:[_FilmClassModel.FilmClassUrl componentsSeparatedByString:@"/"].lastObject];
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager requestDataWithUrl:urlStr parameters:nil success:^(id  _Nullable responseObject) {
        
        if (responseObject) {
            
            NSArray *array = responseObject[@"FilmClass"];
            for (NSDictionary *dic in array) {
                
                [_titleArr addObject:dic[@"_FilmClassName"]];
                [_FilmClassUrlArr addObject:dic[@"_FilmClassUrl"]];
                
            }
            //1.添加滑动headerView
            [self constructSlideHeaderView];
            //2.添加contentScrllowView
            [self constructContentView];
            
        }
//                NSLog(@"==========dic:::%@========",responseObject);

    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
    
}
/** 添加滚动标题栏*/
- (void)constructSlideHeaderView{
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 20+44+8, kMainScreenWidth, TitleHeight)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    CGFloat titleScrollWith = 0.f;
    if (_titleArr.count*LabelWidth<kMainScreenWidth) {
        titleScrollWith = _titleArr.count*LabelWidth;
    }else{
        titleScrollWith = kMainScreenWidth;
    }
    
    
    self.titleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, titleScrollWith, TitleHeight)];//滚动窗口
    self.titleScroll.showsHorizontalScrollIndicator = NO;
    self.titleScroll.showsVerticalScrollIndicator = NO;
    self.titleScroll.scrollsToTop = NO;
    
    [backgroundView addSubview:_titleScroll];
    
    //0.添加lab
    [self addLabel];//添加标题label
    //1、底部滑动短线
    _bottomLine = [CALayer layer];
    [_bottomLine setBackgroundColor:[UIColor colorWithHex:@"#6594FF"].CGColor];
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
        
        label.text =_titleArr[i];
        label.font = [UIFont fontWithName:@"HYQiHei" size:16];
        [self.titleScroll addSubview:label];
        label.tag = i;
        label.userInteractionEnabled = YES;
        //        label.backgroundColor = [UIColor greenColor];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick:)]];
    }
    
    _titleScroll.contentSize = CGSizeMake(LabelWidth * _titleArr.count, 0);
    
    //默认选择第一个label
    SCSlideHeaderLabel *lable = [self.titleScroll.subviews firstObject];
    lable.scale = 1.0;
    
}

/** 添加正文内容页 */
- (void)constructContentView{
    
    _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusBarHeight+TitleHeight+44+8+8, kMainScreenWidth, kMainScreenHeight-StatusBarHeight-TitleHeight-44-8-8)];//滚动窗口
    _contentScroll.scrollsToTop = NO;
    _contentScroll.showsHorizontalScrollIndicator = NO;
    _contentScroll.pagingEnabled = YES;
    _contentScroll.delegate = self;
    //    _contentScroll.backgroundColor = [UIColor redColor];
    [self.view addSubview:_contentScroll];
    
    //添加子控制器
    for (int i=0 ; i<_titleArr.count ;i++){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
        
        SCCollectionViewPageVC *vc = [[SCCollectionViewPageVC alloc] initWithCollectionViewLayout:layout];
        
        if (_FilmClassUrlArr.count) {
            NSString *urlStr = _FilmClassUrlArr[i];
            NSString *url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            vc.urlString = url;
            vc.FilmClassModel = _FilmClassModel;// 用于判断cell的显示类型
        }
    
        [self addChildViewController:vc];
        
    }
    // 添加默认控制器
    SCCollectionViewPageVC *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.contentScroll.bounds;
    self.needScrollToTopPage = self.childViewControllers[0];
    
    [self.contentScroll addSubview:vc.view];
    
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    _contentScroll.contentSize = CGSizeMake(contentX, 0);
}

#pragma mark- Event reponse
// 点击标题label
- (void)labelClick:(UITapGestureRecognizer *)recognizer{
    SCSlideHeaderLabel *label = (SCSlideHeaderLabel *)recognizer.view;
    CGFloat offsetX = label.tag * _contentScroll.frame.size.width;
    
    CGFloat offsetY = _contentScroll.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [_contentScroll setContentOffset:offset animated:YES];
    
    [self setScrollToTopWithTableViewIndex:label.tag];
}

#pragma mark - ScrollToTop

- (void)setScrollToTopWithTableViewIndex:(NSInteger)index
{
    self.needScrollToTopPage.collectionView.scrollsToTop = NO;
    self.needScrollToTopPage = self.childViewControllers[index];
    self.needScrollToTopPage.collectionView.scrollsToTop = YES;
}

// 筛选
- (void)doSiftingAction{
    if (_siftBtn.selected == NO) {
        _siftBtn.selected = YES;
        [_siftBtn setBackgroundImage:[UIImage imageNamed:@"Sifting"] forState:UIControlStateNormal];
        NSLog(@">>>>>>>>>>筛选>>>>>>>>>>>>");
        
    }else if (_siftBtn.selected != NO){
        _siftBtn.selected = NO;
        [_siftBtn setBackgroundImage:[UIImage imageNamed:@"Sift"] forState:UIControlStateNormal];
        NSLog(@">>>>>>>>>>取消筛选>>>>>>>>>>>>");
    }
    SCSiftViewController *siftVC = DONG_INSTANT_VC_WITH_ID(@"HomePage", @"SCSiftViewController");
    siftVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:siftVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
/** 滚动结束后调用（代码导致的滚动停止） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / _contentScroll.frame.size.width;
    // 滚动标题栏
    SCSlideHeaderLabel *titleLable = (SCSlideHeaderLabel *)_titleScroll.subviews[index];
    
    //把下划线与titieLabel的frame绑定(下划线滑动方式)
    _bottomLine.frame = CGRectMake(titleLable.frame.origin.x, _titleScroll.frame.size.height-22+StatusBarHeight, LabelWidth, 2);
    
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
    SCCollectionViewPageVC *vc = self.childViewControllers[index];
    
    [_titleScroll.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            SCSlideHeaderLabel *temlabel = _titleScroll.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];
    
    [self setScrollToTopWithTableViewIndex:index];
    
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
    _bottomLine.frame = CGRectMake(modulus * _titleScroll.contentSize.width, _titleScroll.frame.size.height-22+StatusBarHeight, LabelWidth, 2);
    
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate{
    return NO;
}

@end
