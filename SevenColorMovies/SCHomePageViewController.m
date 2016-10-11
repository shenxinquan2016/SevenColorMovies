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
#import "SCChannelCatalogueVC.h"//点播栏目更多
#import "SCChannelCategoryVC.h"//节目频道分类
#import "SCLiveViewController.h"//直播首页面
#import "SCPlayerViewController.h"
#import "SCBannerModel.h"
#import "SCFilmListModel.h"
#import "SCFilmClassModel.h"
#import "SCFilmModel.h"
#import "SCSpecialTopicDetailVC.h"

@interface SCHomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,NSXMLParserDelegate>

@property (nonatomic, strong) UICollectionView *collView;

@property (nonatomic, copy) NSArray *dataSource;/** tableView数据源 */
@property (nonatomic, strong) NSMutableArray *sectionArr;/** tableView数据源 */
@property (nonatomic, strong) NSMutableArray *allItemsArr;/** 点播栏所有item */
@property (nonatomic, strong) SCSycleBanner *bannerView;
@property (nonatomic, strong) NSMutableArray *bannerImageUrlArr;/** banner页图片地址数组 */
@property (nonatomic, strong) NSMutableArray *bannerFilmModelArr;/** banner filmModel数组 */
@property (nonatomic, strong) NSMutableArray *filmClassArray;/** 存储filmList中的filmClass模型（第二层数据）*/
@property (nonatomic, strong) NSMutableArray *titleArray;/** section标题 */
@property (nonatomic, strong) NSMutableDictionary *filmClassModelDictionary;/** 将filmClassModel放入字典 */
@property (nonatomic, copy) NSArray *filmClassTitleArray;

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
    //0. 设置导航栏的颜色(效果只作用当前页面）
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:@"#F0F1F2"]];
    
    //1.初始化数组
    self.titleArray = [NSMutableArray arrayWithCapacity:0];
    self.filmClassArray = [NSMutableArray arrayWithCapacity:0];
    self.bannerImageUrlArr = [NSMutableArray arrayWithCapacity:0];
    self.bannerFilmModelArr = [NSMutableArray arrayWithCapacity:0];
    
    //2.设置导航栏的颜色（效果作用到所有页面）
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor colorWithHex:@"#F1F1F1"]];
    
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


