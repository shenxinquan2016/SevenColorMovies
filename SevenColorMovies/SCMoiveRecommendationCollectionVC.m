//
//  SCMoiveRecommendationCollectionVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/8.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCMoiveRecommendationCollectionVC.h"
#import "SCCollectionViewPageCell.h"
#import "SCPlayerViewController.h"


@interface SCMoiveRecommendationCollectionVC ()

/** 电影模型数组 */
@property (nonatomic, strong) NSMutableArray *filmModelArr;

@end


@implementation SCMoiveRecommendationCollectionVC

static NSString *const cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //0.初始化collectionView
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical=YES;
    // 注册cell、sectionHeader、sectionFooter
    [self.collectionView registerNib:[UINib nibWithNibName:@"SCCollectionViewPageCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    
    //1.初始化数组
    
    
    [self requestData];
    
}

- (void)requestData{
    
    [CommonFunc showLoadingWithTips:@""];
    
    if (_filmModelArr) {
        [_filmModelArr removeAllObjects];
    }else if (!_filmModelArr){
        _filmModelArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    
    NSString *mid;
    if (_filmModel._Mid) {
        mid = _filmModel._Mid;
    }else if (_filmModel.mid){
        mid = _filmModel.mid;
    }
    NSString *midstring = mid ? mid : @"";
    NSDictionary *parameters = @{@"mid" : midstring};

    [requestDataManager requestDataWithUrl:RecommendUrl parameters:parameters success:^(id  _Nullable responseObject) {
        NSLog(@"<<<<<<<<<<<<<responseObject:::%@",responseObject);
        if (responseObject) {
            
            NSArray *filmsArr = responseObject[@"movieinfo"];
            for (NSDictionary *dic in filmsArr) {

                SCFilmModel *filmModel = [SCFilmModel mj_objectWithKeyValues:dic];
    
                [_filmModelArr addObject:filmModel];
                
            }
        }
        
        [self.collectionView reloadData];
        [CommonFunc dismiss];
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
    
    
}


#pragma mark ---- UICollectionViewDataSource

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
    
    
    SCCollectionViewPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    SCFilmModel *model = _filmModelArr[indexPath.row];
    cell.model = model;
    return cell;
}

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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"======点击=====");
    SCPlayerViewController *teleplayPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
    SCFilmModel *model = _filmModelArr[indexPath.row];
    teleplayPlayer.filmModel = model;
    teleplayPlayer.filmType = @"1";
    
    NSLog(@"======点击=====%@",model._Mtype);
    
    
    teleplayPlayer.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:teleplayPlayer animated:YES];

}
@end
