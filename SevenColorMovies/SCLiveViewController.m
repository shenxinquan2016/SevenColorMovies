//
//  SCLiveViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  直播首页面

#import "SCLiveViewController.h"
#import "SCLivePageCollectionVC.h"
#import "SCSlideHeaderLabel.h"
#import "SCFilmModel.h"

static const CGFloat TitleHeight = 41.0f;
static const CGFloat StatusBarHeight = 20.0f;
static const CGFloat LabelWidth = 95.f;

@interface SCLiveViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *titleScroll;/** 标题栏scrollView */
@property (nonatomic, strong) UIScrollView *contentScroll;/** 内容栏scrollView */
@property (nonatomic, strong) NSMutableArray *titleArr;/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *filmModelArr;/** filmModel */
@property (nonatomic, strong) NSMutableArray *dataSourceArr;/** livePage数据源 */

@property (nonatomic, strong) CALayer *bottomLine;/** 滑动短线 */
@property (nonatomic, strong) SCLivePageCollectionVC *needScrollToTopPage;/** 在当前页设置点击顶部滚动复位 */

@end

@implementation SCLiveViewController

#pragma mark-  ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //2.初始化数组
    self.titleArr = [NSMutableArray arrayWithCapacity:0];
    self.filmModelArr = [NSMutableArray arrayWithCapacity:0];
    self.dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    
    //3.网络请求
    [self getLiveClassListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark- private methods
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
        
        SCLivePageCollectionVC *vc = [[SCLivePageCollectionVC alloc] initWithCollectionViewLayout:layout];
        
        if (_dataSourceArr) {
            
            vc.filmModelArr = _dataSourceArr[i];
        }
        
        [self addChildViewController:vc];
        
    }
    // 添加默认控制器
    SCLivePageCollectionVC *vc = [self.childViewControllers firstObject];
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
    SCLivePageCollectionVC *vc = self.childViewControllers[index];
    
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

#pragma mark- 网络请求
- (void)getLiveClassListData{
    
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager requestDataWithUrl:testUrl parameters:nil success:^(id  _Nullable responseObject) {
        
        if (responseObject) {
            NSArray *array = responseObject[@"LiveTvSort"];
            
            for (NSDictionary *dic in array) {
                
                [_titleArr addObject:dic[@"_AssortName"]];
                NSArray *arr = dic[@"LiveTv"];
                
                [_filmModelArr removeAllObjects];
                
                for (NSDictionary *dic in arr) {
                    //获取filmModel
                    SCFilmModel *filmModel = [SCFilmModel mj_objectWithKeyValues:dic];
                    [_filmModelArr addObject:filmModel];
                    
                    //获取播放列表
                    if ([dic[@"ContentSet"][@"Content"] isKindOfClass:[NSArray class]]) {
                        NSArray *array = dic[@"ContentSet"][@"Content"];
                        
                        //循环比较当前时间与节目的开始时间和结束时间的关系 开始时间 < 当前时间 < 结束时间 则该节目为正在播放节目
                        for (NSDictionary *dic1 in array) {
                            //0.时间字符串
                            NSString *timeBeginString = dic1[@"_PlayerTime"];
                            NSString *timeEndString = dic1[@"_StopTime"];
                            //1.创建一个时间格式化对象
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            
                            //2.格式化对象的样式/z大小写都行/格式必须严格和字符串时间一样
                            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                            
                            //3.利用时间格式化对象让字符串转换成时间 (自动转换0时区/东加西减)
                            NSDate *timeBeginDate = [formatter dateFromString:timeBeginString];
                            NSDate *timeEndDate = [formatter dateFromString:timeEndString];
                            
                            //4.当前时间
                            NSString *currenDate = [[NSDate date] getTimeStamp];
                            
                            //5.日期比较
                            NSComparisonResult result1 = [currenDate compare:timeBeginDate];
                            NSComparisonResult result2 = [currenDate compare:timeEndDate];
                            
                            if (result1 == NSOrderedDescending && result2 == NSOrderedAscending) {
                                
                                
                            }
                        }
                        
                        
                    }
                    
                }
                
                [_dataSourceArr addObject:[_filmModelArr copy]];
            }
            //1.添加滑动headerView
            [self constructSlideHeaderView];
            //2.添加contentScrllowView
            [self constructContentView];
            
        }
        //        NSLog(@"==========dic:::%@========",responseObject);
        [CommonFunc dismiss];
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
    
}
@end