#pragma mark- Private methods
- (void)addCollView{
    
    SCHomePageFlowLayout *layout = [[SCHomePageFlowLayout alloc]init]; // 布局对象
    layout.alternateDecorationViews = YES;
    // 读取xib背景
    layout.decorationViewOfKinds = @[@"SCHomePageSectionBGReusableView"];
    
    _collView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    
    _collView.alwaysBounceVertical=YES;
    _collView.dataSource = self;
    _collView.delegate = self;
    
    _collView.contentInset = UIEdgeInsetsMake(165, 0, 49, 0);//留白添加banner
    // 无banner时的占位图
    UIView *noBannerView = [[UIView alloc] initWithFrame:CGRectMake(0, -157, kMainScreenWidth, 157)];
    UIImageView *NoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoBanner"]];
    [noBannerView addSubview:NoImageView];
    [NoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(noBannerView);
    }];
    
    [_collView addSubview:noBannerView];
    
    // 注册cell、sectionHeader、sectionFooter
    //点播栏cell
    [_collView registerNib:[UINib nibWithNibName:@"SCDemandChannelItemCell" bundle:nil] forCellWithReuseIdentifier:@"SCDemandChannelItemCell"];
    // 普通栏目cell
    [_collView registerNib:[UINib nibWithNibName:@"SCCollectionViewPageCell" bundle:nil] forCellWithReuseIdentifier:@"SCCollectionViewPageCell"];
    // 综艺栏目cell
    [_collView registerNib:[UINib nibWithNibName:@"SCCollectionViewPageArtsCell" bundle:nil] forCellWithReuseIdentifier:@"SCCollectionViewPageArtsCell"];
    
    [_collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [_collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
    [self.view addSubview:self.collView];
    
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
    
    [_titleArray removeAllObjects];
    [_filmClassArray removeAllObjects];
    [_bannerImageUrlArr removeAllObjects];
    [_bannerFilmModelArr removeAllObjects];
    
    [requestDataManager requestDataWithUrl:HomePageUrl parameters:nil success:^(id  _Nullable responseObject) {
        //NSLog(@"==========dic:::%@========",responseObject);
        //1.第一层 filmList
        SCFilmListModel *filmListModel = [SCFilmListModel mj_objectWithKeyValues:responseObject];
        
        for (SCFilmClassModel *classModel in filmListModel.filmClassArray) {
            
            if (![classModel._FilmClassName hasSuffix:@"今日推荐"]) {
                
                [_titleArray addObject:classModel._FilmClassName];
                [_filmClassArray addObject:classModel];
                
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
                        SCFilmModel *filmModel = [SCFilmModel mj_objectWithKeyValues:dic];
                        [_bannerImageUrlArr addObject:model._ImgUrlO];
                        [_bannerFilmModelArr addObject:filmModel];
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
        //        NSLog(@">>>>>>>>homePageData:::%@",responseObject);
        [_collView reloadData];
        [self setFilmClassTitleArray];
        [CommonFunc dismiss];
        [_collView.mj_header endRefreshing];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
        [_collView.mj_header endRefreshing];
        
    }];
}

- (void)setFilmClassTitleArray
{
    // 将self.titleArray存到本地，每次点击时先取本地的数组：1、如果本地数组与self.titleArray元素相同，则使用本地数组 2.如果本地数组与self.filmClassArray元素不同，则使用self.titleArray
    
    NSArray *filmClassTitleArray = [[NSUserDefaults standardUserDefaults] objectForKey:kFilmClassTitleArray];// NSUserDefaults 只能读取不可变对象
    if (filmClassTitleArray.count == 0) {
        
        NSArray *array = [NSArray arrayWithArray:self.titleArray];// NSUserDefaults 只能读取不可变对象
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:kFilmClassTitleArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.filmClassTitleArray = self.titleArray;
        [_collView reloadData];
        NSLog(@">*******************************<");
        
    }else{
        //谓词判断：A中元素不包含在B中的个数为0切B中元素不包含在A中的个数为0，则两个数组元素相同
        if ([filmClassTitleArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF in %@)", self.titleArray]].count == 0 && [self.titleArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF in %@)", filmClassTitleArray]].count == 0) {//本地保存的和新请求到的相同时
            
            self.filmClassTitleArray = filmClassTitleArray;
            [_collView reloadData];
            
        }else{
            //本地保存的和新请求到的不同时
            NSArray *array = [NSArray arrayWithArray:self.titleArray];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:kFilmClassTitleArray];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.filmClassTitleArray = self.titleArray;
            [_collView reloadData];
        }
    }
    
    self.filmClassModelDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    for (SCFilmClassModel *filmClassModel in self.filmClassArray) {
        NSString *key = filmClassModel._FilmClassName;
        [_filmClassModelDictionary setObject:filmClassModel forKey:key];
    }
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
        
        DONG_Log(@"====FilmClassUrl::::%@",filmClassModel._FilmClassName);
        
        DONG_Log(@"====FilmClassUrl::::%@",filmClassModel.FilmClassUrl);
        
        SCChannelCategoryVC *channelVC  = [[SCChannelCategoryVC alloc] initWithWithTitle:filmClassModel._FilmClassName];
        channelVC.filmClassModel = filmClassModel;
        channelVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:channelVC animated:YES];
        
    }
}

#pragma mark ---- UICollectionView  DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _titleArray.count+1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0){
        return 8;
    }else{
        
        SCFilmClassModel *model = _filmClassArray[section-1];
        return model.filmArray.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCDemandChannelItemCell *cell = [SCDemandChannelItemCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        NSArray *array = self.filmClassTitleArray? self.filmClassTitleArray : self.allItemsArr;
        [cell setModel:array IndexPath:indexPath];
        return cell;
        
    }else{
        
        SCFilmClassModel *classModel = _filmClassArray[indexPath.section-1];
        SCFilmModel *filmModel = classModel.filmArray[indexPath.row];
        
        SCCollectionViewPageCell *cell = [SCCollectionViewPageCell cellWithCollectionView:collectionView identifier:classModel._FilmClassName indexPath:indexPath];
        //cell.backgroundColor = [UIColor purpleColor];
        
        cell.model = filmModel;
        //NSLog(@">>>>>>>>>_SourceUrl:::%@",filmModel.SourceUrl);
        return cell;
        
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        // 顶部点播栏cell大小
        return (CGSize){(kMainScreenWidth-10-15)/4,70};
        
    }else{
        // 综艺栏目cell大小
        SCFilmClassModel *classModel = _filmClassArray[indexPath.section-1];
        if ([classModel._FilmClassName isEqualToString:@"综艺"] || [classModel._FilmClassName isEqualToString:@"生活"] || [classModel._FilmClassName isEqualToString:@"专题"]) {
            return (CGSize){(kMainScreenWidth-24-10)/2,((kMainScreenWidth-24-10)/2/1.8)+30};//横版尺寸
            
        }else{
            return (CGSize){(kMainScreenWidth-24-30)/3,(kMainScreenWidth-24-30)*33/3/24+30};//竖版尺寸
        }
    }
}

