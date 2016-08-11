//
//  SCHomePageViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCHomePageViewController.h"
#import "SCSycleBanner.h"
#import "SCDemandChannelItemCell.h"//section 0 cell
#import "SCCollectionViewPageCell.h"//其他cell
#import "SCHomePageFlowLayout.h"
#import "SCHomePageSectionBGReusableView.h"//senction header

#import "SCRankViewController.h"//排行
#import "SCChannelCatalogueVC.h"//点播栏目更多
#import "SCChannelCategoryVC.h"//节目频道分类

#import "SCPlayerViewController.h"

#import "SCBannerModel.h"
#import "SCFilmListModel.h"
#import "SCFilmClassModel.h"
#import "SCFilmModel.h"




@interface SCHomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,NSXMLParserDelegate>

@property (nonatomic, strong) UICollectionView *collView;
/** tableView数据源 */
@property (nonatomic, strong) NSArray *dataSource;
/** tableView数据源 */
@property (nonatomic, copy) NSMutableArray *sectionArr;

/** 点播栏所有item */
@property (nonatomic, copy) NSMutableArray *allItemsArr;

@property (nonatomic, strong) SCSycleBanner *bannerView;

/** banner页图片地址数组 */
@property (nonatomic, copy) NSMutableArray *bannerImageUrlArr;

/** 存储filmList中的filmClass模型（第二层数据）*/
@property (nonatomic, copy) NSMutableArray *filmClassArray;

/** section标题 */
@property (nonatomic, copy) NSMutableArray *titleArray;

@end

@implementation SCHomePageViewController

static NSString *const cellId = @"cellId";
static NSString *const cellIdOther = @"cellIdOther";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";


#pragma mark-  ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:@"#dddddd"];
    //1. 设置导航栏的颜色(效果只作用当前页面）
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:@"#F0F1F2"]];
    // 设置导航栏的颜色（效果作用到所有页面）
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor colorWithHex:@"#F1F1F1"]];
    //2. 初始化数组
    
    
    
    //3.添加collectionView
    [self addCollView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- Initialize

#pragma mark- CustomDelegate


#pragma mark- Event reponse

#pragma mark- Public methods

#pragma mark- Private methods
- (void)addCollView{
    [self.view addSubview:self.collView];
    [_collView setFrame:self.view.bounds];
    
    //2.集成刷新
    [self setCollectionViewRefresh];
    
}

#pragma mark - 集成刷新
- (void)setCollectionViewRefresh {
    [CommonFunc setupRefreshWithCollectionViewWithBanner:_collView withSelf:self headerFunc:@selector(headerRefresh) headerFuncFirst:YES footerFunc:nil];
}

- (void)headerRefresh {
    
    [self requestData];
}

- (void)requestData{
    
    //>>>>>>>>>>>>>>>>>>>>banner测试接口<<<<<<<<<<<<<<<<<<<<<<
    //        if (_bannerImageUrlArr) {
    //            [_bannerImageUrlArr removeAllObjects];
    //        }else if (!_bannerImageUrlArr){
    //            _bannerImageUrlArr = [NSMutableArray arrayWithCapacity:0];
    //        }
    //
    //        [requestDataManager requestBannerDataWithUrl:BannerURL parameters:nil success:^(id  _Nullable responseObject) {
    //
    //            NSMutableArray *dataArr = responseObject[@"Film"];
    //
    //            if (![dataArr isKindOfClass:[NSNull class]]) {
    //                for (NSDictionary *dic in dataArr) {
    //                    SCBannerModel *model = [SCBannerModel mj_objectWithKeyValues:dic];
    //                    [_bannerImageUrlArr addObject:model._ImgUrlOriginal];
    //
    //                }
    //
    //                //添加banner
    //                if (_bannerImageUrlArr.count > 0) {
    //                    [self addBannerView];
    //                    _bannerView.imageURLStringsGroup = _bannerImageUrlArr;
    //                }}else if (_bannerImageUrlArr.count == 0){
    //                    if (_bannerView) {
    //                        [_bannerView removeFromSuperview];
    //
    //                    }
    //                }
    //            [CommonFunc dismiss];
    //            [_collView.mj_header endRefreshing];
    //
    //        } failure:^(id  _Nullable errorObject) {
    //            [CommonFunc dismiss];
    //            [_collView.mj_header endRefreshing];
    //
    //        }];
    //
    
    //>>>>>>>>>>>>>>>>>>>>整合后的首页接口调试<<<<<<<<<<<<<<<<<<<<<<
    if (_titleArray) {
        [_titleArray removeAllObjects];
    }else if (!_titleArray){
        _titleArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    if (_filmClassArray) {
        [_filmClassArray removeAllObjects];
    }else if (!_filmClassArray){
        _filmClassArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    if (_bannerImageUrlArr) {
        [_bannerImageUrlArr removeAllObjects];
    }else if (!_bannerImageUrlArr){
        _bannerImageUrlArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    
    [requestDataManager requestDataWithUrl:HomePageUrl parameters:nil success:^(id  _Nullable responseObject) {
        
        //1.第一层 filmList
        SCFilmListModel *filmListModel = [SCFilmListModel mj_objectWithKeyValues:responseObject];
        
        for (SCFilmClassModel *classModel in filmListModel.filmClassArray) {
            
            if (![classModel._FilmClassName hasSuffix:@"今日推荐"]) {
                
                [_titleArray addObject:classModel._FilmClassName];
                [_filmClassArray addObject:classModel];
                
                [_collView reloadData];
                
//                NSLog(@">>>>>>>>homePageData:::%@",classModel._FilmClassName);
//                NSLog(@"====FilmClassUrl::::%@",classModel.FilmClassUrl);
                
            }else{
                
                //添加banner
                NSArray *dataArr = responseObject[@"FilmClass"];
                NSDictionary *dic = [dataArr firstObject];
                NSArray *array = dic[@"Film"];
                
                if (![dataArr isKindOfClass:[NSNull class]]) {
                    for (NSDictionary *dic in array) {
                        
                        SCBannerModel *model = [SCBannerModel mj_objectWithKeyValues:dic];
                        [_bannerImageUrlArr addObject:model._ImgUrlO];
                    }
                    
                    //添加banner
                    if (_bannerImageUrlArr.count > 0) {
                        [self addBannerView];
                        _bannerView.imageURLStringsGroup = _bannerImageUrlArr;
                        
                    }else if (_bannerImageUrlArr.count == 0){
                        if (_bannerView) {
                            [_bannerView removeFromSuperview];
                            
                        }
                    }
                }
            }
            
        }
        
        //        NSLog(@">>>>>>>>homePageData:::%ld",_filmClassArray.count);
        //        NSLog(@">>>>>>>>homePageData:::%ld",_titleArray.count);
//                NSLog(@">>>>>>>>homePageData:::%@",responseObject);
        
        [CommonFunc dismiss];
        [_collView.mj_header endRefreshing];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
        [_collView.mj_header endRefreshing];
        
    }];
    
    
}

//section header
- (UIView *)addSectionHeaderViewWithTitle:(NSString *)title tag:(NSInteger)tag{
    UIView *view = [[UIImageView alloc] init];
    view.frame = CGRectMake(0, 10, kMainScreenWidth, 40.f);
    view.backgroundColor = [UIColor whiteColor];
    //图标
    UIImageView *iv = [[UIImageView alloc] init];
    [iv setImage:[UIImage imageNamed:@"SectionLeftImage"]];
    [view addSubview:iv];
    [iv mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(iv.image.size);
    }];
    //标题label
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    [label setFont :[UIFont fontWithName :@"Helvetica-Bold" size :20]];//加粗
    label.font = [UIFont systemFontOfSize:13.f];
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).and.offset(12);
        make.size.mas_equalTo(CGSizeMake(100, 21));
        
    }];
    //右侧btn
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = tag;
    [btn setTitle: @"更多" forState: UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn setTitleColor:[UIColor colorWithHex:@"#878889"]forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Right_single_arrow"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 75, 0, 0);
    [btn addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view);
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 40));
        
    }];
    view.userInteractionEnabled = YES;
    return view;
}

