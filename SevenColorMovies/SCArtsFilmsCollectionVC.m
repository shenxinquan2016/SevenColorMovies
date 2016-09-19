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

#pragma mark-  ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //0.初始化collectionView
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical=YES;
    // 注册cell、sectionHeader、sectionFooter
    [self.collectionView registerNib:[UINib nibWithNibName:@"SCArtsFilmCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    
    [DONG_NotificationCenter addObserver:self selector:@selector(changeCellStateWhenPlayNextProgrom:) name:ChangeCellStateWhenPlayNextVODFilm object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [DONG_UserDefaults setInteger:0 forKey:k_for_VOD_selectedCellIndex];
    [DONG_UserDefaults synchronize];

    [DONG_NotificationCenter removeObserver:self name:ChangeCellStateWhenPlayNextVODFilm object:nil];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SCArtsFilmCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
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

// 点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCFilmModel *model = _dataArray[indexPath.row];
    NSString *urlStr = [model.SourceURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //通过改变cell对应model的onLive属性来改变cell字体颜色
    model.onLive = YES;
    SCArtsFilmCell *cell = (SCArtsFilmCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.model = model;
    
    //将前一个cell置为费播放状态
    NSUInteger lastIndex = [DONG_UserDefaults integerForKey:k_for_VOD_selectedCellIndex];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:lastIndex inSection:0];
    if (lastIndex != indexPath.row) {
        //通过改变cell对应model的onLive属性来改变cell字体颜色
        SCArtsFilmCell *lastCell = (SCArtsFilmCell *)[collectionView cellForItemAtIndexPath:lastIndexPath];
        SCFilmModel *lastFilmModel = _dataArray[lastIndex];
        lastFilmModel.onLive = NO;
        lastCell.model = lastFilmModel;
    }
 
    [DONG_UserDefaults setInteger:indexPath.row forKey:k_for_VOD_selectedCellIndex];
    [DONG_UserDefaults synchronize];

    //请求播放地址
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager requestDataWithUrl:urlStr parameters:nil success:^(id  _Nullable responseObject) {
        
           NSString *downLoadUrl = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
            
            //获取fid
            NSString *fidString = [[[[downLoadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
            //base64编码downloadUrl
            NSString *downloadBase64Url = [downLoadUrl stringByBase64Encoding];
            //视频播放url
            NSString *VODStreamingUrl = [[[[[[VODUrl stringByAppendingString:@"&mid="] stringByAppendingString:model._Mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
            
            NSLog(@">>>>>>>>>>>downLoadUrl>>>>>>>>%@",downLoadUrl);
            NSLog(@">>>>>>>>>>>VODStreamingUrl>>>>>>>>%@",VODStreamingUrl);
        
        //播放新节目
        if (self.clickToPlayBlock) {
            self.clickToPlayBlock(model,VODStreamingUrl,downLoadUrl);//切换节目BLock
        }
        
        [CommonFunc dismiss];
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
    
}

#pragma mark- Event reponse
- (void)changeCellStateWhenPlayNextProgrom:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    NSUInteger VODIndex = [dic[@"VODIndex"] integerValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:VODIndex inSection:0];
    
    SCFilmModel *filmModel = dic[@"filmModel"];
    filmModel.onLive = YES;
    SCArtsFilmCell *cell = (SCArtsFilmCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.model = filmModel;
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    
    //前一个cell置为非播放状态
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:VODIndex-1 inSection:0];
    SCFilmModel *lastFilmModel = _dataArray[VODIndex-1];
    lastFilmModel.onLive = NO;
    SCArtsFilmCell *lastCell = (SCArtsFilmCell *)[self.collectionView cellForItemAtIndexPath:lastIndexPath];
    lastCell.model = lastFilmModel;
    
    [DONG_UserDefaults setInteger:VODIndex forKey:k_for_VOD_selectedCellIndex];
    [DONG_UserDefaults synchronize];
    
    NSString *urlStr = [filmModel.SourceURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager requestDataWithUrl:urlStr parameters:nil success:^(id  _Nullable responseObject) {
        
        NSString *downLoadUrl = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
        
        //获取fid
        NSString *fidString = [[[[downLoadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
        //base64编码downloadUrl
        NSString *downloadBase64Url = [downLoadUrl stringByBase64Encoding];
        //视频播放url
        NSString *VODStreamingUrl = [[[[[[VODUrl stringByAppendingString:@"&mid="] stringByAppendingString:filmModel._Mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
        
        NSLog(@">>>>>>>>>>>downLoadUrl>>>>>>>>%@",downLoadUrl);
        NSLog(@">>>>>>>>>>>VODStreamingUrl>>>>>>>>%@",VODStreamingUrl);
        
        //播放新节目
        if (self.clickToPlayBlock) {
            self.clickToPlayBlock(filmModel,VODStreamingUrl,downLoadUrl);//切换节目BLock
        }
        
        [CommonFunc dismiss];
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
}

@end
