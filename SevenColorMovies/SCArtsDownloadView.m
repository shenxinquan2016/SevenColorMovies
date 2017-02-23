//
//  SCArtsDownloadView.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  综艺生活下载页

#import "SCArtsDownloadView.h"
#import "SCFilmModel.h"
#import "SCArtsDownloadCell.h"
#import <ZFDownloadManager.h>

@interface SCArtsDownloadView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HLJRequest *hljRequest;
@property (nonatomic, strong) SCDomaintransformTool *domainTransformTool;

@end

@implementation SCArtsDownloadView

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
    // 得到数据时要查询数据库 对比那些model是已经下载过的
    NSString *documentPath = [FileManageCommon GetDocumentPath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"/myDownload.realm"];
    NSURL *databaseUrl = [NSURL URLWithString:filePath];
    RLMRealm *realm = [RLMRealm realmWithURL:databaseUrl];
    RLMResults *results = [SCFilmModel allObjectsInRealm:realm];
    DONG_Log(@"results:%ld",results.count);
    
    //遍历dataSourceArray的filmSetModel是否存在于results，如果存在，则filmSetModel.downloaded=YES
    if (dataSourceArray && results.count) {
        for (SCFilmModel *filmModel in dataSourceArray) {
            for (SCFilmModel *realmFilmModel in results) {
                if ([filmModel.FilmName isEqualToString:realmFilmModel.FilmName]) {
                    filmModel.downloaded = YES;
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
    [collectionView registerNib:[UINib nibWithNibName:@"SCArtsDownloadCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
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
    SCArtsDownloadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    SCFilmModel *filmModel = _dataSourceArray[indexPath.item];
    cell.filmModel = filmModel;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
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

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//点击某item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 下载图标控制
    SCArtsDownloadCell *cell = (SCArtsDownloadCell *)[collectionView cellForItemAtIndexPath:indexPath];
    SCFilmModel *filmModel = _dataSourceArray[indexPath.item];
    if (!filmModel.isDownLoaded) {
        filmModel.downloaded = YES;
        cell.filmModel = filmModel;
    }
    // 下载
    DONG_WeakSelf(self);
    //请求播放地址
    NSString *urlStr = [filmModel.SourceURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //获取downLoadUrl
    [requestDataManager requestDataWithUrl:urlStr parameters:nil success:^(id  _Nullable responseObject) {
        DONG_StrongSelf(self);
        NSString *downLoadUrl = nil;
        if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSDictionary class]]) {
            downLoadUrl = responseObject[@"ContentSet"][@"Content"][@"_DownUrl"];
        } else if ([responseObject[@"ContentSet"][@"Content"] isKindOfClass:[NSArray class]]) {
            NSArray *array = responseObject[@"ContentSet"][@"Content"];
            downLoadUrl = [array firstObject][@"_DownUrl"];
        }
        
        //获取fid
        NSString *fidString = [[[[downLoadUrl componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"] firstObject];
        //base64编码downloadUrl
        NSString *downloadBase64Url = [downLoadUrl stringByBase64Encoding];
        
        //视频播放url
        // 域名获取
        _domainTransformTool = [[SCDomaintransformTool alloc] init];
        [_domainTransformTool getNewDomainByUrlString:VODUrl key:@"vodplayauth" success:^(id  _Nullable newUrlString) {
            
            DONG_Log(@"newUrlString:%@",newUrlString);
            // ip转换
            _hljRequest = [HLJRequest requestWithPlayVideoURL:newUrlString];
            [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
                
                DONG_Log(@"newVideoUrl:%@",newVideoUrl);
                
                NSString *VODStreamingUrl = [[[[[[newVideoUrl stringByAppendingString:@"&mid="] stringByAppendingString:filmModel._Mid] stringByAppendingString:@"&"] stringByAppendingString:fidString] stringByAppendingString:@"&ext="] stringByAppendingString:downloadBase64Url];
                //获取play_url
                [requestDataManager requestDataWithUrl:VODStreamingUrl parameters:nil success:^(id  _Nullable responseObject) {
                    //            NSLog(@"====responseObject:::%@===",responseObject);
                    NSString *play_url = responseObject[@"play_url"];
                    DONG_Log(@"responseObject:%@",play_url);
                    //请求将播放地址域名转换  并拼接最终的播放地址
                    NSString *newVideoUrl = [strongself.hljRequest getNewViedoURLByOriginVideoURL:play_url];
                    DONG_Log(@"newVideoUrl:%@",newVideoUrl);
                    //1.拼接新地址
                    NSString *playUrl = [NSString stringWithFormat:@"http://127.0.0.1:5656/play?url='%@'",newVideoUrl];
                    // NSString *downloadUrl = @"http://dlsw.baidu.com/sw-search-sp/soft/2a/25677/QQ_V4.1.1.1456905733.dmg";
                    // 利用ZFDownloadManager下载
                    [[ZFDownloadManager sharedDownloadManager] downFileUrl:playUrl filename:filmModel.FilmName fileimage:nil];
                    // 设置最多同时下载个数（默认是3）
                    [ZFDownloadManager sharedDownloadManager].maxCount = 2;
                    
                    // 初始化Realm
                    NSString *documentPath = [FileManageCommon GetDocumentPath];
                    NSString *filePath = [documentPath stringByAppendingPathComponent:@"/myDownload.realm"];
                    NSURL *databaseUrl = [NSURL URLWithString:filePath];
                    RLMRealm *realm = [RLMRealm realmWithURL:databaseUrl];
                    // 使用 NSPredicate 查询
                    NSPredicate *pred = [NSPredicate predicateWithFormat:
                                         @"FilmName = %@", filmModel.FilmName];
                    RLMResults *results = [SCFilmModel objectsInRealm:realm withPredicate:pred];
                    
                    if (!results.count) {//没有保存过才保存
                        //保存到数据库
                        SCFilmModel *RealmFilmModel = [[SCFilmModel alloc] initWithValue:filmModel];
                        [realm transactionWithBlock:^{
                            [realm addObject: RealmFilmModel];
                        }];
                    }
                    
                    [CommonFunc dismiss];
                    
                } failure:^(id  _Nullable errorObject) {
                    [CommonFunc dismiss];
                }];
                
            } failure:^(NSError *error) {
                [CommonFunc dismiss];
                
            }];
            
        } failure:^(id  _Nullable errorObject) {
            
            [CommonFunc dismiss];
            
        }];
        
        
    } failure:^(id  _Nullable errorObject) {
        [CommonFunc dismiss];
    }];
    
    
    
}


@end