- (void)addBannerView{
    
    _bannerView = [[SCSycleBanner alloc] initWithView:nil];
    _bannerView.delegate = self;
    [_collView addSubview:_bannerView];
}


#pragma mark ---- responce
- (void)sectionClick:(UIButton *)sender{
    
    if (_filmClassArray) {
        
        
        SCFilmClassModel *filmClassModel = _filmClassArray[sender.tag];
        
        NSLog(@"====FilmClassUrl::::%@",filmClassModel._FilmClassName);
        
        NSLog(@"====FilmClassUrl::::%@",filmClassModel.FilmClassUrl);
        
        SCChannelCategoryVC *channelVC  = [[SCChannelCategoryVC alloc] initWithWithTitle:filmClassModel._FilmClassName];
        channelVC.FilmClassModel = filmClassModel;
        channelVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:channelVC animated:YES];
        
    }
}

#pragma mark ---- UICollectionView  DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _titleArray.count+1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0){
        return 8;
    }else{
        
        SCFilmClassModel *model = _filmClassArray[section-1];
        return model.filmArray.count;
    }
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSDictionary *dict = [self.allItemsArr objectAtIndex:indexPath.row];
        SCDemandChannelItemCell *cell = [SCDemandChannelItemCell cellWithCollectionView:collectionView indexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setModel:dict IndexPath:indexPath];
        
        return cell;
        
    }else{
        SCCollectionViewPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdOther forIndexPath:indexPath];
        //cell.backgroundColor = [UIColor purpleColor];
        
        SCFilmClassModel *classModel = _filmClassArray[indexPath.section-1];
        SCFilmModel *filmModel = classModel.filmArray[indexPath.row];
        cell.model = filmModel;
