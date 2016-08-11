//
//  SCCollectionViewPageVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/2.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCCollectionViewPageVC.h"
#import "SCCollectionViewPageCell.h"
#import "SCNetRequsetManger.h"
#import "SCFilmModel.h"
#import "SCFilmClassModel.h"
#import "SCPlayerViewController.h"
#import "SCFilmClassModel.h"
#import "SCSpecialTopicDetailVC.h"// 专题详情页

@interface SCCollectionViewPageVC ()

/** 每页电影模型数组 */
@property (nonatomic, strong) NSMutableArray *filmModelArr;


@end

@implementation SCCollectionViewPageVC

static NSString *const cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //0.初始化collectionView
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical=YES;
    // 注册cell、sectionHeader、sectionFooter
    [self.collectionView registerNib:[UINib nibWithNibName:@"SCCollectionViewPageCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    
    //1.初始化数组
    
    //3.集成刷新
    [self setCollectionViewRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 集成刷新
- (void)setCollectionViewRefresh {
    [CommonFunc setupRefreshWithView:self.collectionView withSelf:self headerFunc:@selector(headerRefresh) headerFuncFirst:YES footerFunc:nil];
}

- (void)headerRefresh {
    
    [self requestData];
    
}

- (void)requestData{
    
    if (_filmModelArr) {
        [_filmModelArr removeAllObjects];
    }else if (!_filmModelArr){
        _filmModelArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    [requestDataManager requestFilmClassDataWithUrl:_urlString parameters:nil success:^(id  _Nullable responseObject) {
        
        NSLog(@">>>>>>>>>>>>responseObject::::%@",responseObject);
        if (responseObject) {
            if (responseObject[@"FilmClass"]) {// 专题页面(比其他多一层)
                
                NSArray *filmsArr = responseObject[@"FilmClass"];
                [_filmModelArr removeAllObjects];
                
                for (NSDictionary *dic in filmsArr) {
                    
                    SCFilmClassModel *filmClassModel = [SCFilmClassModel mj_objectWithKeyValues:dic];
                    
                    [_filmModelArr addObject:filmClassModel];
                }
                
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
                [CommonFunc dismiss];
                
            }else{// 其他
                
                NSArray *filmsArr = responseObject[@"Film"];
                [_filmModelArr removeAllObjects];
                
                for (NSDictionary *dic in filmsArr) {
                    SCFilmModel *filmModel = [SCFilmModel mj_objectWithKeyValues:dic];
                    
                    [_filmModelArr addObject:filmModel];
                }
                //        NSLog(@">>>>>>>>>>>>22222::::%ld",_filmModelArr.count);
                
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
                
                [CommonFunc dismiss];
            }
        }
        
    } failure:^(id  _Nullable errorObject) {
        [self.collectionView.mj_header endRefreshing];
        [CommonFunc dismiss];
    }];
    
}

#pragma mark <UICollectionViewDataSource>

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
    SCCollectionViewPageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if ([_filmModelArr[indexPath.row] isKindOfClass:[SCFilmModel class]]) {
        
        cell.model = _filmModelArr[indexPath.row];
        
    }else{
        
        cell.filmClassModel = _filmModelArr[indexPath.row];
        
    }
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>

#pragma mark ---- UICollectionViewDelegateFlowLayout
/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return (CGSize){(kMainScreenWidth-24-16)/3,180};
}

/** CollectionView四周间距 EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 12, 5, 12);
}

/** item水平间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

/** item垂直间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.f;
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_filmModelArr[indexPath.row] isKindOfClass:[SCFilmModel class]]) {
        
        SCPlayerViewController *teleplayPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
        SCFilmModel *model = _filmModelArr[indexPath.row];
        teleplayPlayer.filmModel = model;
        NSLog(@"======点击=====%@",model._Mtype);
        teleplayPlayer.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:teleplayPlayer animated:YES];
        [[self respondController].navigationController pushViewController:teleplayPlayer animated:YES];
        
    }else{// 专题第一级页面点击
        
        SCFilmClassModel *filmClassModel = _filmModelArr[indexPath.row];
        SCSpecialTopicDetailVC *vc = [[SCSpecialTopicDetailVC alloc] initWithWithTitle:filmClassModel._FilmClassName];
        vc.urlString = filmClassModel._FilmClassUrl;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (UIViewController *)respondController
{
    UIViewController *vc = nil;
    
    do {
        if (!vc) {
            vc = (UIViewController *)self.nextResponder;
        }else{
            vc = (UIViewController *)vc.nextResponder;
        }
        
    }while(![vc isKindOfClass:[UIViewController class]]);
    if ([vc isKindOfClass:[UIViewController class]]) {
        return vc;
    }else{
        return nil;
    }
}


@end
