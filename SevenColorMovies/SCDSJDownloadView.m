//
//  SCDownloadView.m
//  SCDSJDownloadView
//
//  Created by yesdgq on 16/11/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCDSJDownloadView.h"
#import "SCDSJDownloadCell.h"
#import "SCFilmSetModel.h"
#import "SCFilmModel.h"
#import <ZFDownloadManager.h>

@interface SCDSJDownloadView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HLJRequest *hljRequest;

@end

@implementation SCDSJDownloadView

static NSString *const cellId = @"cellId";

#pragma mark - Initialize
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setBackButton];
        
        [self setCollectionView];
    }
    return self;
}

#pragma mark - setter
- (void)setDataSourceArray:(NSArray *)dataSourceArray {
    // 初始化Realm
    NSString *documentPath = [FileManageCommon GetDocumentPath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"/myDownload.realm"];
    NSURL *databaseUrl = [NSURL URLWithString:filePath];
    RLMRealm *realm = [RLMRealm realmWithURL:databaseUrl];
    RLMResults *results = [SCFilmSetModel allObjectsInRealm:realm];
    DONG_Log(@"results:%ld",results.count);
    
    //遍历dataSourceArray的filmSetModel是否存在于results，如果存在，则filmSetModel.downloaded=YES
        if (dataSourceArray) {
            for (SCFilmSetModel *filmSetModel in dataSourceArray) {
                for (SCFilmSetModel *realmFilmSetModel in results) {
                    if (filmSetModel._FilmContentID == realmFilmSetModel._FilmContentID) {
                        filmSetModel.downloaded = YES;
                    }
                }
            }
        }
    _dataSourceArray = dataSourceArray;
}

#pragma mark - private method
- (void)setBackButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(15, 10, 70, 15);
    [backBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [backBtn setTitle:@"下载" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorWithHex:@"#666666"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"Back_Arrow"] forState:UIControlStateNormal];
    [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    backBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    backBtn.enlargedEdge = 20;
    [backBtn addTarget:self action:@selector(removeDownloadView) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backBtn];
}

- (void)removeDownloadView {
    if (self.backBtnBlock) {
        self.backBtnBlock();
    }
}

- (void)setCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, kMainScreenWidth, ViewHeight(self)-30) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //0.初始化collectionView
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alwaysBounceVertical=YES;
    // 注册cell、sectionHeader、sectionFooter
    [collectionView registerNib:[UINib nibWithNibName:@"SCDSJDownloadCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    self.collectionView = collectionView;
    [self addSubview:collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCDSJDownloadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    SCFilmSetModel *filmSetModel = _dataSourceArray[indexPath.item];
    cell.filmSetModle = filmSetModel;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
/** item Size */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(kMainScreenWidth-24-32)/5,(kMainScreenWidth/6-15)};
}

/** CollectionView四周间距 EdgeInsets */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 12, 0, 12);
}

/** item水平间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
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

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//点击某item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 下载图标控制
    SCDSJDownloadCell *cell = (SCDSJDownloadCell *)[collectionView cellForItemAtIndexPath:indexPath];
    SCFilmSetModel *filmSetModel = _dataSourceArray[indexPath.item];
    if (!filmSetModel.isDownLoaded) {
        filmSetModel.downloaded = YES;
        cell.filmSetModle = filmSetModel;
    }
    // 下载
    DONG_WeakSelf(self);
    self.hljRequest = [HLJRequest requestWithPlayVideoURL:FilmSourceUrl];
    [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
        //请求播放地址
        [requestDataManager requestDataWithUrl:filmSetModel.VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
            DONG_StrongSelf(self);
            //NSLog(@"====responseObject:::%@===",responseObject);
            NSString *play_url = responseObject[@"play_url"];
            DONG_Log(@"responseObject:%@",play_url);
            //请求将播放地址域名转换  并拼接最终的播放地址
            NSString *newVideoUrl = [strongself.hljRequest getNewViedoURLByOriginVideoURL:play_url];
            
            DONG_Log(@"newVideoUrl:%@",newVideoUrl);
            //1.拼接新地址
            NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
            
            // 名称
            NSString *filmName;
            if (_filmModel.FilmName) {
                    filmName = [NSString stringWithFormat:@"%@ 第%@集",_filmModel.FilmName, filmSetModel._ContentIndex];
            }else if (_filmModel.cnname){
                    filmName = [NSString stringWithFormat:@"%@ 第%@集",_filmModel.cnname, filmSetModel._ContentIndex];
            }
            DONG_Log(@"%@",filmName);
            NSString *downloadUrl = @"http://dlsw.baidu.com/sw-search-sp/soft/2a/25677/QQ_V4.1.1.1456905733.dmg";
//            // 利用ZFDownloadManager下载
            [[ZFDownloadManager sharedDownloadManager] downFileUrl:playUrl filename:filmName fileimage:nil];
            // 设置最多同时下载个数（默认是3）
            [ZFDownloadManager sharedDownloadManager].maxCount = 2;
            
            // 初始化Realm
            NSString *documentPath = [FileManageCommon GetDocumentPath];
            NSString *filePath = [documentPath stringByAppendingPathComponent:@"/myDownload.realm"];
            NSURL *databaseUrl = [NSURL URLWithString:filePath];
            RLMRealm *realm = [RLMRealm realmWithURL:databaseUrl];
            // 使用 NSPredicate 查询
//            NSPredicate *pred = [NSPredicate predicateWithFormat:
//                                 @"_FilmContentID = %@",filmSetModel._FilmContentID];
            NSPredicate *pred = [NSPredicate predicateWithFormat:
                                 @"_FilmContentID = %@",filmSetModel._FilmContentID];
            RLMResults *results = [SCFilmSetModel objectsInRealm:realm withPredicate:pred];

            DONG_Log(@"results:%ld",(unsigned long)results.count);
            if (!results.count) {//没有保存过才保存
                //保存到数据库
                SCFilmSetModel *realmFilmSetModel = [[SCFilmSetModel alloc] initWithValue:filmSetModel];
                [realm transactionWithBlock:^{
                    [realm addObject: realmFilmSetModel];
                }];
            }

            [CommonFunc dismiss];
            
        } failure:^(id  _Nullable errorObject) {
            [CommonFunc dismiss];
        }];
    } failure:^(NSError *error) {
        [CommonFunc dismiss];
    }];
    
}



@end