//                NSLog(@">>>>>>>>>_SourceUrl:::%@",filmModel.SourceUrl);
        return cell;
        
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
        //                headerView.backgroundColor = [UIColor purpleColor];
        UIView *view = [self addSectionHeaderViewWithTitle:_titleArray[indexPath.section-1] tag:indexPath.section-1];
        [headerView addSubview:view];
        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        if(footerView == nil)
        {
            footerView = [[UICollectionReusableView alloc] init];
        }
        footerView.backgroundColor = [UIColor lightGrayColor];
        
        return footerView;
    }
    
    return nil;
}


#pragma mark ---- UICollectionViewDelegateFlowLayout
/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return (CGSize){(kMainScreenWidth-10-15)/4,70};
    }else{
        return (CGSize){(kMainScreenWidth-24-16)/3,180};
    }
    
}

/** Section 四周间距 EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0){
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }else{
        return UIEdgeInsetsMake(5, 12, 5, 12);
    }
    
}

/** item水平间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5.f;
}

/** item垂直间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0){
        return 5;
    }else{
        return 8;
    }
}

/** section Header 尺寸 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return (CGSize){kMainScreenWidth,0};
    }else{
        
        return (CGSize){kMainScreenWidth,50};
    }
}

/** section Footer 尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return (CGSize){kMainScreenWidth,0};
}

#pragma mark ---- UICollectionView DataDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"点击了  ---=== %ld",(long)indexPath.item);
    
    //设置返回键标题
    NSDictionary *dict = [_allItemsArr objectAtIndex:indexPath.row];
    
    if (indexPath.section ==0) {//点播栏
        if ([[dict.allValues objectAtIndex:0] isEqualToString:@"更多"]) {
            SCChannelCatalogueVC *moreView = [[SCChannelCatalogueVC alloc] initWithWithTitle:[dict.allValues objectAtIndex:0]];
            moreView.filmClassArray = _filmClassArray;
            moreView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreView animated:YES];
            
        }else{
            if (_filmClassArray) {
                if (indexPath.row == 0) {
                    [MBProgressHUD showSuccess:@"敬请期待"];
                    
                }else{
                    SCFilmClassModel *filmClassModel = _filmClassArray[indexPath.row-1];
                    SCChannelCategoryVC *channelVC  = [[SCChannelCategoryVC alloc] initWithWithTitle:filmClassModel._FilmClassName];
                    channelVC.FilmClassModel = filmClassModel;
                    channelVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:channelVC animated:YES];
 
                }
                
            }
        }
        
    }else{
        
        SCPlayerViewController *teleplayPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
        SCFilmClassModel *classModel = _filmClassArray[indexPath.section-1];
        SCFilmModel *filmModel = classModel.filmArray[indexPath.row];
        teleplayPlayer.filmModel = filmModel;
        teleplayPlayer.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:teleplayPlayer animated:YES];
        
    }
}



#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    //    ALERT(@"点击banner");
    NSLog(@">>>>>> 第%ld张图", (long)index);
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    // NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
}


#pragma mark- Getters and Setters
- (UICollectionView *)collView{
    SCHomePageFlowLayout *layout = [[SCHomePageFlowLayout alloc]init]; // 布局对象
    layout.alternateDecorationViews = YES;
    // 读取xib背景
    layout.decorationViewOfKinds = @[@"SCHomePageSectionBGReusableView"];
    
    _collView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    
    _collView.alwaysBounceVertical=YES;
    _collView.dataSource = self;
    _collView.delegate = self;
    
    _collView.contentInset = UIEdgeInsetsMake(165, 0, 0, 0);//留白添加banner
    
    // 注册cell、sectionHeader、sectionFooter
    //点播栏cell
    [_collView registerNib:[UINib nibWithNibName:@"SCDemandChannelItemCell" bundle:nil] forCellWithReuseIdentifier:@"SCDemandChannelItemCell"];
    
    [_collView registerNib:[UINib nibWithNibName:@"SCCollectionViewPageCell" bundle:nil] forCellWithReuseIdentifier:@"cellIdOther"];//其他cell
    
    [_collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [_collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
    return _collView;
}

#pragma mark- Getters and Setters
- (NSMutableArray *)allItemsArr{
    if (!_allItemsArr) {
        NSArray *array =@[@{@"Live" : @"直播"}, @{@"CinemaPlaying" : @"私人影院"}, @{@"ChildrenTheater" : @"少儿剧场"}, @{@"OverseasFilm" : @"海外片场"}, @{@"Moive" : @"电影"}, @{@"Teleplay" : @"电视剧"},  @{@"Children" : @"少儿"}, @{@"GeneralChannel" : @"更多"}, @{@"Cartoon" : @"动漫"}, @{@"Arts" : @"综艺"}, @{@"Life" : @"生活"}, @{@"Documentary" : @"纪录片"}, @{@"Game" : @"游戏"}, @{@"Music" : @"音乐"},  @{@"SpecialTopic" : @"专题"}];
        
        _allItemsArr = [NSMutableArray arrayWithCapacity:0];
        [_allItemsArr addObjectsFromArray:array];
    }
    return _allItemsArr;
}






@end
