//
//  SCCollectionViewPageVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/2.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  film展示页 重复利用率非常高

#import "SCCollectionViewPageVC.h"
#import "SCCollectionViewPageCell.h"
#import "SCNetRequsetManger.h"
#import "SCFilmModel.h"
#import "SCFilmClassModel.h"
#import "SCPlayerViewController.h"
#import "SCFilmClassModel.h"
#import "SCSpecialTopicDetailVC.h"// 专题详情页

@interface SCCollectionViewPageVC () <UIAlertViewDelegate>

/** 每页电影模型数组 */
@property (nonatomic, strong) NSMutableArray *filmModelArr;
/** ip转换工具 */
@property (nonatomic, strong) HLJRequest *hljRequest;
/**< 分页的页码 */
@property (nonatomic,assign) NSInteger page;
/** 非wifi弹出alert时存储filmModel */
@property (nonatomic, strong) SCFilmModel *alertViewClickFilmModel;

@end

@implementation SCCollectionViewPageVC

static NSString *const cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //0.初始化collectionView
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical=YES;
    // 注册cell、sectionHeader、sectionFooter
    // 普通栏目cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"SCCollectionViewPageCell" bundle:nil] forCellWithReuseIdentifier:@"SCCollectionViewPageCell"];
    // 综艺栏目cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"SCCollectionViewPageArtsCell" bundle:nil] forCellWithReuseIdentifier:@"SCCollectionViewPageArtsCell"];
    
    //1.初始化数组
    self.filmModelArr = [NSMutableArray arrayWithCapacity:0];
    
    //2.集成刷新
    [self setCollectionViewRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 集成刷新
- (void)setCollectionViewRefresh {
    [CommonFunc setupRefreshWithView:self.collectionView withSelf:self headerFunc:@selector(headerRefresh) headerFuncFirst:YES footerFunc:@selector(loadMoreData)];
}

- (void)headerRefresh {
    _page = 1;
    [self requestDataWithPage:_page];
}

- (void)loadMoreData {
    
    _page++;
    
    DONG_Log(@"_PageCount:%@ page:%ld",_pageCount, (long)_page);
    
    if (_page <= [_pageCount intValue] ) {
       
        [self requestDataWithPage:_page];
        
    } else {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }
    
}

- (void)requestDataWithPage:(NSInteger)page {
    
    NSDictionary *parameters = @{@"page" : [NSString stringWithFormat:@"%zd",page]};

    //域名转IP
    self.hljRequest = [HLJRequest requestWithPlayVideoURL:_urlString];
    [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
        [requestDataManager requestFilmClassDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
            NSLog(@">>>>>>>>>>>>responseObject::::%@",responseObject);
            
            if (page == 1) {
                [_filmModelArr removeAllObjects];
            }

            if (responseObject) {
                if (responseObject[@"FilmClass"]) {// 专题页面(比其他多一层)
                    
                    NSArray *filmsArr = responseObject[@"FilmClass"];
                    for (NSDictionary *dic in filmsArr) {
                        SCFilmClassModel *filmClassModel = [SCFilmClassModel mj_objectWithKeyValues:dic];
                        [_filmModelArr addObject:filmClassModel];
                    }
                    [self.collectionView reloadData];
                    [self.collectionView.mj_header endRefreshing];
                    [self.collectionView.mj_footer endRefreshing];
                    [CommonFunc dismiss];
                    
                } else {// 其他电影 电视剧等
                    
                    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                    [array removeAllObjects];
                    [array addObjectsFromArray:responseObject[@"Film"]];
                    
//                    NSArray *filmsArr = responseObject[@"Film"];
                    
                    for (NSDictionary *dic in array) {
                        SCFilmModel *filmModel = [SCFilmModel mj_objectWithKeyValues:dic];
                        [_filmModelArr addObject:filmModel];
                    }
                    [self.collectionView reloadData];
                    [self.collectionView.mj_header endRefreshing];
                    [self.collectionView.mj_footer endRefreshing];
                    [CommonFunc dismiss];
                }
            }
            //将mtype回传给上个控制器  （发现传不传没有影响 传时因数据结构缺陷还会有bug）
            //        SCFilmModel *filmModel = [_filmModelArr firstObject];
            //        NSString *mType = filmModel.mtype? filmModel.mtype : filmModel._Mtype;
            //        self.getMtype(mType);
            
        } failure:^(id  _Nullable errorObject) {
            
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [CommonFunc dismiss];
        }];
        
    } failure:^(NSError *error) {
        [CommonFunc dismiss];
    }];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _filmModelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_filmModelArr[indexPath.row] isKindOfClass:[SCFilmModel class]]) {
        // 适合只有一级目录就进入详情的入口
        SCCollectionViewPageCell *cell = [SCCollectionViewPageCell cellWithCollectionView:collectionView identifier:self.FilmClassModel._FilmClassName indexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
//        if ([_FilmClassModel._FilmClassName isEqualToString:@"专题"] ) {
//            
//            SCFilmModel *filmModel = _filmModelArr[indexPath.row];
//            filmModel.scale = @"专题";
//            cell.model = filmModel;
//            return cell;
//            
//        }
        
        SCFilmModel *filmModel = _filmModelArr[indexPath.row];
        cell.model = filmModel;
        return cell;
        
    } else if ([_filmModelArr[indexPath.row] isKindOfClass:[SCFilmClassModel class]]) {
        
        // 更多分类中专题横版（有下一级目录）
        static NSString * const identifier = @"专题";
        SCCollectionViewPageCell *cell = [SCCollectionViewPageCell cellWithCollectionView:collectionView identifier:identifier indexPath:indexPath];
        SCFilmClassModel *filmClassModel = _filmModelArr[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.filmClassModel = filmClassModel;
        return cell;
    }
    
    return nil;
}

#pragma mark - <UICollectionViewDelegate>
#pragma mark - UICollectionViewDelegateFlowLayout
/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_filmModelArr[indexPath.row] isKindOfClass:[SCFilmModel class]]) {
        if ([_FilmClassModel._FilmClassName isEqualToString:@"综艺"] || [_FilmClassModel._FilmClassName isEqualToString:@"潮生活"]) {
            return (CGSize){(kMainScreenWidth-24-10)/2,((kMainScreenWidth-24-10)/2/1.8)+30};//横版尺寸
        
        } else {
            
            if ([_FilmClassModel._FilmClassName isEqualToString:@"专题"] ) {
                // 专题推荐横版
                return (CGSize){(kMainScreenWidth-24-10)/2,((kMainScreenWidth-24-10)/2/1.8)+30};//横版尺寸
                
            } else {
            
                 return (CGSize){(kMainScreenWidth-24-30)/3,(kMainScreenWidth-24-30)*33/3/24+30};//竖版尺寸
                
            }
            
        }
        
    } else { // 专题
        
        return (CGSize){(kMainScreenWidth-24-10)/2,((kMainScreenWidth-24-10)/2/1.8)+30};//横版尺寸
    }
}