/** Section 四周间距 EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0){
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }else{
        return UIEdgeInsetsMake(5, 12, 5, 12);
    }
    
}

/** item水平间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
}

/** item垂直间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0){
        return 5;
    }else{
        return 0;
    }
}

/** section Header 尺寸 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return (CGSize){kMainScreenWidth,0};
    }else{
        return (CGSize){kMainScreenWidth,50};
    }
}

/** section Footer 尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){kMainScreenWidth,0};
}

#pragma mark ---- UICollectionView DataDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {//点播栏
        if (_filmClassArray.count == 0) {
            [MBProgressHUD showSuccess:@"暂无数据，请稍后再试"];
            return;
        }
        //设置返回键标题
        if (indexPath.row == 7) {//更多
            SCChannelCatalogueVC *moreView = [[SCChannelCatalogueVC alloc] initWithWithTitle:@"更多"];
            moreView.filmClassArray = [NSMutableArray arrayWithArray:_filmClassArray];
            moreView.bannerFilmModelArray = _bannerFilmModelArr;
            
            NSArray *filmClassTitleArray = [[NSUserDefaults standardUserDefaults] objectForKey:kFilmClassTitleArray];// NSUserDefaults 只能读取不可变对象
            moreView.filmClassTitleArray = [NSMutableArray arrayWithArray:filmClassTitleArray];
            moreView.refreshHomePageBlock = ^{
                [self setFilmClassTitleArray];//刷新section 0
            };
            moreView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreView animated:YES];
            
        }else if (indexPath.row == 0) {//直播
            SCLiveViewController *liveView = [[SCLiveViewController alloc] initWithWithTitle:@"直播"];
            liveView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:liveView animated:YES];
            
        }else{//其他
            NSString *key = _filmClassTitleArray[indexPath.row-1];
            SCChannelCategoryVC *channelVC  = [[SCChannelCategoryVC alloc] initWithWithTitle:key];
            channelVC.filmClassModel = _filmClassModelDictionary[key];
            channelVC.bannerFilmModelArray = _bannerFilmModelArr;
            channelVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:channelVC animated:YES];
        }
        
    }else{
        
        SCFilmClassModel *classModel = _filmClassArray[indexPath.section-1];
        SCFilmModel *filmModel = classModel.filmArray[indexPath.row];
        if ([classModel._FilmClassName isEqualToString:@"专题"]) {
            SCSpecialTopicDetailVC *vc = [[SCSpecialTopicDetailVC alloc] initWithWithTitle:filmModel.FilmName];
            vc.urlString = filmModel.SourceUrl;
            vc.bannerFilmModelArray = _bannerFilmModelArr;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            SCPlayerViewController *teleplayPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
            teleplayPlayer.filmModel = filmModel;
            teleplayPlayer.bannerFilmModelArray = _bannerFilmModelArr;
            teleplayPlayer.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:teleplayPlayer animated:YES];
            
        }
        
    }
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    SCFilmModel *filmModel = _bannerFilmModelArr[index];
    SCPlayerViewController *VODPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
    VODPlayer.filmModel = filmModel;
    VODPlayer.bannerFilmModelArray = _bannerFilmModelArr;
    VODPlayer.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VODPlayer animated:YES];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    // NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
}

#pragma mark- Getters and Setters
- (NSMutableArray *)allItemsArr{
    if (!_allItemsArr) {
        NSArray *array =@[@"排行榜",@"私人影院", @"少儿剧场", @"院线热映", @"电影", @"电视剧", @"更多", @"少儿", @"动漫", @"综艺", @"生活", @"游戏", @"纪录片", @"音乐", @"专题"];
        
        _allItemsArr = [NSMutableArray arrayWithCapacity:0];
        [_allItemsArr addObjectsFromArray:array];
    }
    return _allItemsArr;
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate{
    return NO;
}

@end
