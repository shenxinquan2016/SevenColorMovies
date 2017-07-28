//
//  SCHomePageViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCHomePageViewController.h"
#import "AppDelegate.h"
#import "SCSycleBanner.h"
#import "SCDemandChannelItemCell.h" // section 0 cell
#import "SCCollectionViewPageCell.h" // 其他cell
#import "SCHomePageFlowLayout.h"
#import "SCHomePageSectionBGReusableView.h" // senction header
#import "SCChannelCatalogueVC.h" // 点播栏目更多
#import "SCChannelCategoryVC.h" // 节目频道分类
#import "SCLiveViewController.h" // 直播首页面
#import "SCPlayerViewController.h"
#import "SCBannerModel.h"
#import "SCFilmListModel.h"
#import "SCFilmClassModel.h"
#import "SCFilmModel.h"
#import "SCSpecialTopicDetailVC.h"
#import "SCAdvertisementModel.h"


@interface SCHomePageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, SDCycleScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UICollectionView *collView;

@property (nonatomic, copy) NSArray *dataSource; // tableView数据源
@property (nonatomic, strong) NSMutableArray *sectionArr; // tableView数据源
@property (nonatomic, strong) NSMutableArray *allItemsArr; // 点播栏所有item
@property (nonatomic, strong) SCSycleBanner *bannerView;
@property (nonatomic, strong) NSMutableArray *bannerImageUrlArr; // banner页图片地址数组
@property (nonatomic, strong) NSMutableArray *bannerFilmModelArr; // banner filmModel数组
@property (nonatomic, strong) NSMutableArray *filmClassArray; // 首页展示
@property (nonatomic, strong) NSMutableArray *allFilmClassArray; // 全部数据
@property (nonatomic, strong) NSMutableArray *allTitleArray; // 由filmClass剥离出的标题
@property (nonatomic, copy) NSArray *filmClassTitleArray; // 将filmClass的标题存到本地
@property (nonatomic, strong) HLJRequest *hljRequest; // ip转换
@property (nonatomic, strong) SCFilmModel *alertViewClickFilmModel; // 非wifi弹出alert时存储filmModel

@property (nonatomic, strong) UIImageView *adImageView; // 浮窗广告
@property (nonatomic, strong) SCAdvertisementModel *floatingAdModel; // 浮窗广告model

@end

@implementation SCHomePageViewController
{
    NSMutableDictionary *_filmClassModelDictionary; // 将filmClassModel与filmClassName绑定
}

static NSString *const cellId = @"cellId";
static NSString *const cellIdOther = @"cellIdOther";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

#pragma mark -  ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:@"#dddddd"];
    // 0. 设置导航栏的颜色(效果只作用当前页面）
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:@"#F0F1F2"]];
    
    // 1.初始化数组
    self.filmClassArray = [NSMutableArray arrayWithCapacity:0];
    self.bannerImageUrlArr = [NSMutableArray arrayWithCapacity:0];
    self.bannerFilmModelArr = [NSMutableArray arrayWithCapacity:0];
    self.allFilmClassArray = [NSMutableArray arrayWithCapacity:0];
    self.allTitleArray = [NSMutableArray arrayWithCapacity:0];
    _filmClassModelDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    
    // 2.设置导航栏的颜色（效果作用到所有页面）
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor colorWithHex:@"#F1F1F1"]];
    
    // 3.添加collectionView
    [self addCollView];
    // 4.浮窗广告
    //[self setFloatingAdvertisement];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- Initialize

#pragma mark- Private methods

- (void)addCollView
{
    SCHomePageFlowLayout *layout = [[SCHomePageFlowLayout alloc] init]; // 布局对象
    layout.alternateDecorationViews = YES;
    // 读取xib背景
    layout.decorationViewOfKinds = @[@"SCHomePageSectionBGReusableView"];
    
    _collView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    
    _collView.alwaysBounceVertical=YES;
    _collView.dataSource = self;
    _collView.delegate = self;
    
    _collView.contentInset = UIEdgeInsetsMake(165, 0, 49, 0); // 留白添加banner
    // 无banner时的占位图
    UIView *noBannerView = [[UIView alloc] initWithFrame:CGRectMake(0, -157, kMainScreenWidth, 157)];
    UIImageView *NoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoBanner"]];
    [noBannerView addSubview:NoImageView];
    [NoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(noBannerView);
    }];
    
    [_collView addSubview:noBannerView];
    
    // 注册cell、sectionHeader、sectionFooter
    // 点播栏cell
    [_collView registerNib:[UINib nibWithNibName:@"SCDemandChannelItemCell" bundle:nil] forCellWithReuseIdentifier:@"SCDemandChannelItemCell"];
    // 普通栏目cell
    [_collView registerNib:[UINib nibWithNibName:@"SCCollectionViewPageCell" bundle:nil] forCellWithReuseIdentifier:@"SCCollectionViewPageCell"];
    // 综艺栏目cell
    [_collView registerNib:[UINib nibWithNibName:@"SCCollectionViewPageArtsCell" bundle:nil] forCellWithReuseIdentifier:@"SCCollectionViewPageArtsCell"];
    
    [_collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [_collView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
    [self.view addSubview:self.collView];
    
    // 2.集成刷新
    [self setCollectionViewRefresh];
    
}

// json格式字符串转字典：
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if(err) {
        DONG_Log(@"json解析失败：%@",err);
        return nil;
    }
    return dict;
}

