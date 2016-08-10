//
//  SCMoiveAllEpisodesVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCMoiveAllEpisodesVC.h"
#import "SCSlideHeaderLabel.h"
#import "SCMoiveAllEpisodesCollectionVC.h"
#import "SCFilmSetModel.h"


static const CGFloat TitleHeight = 40.0f;
//static const CGFloat StatusBarHeight = 20.0f;
static const CGFloat LabelWidth = 70.f;

@interface SCMoiveAllEpisodesVC ()<UIScrollViewDelegate>

/** 标题栏scrollView */
@property (nonatomic, strong) UIScrollView *titleScroll;
/** 内容栏scrollView */
@property (nonatomic, strong) UIScrollView *contentScroll;

/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArr;

/** sets数据 */
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation SCMoiveAllEpisodesVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.view.backgroundColor = [UIColor redColor];
    //    [self loadCollectionView];
    
    //3.初始化数组
    self.titleArr = [NSArray array];
    self.dataSource = [NSArray array];
    
    
    _titleArr = [self getSlideHeaderArrayFromArray:_filmSetsArr];
    _dataSource = [self splitArray:_filmSetsArr withSubSize:20];
    

    [self setView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- private methods

- (void)setView{
    
    
    //4.添加滑动headerView
    [self constructSlideHeaderView];
    //5.添加contentScrllowView
    [self constructContentView];
}

- (NSArray *)getSlideHeaderArrayFromArray:(NSArray *)arr{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    [array removeAllObjects];
    
    if (arr.count/20 == 0) {
        
        NSString *str = [NSString stringWithFormat:@"1-%ld",arr.count%20];
        [array addObject:str];
        
    }else{
        
        if (arr.count%20 == 0) {
            
            for (int i = 0; i < arr.count/20; i++) {
                
                NSString *str = [NSString stringWithFormat:@"%d-%d",20*i+1,20+20*i];
                [array addObject:str];
            }
            
        }else{
            
            for (int i = 0; i < arr.count/20; i++) {
                
                NSString *str = [NSString stringWithFormat:@"%d-%d",20*i+1,20+20*i];
                [array addObject:str];
            }
            
            NSString *str = [NSString stringWithFormat:@"%ld-%lu",20+20*(arr.count/20-1)+1,20+20*(arr.count/20-1)+_filmSetsArr.count%20];
            [array addObject:str];
            
            
        }
        
    }

    return [array copy];
}

- (NSArray *)splitArray: (NSArray *)array withSubSize : (int)subSize{
    //  数组将被拆分成指定长度数组的个数
    unsigned long count = array.count % subSize == 0 ? (array.count / subSize) : (array.count / subSize + 1);
    //  用来保存指定长度数组的可变数组对象
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //利用总个数进行循环，将指定长度的元素加入数组
    for (int i = 0; i < count; i ++) {
        //数组下标
        int index = i * subSize;
        //保存拆分的固定长度的数组元素的可变数组
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        //移除子数组的所有元素
        [arr1 removeAllObjects];
        
        int j = index;
        //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
        while (j < subSize*(i + 1) && j < array.count) {
            [arr1 addObject:[array objectAtIndex:j]];
            j += 1;
        }
        //将子数组添加到保存子数组的数组中
        [arr addObject:[arr1 copy]];
    }
    
    return [arr copy];
}


/** 添加滚动标题栏*/
- (void)constructSlideHeaderView{
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, TitleHeight)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    CGFloat titleScrollWith = 0.f;
    if (_titleArr.count*LabelWidth<kMainScreenWidth) {
        titleScrollWith = _titleArr.count*LabelWidth;
    }else{
        titleScrollWith = kMainScreenWidth;
    }
    
    self.titleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, titleScrollWith, TitleHeight)];//滚动窗口
    //        _titleScroll.backgroundColor = [UIColor greenColor];
    self.titleScroll.showsHorizontalScrollIndicator = NO;
    self.titleScroll.showsVerticalScrollIndicator = NO;
    self.titleScroll.scrollsToTop = NO;
    
    [backgroundView addSubview:_titleScroll];
    
    //0.添加lab
    [self addLabel];//添加标题label
    
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
        //        label.backgroundColor = [UIColor greenColor];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick:)]];
    }
    
    _titleScroll.contentSize = CGSizeMake(LabelWidth * _titleArr.count, 0);
    
    //默认选择第一个label
    SCSlideHeaderLabel *lable = [self.titleScroll.subviews firstObject];
    lable.scale = 1.0;
    
    
}

#pragma mark- Event reponse
- (void)labelClick:(UITapGestureRecognizer *)recognizer{
    SCSlideHeaderLabel *label = (SCSlideHeaderLabel *)recognizer.view;
    CGFloat offsetX = label.tag * _contentScroll.frame.size.width;
    
    CGFloat offsetY = _contentScroll.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [_contentScroll setContentOffset:offset animated:YES];
}

/** 添加正文内容页 */
- (void)constructContentView{
    _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 48, kMainScreenWidth, kMainScreenHeight-393)];//滚动窗口
    _contentScroll.scrollsToTop = NO;
    _contentScroll.showsHorizontalScrollIndicator = NO;
    _contentScroll.pagingEnabled = YES;
    _contentScroll.delegate = self;
    //    _contentScroll.backgroundColor = [UIColor redColor];
    [self.view addSubview:_contentScroll];
    
    //添加子控制器
    for (int i=0 ; i<_titleArr.count ;i++){
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
        SCMoiveAllEpisodesCollectionVC *vc = [[SCMoiveAllEpisodesCollectionVC alloc] initWithCollectionViewLayout:layout];
        vc.dataSource = _dataSource[i];
        [self addChildViewController:vc];
        
    }
    // 添加默认控制器
    SCMoiveAllEpisodesCollectionVC *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.contentScroll.bounds;
    [self.contentScroll addSubview:vc.view];

    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    _contentScroll.contentSize = CGSizeMake(contentX, 0);
}


#pragma mark - UIScrollViewDelegate
/** 滚动结束后调用（代码导致的滚动停止） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / _contentScroll.frame.size.width;
    // 滚动标题栏
    SCSlideHeaderLabel *titleLable = (SCSlideHeaderLabel *)_titleScroll.subviews[index];
    
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
    
}


@end
