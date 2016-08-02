//
//  SCCollectionViewPageVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/2.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCCollectionViewPageVC.h"
#import "SCRankTopRowCollectionViewCell.h"
#import "SCNetRequsetManger.h"
#import "SCFilmModel.h"

@interface SCCollectionViewPageVC ()

/** .每页电影模型数组 */
@property (nonatomic, strong) NSMutableArray *filmModelArr;

@end

@implementation SCCollectionViewPageVC

static NSString *const cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
  

    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical=YES;
    // 注册cell、sectionHeader、sectionFooter
    [self.collectionView registerNib:[UINib nibWithNibName:@"SCRankTopRowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    
    //1.初始化数组
    self.filmModelArr = [NSMutableArray arrayWithCapacity:0];
    
    
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager requestFilmClassDataWithUrl:_urlString parameters:nil success:^(id  _Nullable responseObject) {
        [CommonFunc dismiss];
        NSArray *filmsArr = responseObject[@"Film"];
        //                    NSLog(@">>>>>>>>>>>>%ld",filmsArr.count);
        //                    NSLog(@">>>>>>>>>>>>%@",filmsArr);
        
        [_filmModelArr removeAllObjects];
        //NSLog(@">>>>>>>>>>>>1111:::::%ld",_filmModelArr.count);
        for (NSDictionary *dic in filmsArr) {
            SCFilmModel *filmModel = [SCFilmModel mj_objectWithKeyValues:dic];
            //                NSLog(@">>>>>>>>>>>>%@",filmModel.FilmName);
            [_filmModelArr addObject:filmModel];
        }
        NSLog(@">>>>>>>>>>>>22222::::%ld",_filmModelArr.count);
        [self.collectionView reloadData];
    } failure:^(id  _Nullable errorObject) {
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _filmModelArr.count;
    return 10;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCRankTopRowCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    SCFilmModel *model = _filmModelArr[indexPath.row];
    cell.model = model;
    
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
        NSLog(@"======点击=====");
//    SCTeleplayPlayerVC *teleplayPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
//    teleplayPlayer.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:teleplayPlayer animated:YES];
    
}


- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}


@end