#pragma mark - 集成刷新

- (void)setCollectionViewRefresh
{
    [CommonFunc setupRefreshWithCollectionViewWithBanner:_collView withSelf:self headerFunc:@selector(headerRefresh) headerFuncFirst:YES footerFunc:nil];
}

- (void)headerRefresh
{
    [self requestData];
}

- (void)requestData
{
    [requestDataManager requestDataWithUrl:JuHeEntrance parameters:nil success:^(id  _Nullable responseObject) {
        //                DONG_Log(@"==========dic:::%@========",responseObject);
        [_filmClassArray removeAllObjects];
        [_bannerImageUrlArr removeAllObjects];
        [_bannerFilmModelArr removeAllObjects];
        [_allFilmClassArray removeAllObjects];
        [_filmClassModelDictionary removeAllObjects];
        
        // 1.第一层 filmList
        SCFilmListModel *filmListModel = [SCFilmListModel mj_objectWithKeyValues:responseObject];
        
        for (SCFilmClassModel *classModel in filmListModel.filmClassArray) {
            
            if (![classModel._FilmClassName hasSuffix:@"今日推荐"]) {
                
                // 全部数据
                [_allFilmClassArray addObject:classModel];
                [_allTitleArray addObject:classModel._FilmClassName];
                [_filmClassModelDictionary setObject:classModel forKey:classModel._FilmClassName];
                
                if (![classModel._FilmClassName hasSuffix:@"直播"] && ![classModel._FilmClassName hasSuffix:@"省政府"] && ![classModel._FilmClassName hasSuffix:@"营业厅"] && ![classModel._FilmClassName hasSuffix:@"先锋网"] && ![classModel._FilmClassName hasSuffix:@"旅游网"] && ![classModel._FilmClassName hasSuffix:@"图片链接"] && ![classModel._FilmClassName hasSuffix:@"龙江网络"] && ![classModel._FilmClassName hasSuffix:@"下载链接"]) {
                    // 首页展示数据
                    [_filmClassArray addObject:classModel];
                }
                
                //                NSLog(@">>>>>>>>homePageData:::%@",classModel._FilmClassName);
                //                NSLog(@"====FilmClassUrl::::%@",classModel.FilmClassUrl);
                
            } else if ([classModel._FilmClassName hasSuffix:@"今日推荐"]) {
                
                // 添加banner
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
                    
                    // 全局共享bannerFilmModelArr
                    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
                    app.bannerFilmModelArray = _bannerFilmModelArr;
                    
                    // 添加banner
                    if (_bannerImageUrlArr.count > 0) {
                        
                        [self addBannerView];
                        _bannerView.imageURLStringsGroup = _bannerImageUrlArr;
                        
                    } else if (_bannerImageUrlArr.count == 0) {
                        
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
    
    NSArray *filmClassTitleArray = [[NSUserDefaults standardUserDefaults] objectForKey:kFilmClassTitleArray]; // NSUserDefaults 只能读取不可变对象
    
    if (filmClassTitleArray.count == 0) {
        
        NSArray *array = [NSArray arrayWithArray:self.allTitleArray]; // NSUserDefaults 只能读取不可变对象
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:kFilmClassTitleArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.filmClassTitleArray = self.allTitleArray;
        [_collView reloadData];
        
    } else {
        
        // 谓词判断：A中元素不包含在B中的个数为0切B中元素不包含在A中的个数为0，则两个数组元素相同
        if ([filmClassTitleArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF in %@)", self.allTitleArray]].count == 0 && [self.allTitleArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF in %@)", filmClassTitleArray]].count == 0) {//本地保存的和新请求到的相同时
            
            self.filmClassTitleArray = filmClassTitleArray;
            [_collView reloadData];
            
        } else {
            // 本地保存的和新请求到的不同时
            NSArray *array = [NSArray arrayWithArray:self.allTitleArray];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:kFilmClassTitleArray];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.filmClassTitleArray = self.allTitleArray;
            [_collView reloadData];
        }
    }
    
}

// section header
- (UIView *)addSectionHeaderViewWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIView *view = [[UIImageView alloc] init];
    view.frame = CGRectMake(0, 10, kMainScreenWidth, 40.f);
    view.backgroundColor = [UIColor whiteColor];
    // 图标
    UIImageView *iv = [[UIImageView alloc] init];
    [iv setImage:[UIImage imageNamed:@"SectionLeftImage"]];
    [view addSubview:iv];
    [iv mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(iv.image.size);
    }];
    // 标题label
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
    // 右侧btn
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

- (void)addBannerView
{
    _bannerView = [[SCSycleBanner alloc] initWithView:nil];
    _bannerView.delegate = self;
    [_collView addSubview:_bannerView];
}

#pragma mark - responce

- (void)sectionClick:(UIButton *)sender
{
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

#pragma mark - UICollectionView  DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _filmClassArray.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_filmClassArray.count > 8) {
            return 8;
        } else {
            return _filmClassArray.count;
        }
        
    } else {
        
        SCFilmClassModel *filmClassModel = _filmClassArray[section-1];
        if ([filmClassModel._FilmClassName isEqualToString:@"综艺"] || [filmClassModel._FilmClassName isEqualToString:@"潮生活"] || [filmClassModel._FilmClassName isEqualToString:@"专题"])  {
            
            if (filmClassModel.filmArray.count < 6) {
                return filmClassModel.filmArray.count;
            } else {
                return 6;
            }
            
        } else {
            
            if (filmClassModel.filmArray.count < 9) {
                return filmClassModel.filmArray.count;
            } else {
                return 9;
            }
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCDemandChannelItemCell *cell = [SCDemandChannelItemCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        
        NSArray *array = self.filmClassTitleArray;
        cell.filmClassModelDictionary = _filmClassModelDictionary;
        [cell setModel:array IndexPath:indexPath];
        
        return cell;
        
    } else {
        
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

// section header view
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        if (headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
        //headerView.backgroundColor = [UIColor purpleColor];
        SCFilmClassModel *filmClassModel = _filmClassArray[indexPath.section-1];
        UIView *view = [self addSectionHeaderViewWithTitle:filmClassModel._FilmClassName tag:indexPath.section-1];
        [headerView addSubview:view];
        return headerView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        if (footerView == nil)
        {
            footerView = [[UICollectionReusableView alloc] init];
        }
        footerView.backgroundColor = [UIColor lightGrayColor];
        
        return footerView;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        // 顶部点播栏cell大小
        return (CGSize){(kMainScreenWidth-10-15)/4,70};
        
    } else {
        // 综艺栏目cell大小
        SCFilmClassModel *classModel = _filmClassArray[indexPath.section-1];
        if ([classModel._FilmClassName isEqualToString:@"综艺"] || [classModel._FilmClassName isEqualToString:@"潮生活"] || [classModel._FilmClassName isEqualToString:@"专题"]) {
            return (CGSize){(kMainScreenWidth-24-10)/2,((kMainScreenWidth-24-10)/2/1.8)+30};//横版尺寸
            
        }else{
            return (CGSize){(kMainScreenWidth-24-30)/3,(kMainScreenWidth-24-30)*33/3/24+30};//竖版尺寸
        }
    }
}

/** Section 四周间距 EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    } else {
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
    if (section == 0) {
        return 5;
    } else {
        return 0;
    }
}

/** section Header 尺寸 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return (CGSize){kMainScreenWidth,0};
    } else {
        return (CGSize){kMainScreenWidth,50};
    }
}

/** section Footer 尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){kMainScreenWidth,0};
}

#pragma mark - UICollectionView DataDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // 点播栏
        if (_filmClassTitleArray.count == 0) {
            [MBProgressHUD showSuccess:@"暂无数据，请稍后再试"];
            return;
        }
        NSString *titleString = _filmClassTitleArray[indexPath.row];
        SCFilmClassModel *filmClassModel = [_filmClassModelDictionary objectForKey:titleString];
        
        if (indexPath.row == 7) { // 更多
            
            SCChannelCatalogueVC *moreView = [[SCChannelCatalogueVC alloc] initWithWithTitle:@"更多"];
            moreView.bannerFilmModelArray = _bannerFilmModelArr;
            moreView.filmClassModelDictionary = _filmClassModelDictionary;
            
            NSArray *filmClassTitleArray = [[NSUserDefaults standardUserDefaults] objectForKey:kFilmClassTitleArray]; // NSUserDefaults 只能读取不可变对象
            moreView.filmClassTitleArray = [NSMutableArray arrayWithArray:filmClassTitleArray];
            moreView.refreshHomePageBlock = ^{
                [self setFilmClassTitleArray]; // 刷新section 0
            };
            moreView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:moreView animated:YES];
            
        } else if ([filmClassModel._dataType isEqualToString:@"app"]) {
            
            // 数据采集
            [UserInfoManager addCollectionDataWithType:@"FilmClass" filmName:filmClassModel._FilmClassName mid:@"app"];
            
            NSDictionary *dict = [self dictionaryWithJsonString:filmClassModel.FilmClassUrl];
            NSString *urlSchemes = dict[@"openUrl"][@"urlSchemes"];
            
            if ([urlSchemes isEqualToString:@"sevencolormovies"] && [filmClassModel._FilmClassName isEqualToString:@"直播"]) {
                
                SCLiveViewController *liveView = [[SCLiveViewController alloc] initWithWithTitle:@"直播"];
                liveView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:liveView animated:YES];
                
            } else { // 其他APP
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlSchemes]];
            }
            
        } else if ([filmClassModel._dataType isEqualToString:@"web"]) {
            
            // web网页
            if (filmClassModel.FilmClassUrl == nil) return;
            NSDictionary *dict = [self dictionaryWithJsonString:filmClassModel.FilmClassUrl];
            // 数据采集
            NSString *keyValue = @"web";
            [UserInfoManager addCollectionDataWithType:@"FilmClass" filmName:filmClassModel._FilmClassName mid:keyValue];
            
            NSString *urlString = dict[@"webUrl"];
            NSURL *url = [NSURL URLWithString:urlString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                [[UIApplication sharedApplication] openURL:url];
                
            } else {
                
                DONG_Log(@"can not open");
            }
            
        } else if ([filmClassModel._dataType isEqualToString:@""]) {
            
            SCChannelCategoryVC *channelVC  = [[SCChannelCategoryVC alloc] initWithWithTitle:filmClassModel._FilmClassName];
            channelVC.filmClassModel = filmClassModel;
            channelVC.bannerFilmModelArray = _bannerFilmModelArr;
            channelVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:channelVC animated:YES];
        }
        
    } else {
        
        SCFilmClassModel *classModel = _filmClassArray[indexPath.section-1];
        SCFilmModel *filmModel = classModel.filmArray[indexPath.row];
        
        if ([classModel._FilmClassName isEqualToString:@"专题"]) {
            // 数据采集
            NSString *keyValue = @"subjectcate";
            [UserInfoManager addCollectionDataWithType:@"FilmClass" filmName:classModel._FilmClassName mid:keyValue];
            SCSpecialTopicDetailVC *vc = [[SCSpecialTopicDetailVC alloc] initWithWithTitle:filmModel.FilmName];
            vc.hidesBottomBarWhenPushed = YES;
            vc.urlString = filmModel.SourceUrl;
            vc.bannerFilmModelArray = _bannerFilmModelArr;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            
            BOOL mobileNetworkAlert = [DONG_UserDefaults boolForKey:kMobileNetworkAlert];
            
            if (![[SCNetHelper getNetWorkStates] isEqualToString:@"WIFI"] && mobileNetworkAlert) {
                
                self.alertViewClickFilmModel = filmModel;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前为移动网络，继续播放将消耗流量" delegate:nil cancelButtonTitle:@"取消播放" otherButtonTitles:@"确认播放", nil];
                [alertView show];
                alertView.delegate = self;
                
            } else {
                
                SCPlayerViewController *teleplayPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
                teleplayPlayer.filmModel = filmModel;
                teleplayPlayer.bannerFilmModelArray = _bannerFilmModelArr;
                teleplayPlayer.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:teleplayPlayer animated:YES];
                
            }
            [DONG_UserDefaults setBool:mobileNetworkAlert forKey:kMobileNetworkAlert];
            [DONG_UserDefaults synchronize];
        }
    }
}

#pragma mark - SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BOOL mobileNetworkAlert = [DONG_UserDefaults boolForKey:kMobileNetworkAlert];
    
    if (![[SCNetHelper getNetWorkStates] isEqualToString:@"WIFI"] && mobileNetworkAlert) {
        
        self.alertViewClickFilmModel = _bannerFilmModelArr[index];;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前为移动网络，继续播放将消耗流量" delegate:nil cancelButtonTitle:@"取消播放" otherButtonTitles:@"确认播放", nil];
        [alertView show];
        alertView.delegate = self;
        
    } else {
        
        SCFilmModel *filmModel = _bannerFilmModelArr[index];
        SCPlayerViewController *VODPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
        VODPlayer.filmModel = filmModel;
        VODPlayer.bannerFilmModelArray = _bannerFilmModelArr;
        VODPlayer.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VODPlayer animated:YES];
        
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        BOOL mobileNetworkAlert = NO;
        [DONG_UserDefaults setBool:mobileNetworkAlert forKey:kMobileNetworkAlert];
        [DONG_UserDefaults synchronize];
        
        SCPlayerViewController *teleplayPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
        teleplayPlayer.filmModel = self.alertViewClickFilmModel;
        teleplayPlayer.bannerFilmModelArray = _bannerFilmModelArr;
        teleplayPlayer.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:teleplayPlayer animated:YES];
        
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    // NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
}

#pragma mark- Getters and Setters

- (NSMutableArray *)allItemsArr
{
    if (!_allItemsArr) {
        NSArray *array =@[@"电影", @"电视剧",  @"少儿", @"纪录片", @"潮生活", @"动漫", @"生活", @"游戏", @"音乐", @"专题", @"营业厅"];
        
        _allItemsArr = [NSMutableArray arrayWithCapacity:0];
        [_allItemsArr addObjectsFromArray:array];
    }
    return _allItemsArr;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - 广告

// 添加广告
- (void)setFloatingAdvertisement
{
    [requestDataManager getRequestJsonDataWithUrl:AdvertisementUrl parameters:nil success:^(id  _Nullable responseObject) {
        
        DONG_Log(@"responseObject-->%@", responseObject);
        NSArray *dataArr = (NSArray *)responseObject;
        
        for (NSDictionary *dict in dataArr) {
            if ([dict[@"adId"] isEqualToString:@"fc-ad"]) {
                
                SCAdvertisementModel *adModel = [SCAdvertisementModel mj_objectWithKeyValues:dict];
                self.floatingAdModel = adModel;
                DONG_Log(@"adName--->%@", adModel.adName);
                DONG_Log(@"openUrl--->%@", adModel.openUrl);
                DONG_Log(@"packageName--->%@", adModel.openUrl[@"packageName"]);
                
                NSString *adImageUrl = dict[@"imgUrl"];
                if (adImageUrl) {
                    // 1.广告图片
                    UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-kMainScreenWidth/3-49, kMainScreenWidth, kMainScreenWidth/3)];
                    [adImageView sd_setImageWithURL:[NSURL URLWithString:adImageUrl] placeholderImage:[UIImage imageNamed:@""]];
                    [adImageView setUserInteractionEnabled:YES];
                    // 2.点击手势
                    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAd)];
                    [adImageView addGestureRecognizer:singleTap];
                    // 3.删除按钮
                    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth-30, 10, 20, 20)];
                    deleteBtn.enlargedEdge = 20.f;
                    [deleteBtn setImage:[UIImage imageNamed:@"Delete"] forState:UIControlStateNormal];
                    
                    [deleteBtn addTarget:self action:@selector(deleteBtnCkick) forControlEvents:UIControlEventTouchUpInside];
                    [adImageView addSubview:deleteBtn];
                    self.adImageView = adImageView;
                    [self.view addSubview:adImageView];
                }
            }
        }
        
    } failure:^(id  _Nullable errorObject) {
        DONG_Log(@"errorObject-->%@", errorObject);
    }];
}

// 点击广告
- (void)clickAd
{
    [UIView animateWithDuration:0.2 animations:^{
        self.adImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.adImageView removeFromSuperview];
    }];
    
    // adType:web-->打开网页 adType:app-->打开app
    if ([_floatingAdModel.adType isEqualToString:@"web"]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_floatingAdModel.webUrl]];
        
    } else if ([_floatingAdModel.adType isEqualToString:@"app"]) {
        
        NSString *urlSchemes = _floatingAdModel.openUrl[@"urlSchemes"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlSchemes]];
        DONG_Log(@"urlSchemes-->%@", url);
        [[UIApplication sharedApplication] openURL:url];
    }
}

// 删除广告
- (void)deleteBtnCkick
{
    [UIView animateWithDuration:0.3 animations:^{
        self.adImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.adImageView removeFromSuperview];
    }];
}

@end
