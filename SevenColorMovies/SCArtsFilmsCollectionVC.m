//
//  SCArtsFilmsCollectionVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/10.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCArtsFilmsCollectionVC.h"
#import "SCArtsFilmCell.h"
#import "SCFilmModel.h"

@implementation SCArtsFilmsCollectionVC


static NSString *const cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //0.初始化collectionView
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical=YES;
    // 注册cell、sectionHeader、sectionFooter
    [self.collectionView registerNib:[UINib nibWithNibName:@"SCArtsFilmCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    
    
}




#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SCArtsFilmCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.model = _dataSource[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(kMainScreenWidth-24), 59};
}

/** CollectionView四周间距 EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(12, 12, 0, 12);
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
    SCFilmModel *model = _dataSource[indexPath.row];
    NSString *urlStr = [model.SourceURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager requestDataWithUrl:urlStr parameters:nil success:^(id  _Nullable responseObject) {
        
        if (responseObject) {
            
           NSString *downLoadUrl = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
            
            
            //获取fid
            NSString *fidString = [[[[downLoadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
            //base64编码downloadUrl
            NSString *downloadBase64Url = [downLoadUrl stringByBase64Encoding];
            //视频播放url
            NSString *VODStreamingUrl = [[[[[[VODUrl stringByAppendingString:@"&mid="] stringByAppendingString:model._Mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
            
            NSLog(@">>>>>>>>>>>downLoadUrl>>>>>>>>%@",downLoadUrl);
            NSLog(@">>>>>>>>>>>VODStreamingUrl>>>>>>>>%@",VODStreamingUrl);
        }
  
        [CommonFunc dismiss];
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
    
    
}

@end
