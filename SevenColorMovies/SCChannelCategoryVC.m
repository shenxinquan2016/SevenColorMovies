//
//  SCChannelCategoryVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
// 点播节目频道分类

#import "SCChannelCategoryVC.h"
#import "SCChannelCategoryCell.h"
#import "SCSlideHeaderLabel.h"
#import "SCTeleplayPlayerVC.h"

static const CGFloat TitleHeight = 50.0f;
static const CGFloat StatusBarHeight = 20.0f;
static const CGFloat LabelWidth = 90.f;


@interface SCChannelCategoryVC ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collView;
/** 标题栏scrollView */
@property (nonatomic, strong) UIScrollView *titleScroll;
/** 内容栏scrollView */
@property (nonatomic, strong) UIScrollView *contentScroll;

/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *titleArr;
/** 滑动短线 */
@property (nonatomic, strong) CALayer *bottomLine;

@end

@implementation SCChannelCategoryVC

static NSString *const cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //1.返回
    [self.leftBBI setTitle: @"直播" forState: UIControlStateNormal];
    
    //3.初始化数组
    self.titleArr = [@[@"最热",@"卫视同步",@"高分经典",@"海外剧场",@"日韩",@"卫视同步",@"最热",@"卫视同步",@"高分经典",@"海外剧场",@"日韩",@"卫视同步"] copy];
    //4.添加滑动headerView
    [self constructSlideHeaderView];
    //5.添加contentScrllowView
    [self constructContentView];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- private methods
- (void)loadCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
    _collView = [[UICollectionView alloc] initWithFrame:self.contentScroll.bounds collectionViewLayout:layout];
    _collView.backgroundColor = [UIColor colorWithHex:@"dddddd"];
    _collView.alwaysBounceVertical=YES;
    _collView.dataSource = self;
    _collView.delegate = self;
    
    //    [_contentScroll addSubview:_collView];
    
    // 注册cell、sectionHeader、sectionFooter
    [_collView registerNib:[UINib nibWithNibName:@"SCChannelCategoryCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    
}

/** 添加滚动标题栏*/
- (void)constructSlideHeaderView{
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, kMainScreenWidth, TitleHeight)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    self.titleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, TitleHeight)];//滚动窗口
    self.titleScroll.showsHorizontalScrollIndicator = NO;
    self.titleScroll.showsVerticalScrollIndicator = NO;
    self.titleScroll.scrollsToTop = NO;
    
    [backgroundView addSubview:_titleScroll];
    
    //0.添加lab
    [self addLabel];//添加标题label
    //1、底部滑动短线
    _bottomLine = [CALayer layer];
    [_bottomLine setBackgroundColor:[UIColor colorWithHex:@"#5184FF"].CGColor];
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
    _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, StatusBarHeight+TitleHeight+63, kMainScreenWidth, kMainScreenHeight-StatusBarHeight-TitleHeight-63)];//滚动窗口
    _contentScroll.scrollsToTop = NO;
    _contentScroll.showsHorizontalScrollIndicator = NO;
    _contentScroll.pagingEnabled = YES;
    _contentScroll.delegate = self;
    //    _contentScroll.backgroundColor = [UIColor redColor];
    [self.view addSubview:_contentScroll];
    
    //添加子控制器
    for (int i=0 ; i<_titleArr.count ;i++){
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor grayColor];
        [self loadCollectionView];
        [vc.view addSubview:_collView];
        
        if (i == 0) {
            [vc.view setFrame:_contentScroll.bounds];
            [_contentScroll addSubview:vc.view];
        }
        [self addChildViewController:vc];
    }
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
    _bottomLine.frame = CGRectMake(modulus * _titleScroll.contentSize.width, _titleScroll.frame.size.height-22+StatusBarHeight, LabelWidth, 2);
    
}



#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 16;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [_collView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(kMainScreenWidth/3-10),165};
}

/** CollectionView四周间距 EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

/** item水平间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

/** item垂直间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

/** section Header 尺寸 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){kMainScreenWidth,0};
}

/** section Footer 尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){kMainScreenWidth,80};
}

#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"======点击=====");
    SCTeleplayPlayerVC *teleplayPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
    teleplayPlayer.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:teleplayPlayer animated:YES];

}

@end