/** CollectionView四周间距 EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 12, 5, 12);
}

/** item水平间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
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
    if ([_filmModelArr[indexPath.row] isKindOfClass:[SCFilmModel class]]) {
        
        BOOL mobileNetworkAlert = [DONG_UserDefaults boolForKey:kMobileNetworkAlert];
        
        if (![[SCNetHelper getNetWorkStates] isEqualToString:@"WIFI"] && mobileNetworkAlert) {
           
            self.alertViewClickFilmModel = _filmModelArr[indexPath.row];;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前为移动网络，继续播放将消耗流量" delegate:nil cancelButtonTitle:@"取消播放" otherButtonTitles:@"确认播放", nil];
            [alertView show];
            alertView.delegate = self;
            
        } else {
            
            SCPlayerViewController *teleplayPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
            SCFilmModel *model = _filmModelArr[indexPath.row];
            teleplayPlayer.filmModel = model;
            teleplayPlayer.bannerFilmModelArray = self.bannerFilmModelArray;
            NSLog(@"======点击=====%@",model._Mtype);
            teleplayPlayer.hidesBottomBarWhenPushed = YES;
            
            if (self.navigationController) {
                [self.navigationController pushViewController:teleplayPlayer animated:YES];
            }else{
                [[self respondController].navigationController pushViewController:teleplayPlayer animated:YES];
            }
        }

    } else { // 专题第一级页面点击
        
        SCFilmClassModel *filmClassModel = _filmModelArr[indexPath.row];
        SCSpecialTopicDetailVC *vc = [[SCSpecialTopicDetailVC alloc] initWithWithTitle:filmClassModel._FilmClassName];
        vc.urlString = filmClassModel._FilmClassUrl;
        vc.bannerFilmModelArray = self.bannerFilmModelArray;
        [self.navigationController pushViewController:vc animated:YES];
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
        SCFilmModel *model = self.alertViewClickFilmModel;
        teleplayPlayer.filmModel = model;
        teleplayPlayer.bannerFilmModelArray = self.bannerFilmModelArray;
        NSLog(@"======点击=====%@",model._Mtype);
        teleplayPlayer.hidesBottomBarWhenPushed = YES;
        
        if (self.navigationController) {
            [self.navigationController pushViewController:teleplayPlayer animated:YES];
        }else{
            [[self respondController].navigationController pushViewController:teleplayPlayer animated:YES];
        }
        
    }
}


- (UIViewController *)respondController
{
    UIViewController *vc = nil;
    do {
        if (!vc) {
            vc = (UIViewController *)self.nextResponder;
        } else {
            vc = (UIViewController *)vc.nextResponder;
        }
    } while(![vc isKindOfClass:[UIViewController class]]);
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        return vc;
    } else {
        return nil;
    }
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}


@end
