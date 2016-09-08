//
//  SCFilterViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/29.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  筛选控制器

#import "SCFilterViewController.h"
#import "SCPlayerViewController.h"
#import "SCFliterOptionView.h"


@interface SCFilterViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collView;

@property (weak, nonatomic) IBOutlet UIView *filterTitleView;/* 筛选项背景 */
@property (nonatomic, strong) SCFliterOptionView *typeOptionView;/* 类型选项卡 */
@property (nonatomic, strong) SCFliterOptionView *areaOptionView;/* 地区选项卡 */
@property (nonatomic, strong) SCFliterOptionView *timeOptionView;/* 时间选项卡 */
@property (nonatomic, strong) NSMutableArray *typeArray;/* 类型 */
@property (nonatomic, strong) NSMutableArray *areaArray;/* 区域 */
@property (nonatomic, strong) NSMutableArray *timeArray;/* 时间 */

@end

@implementation SCFilterViewController

static NSString *const cellId = @"SCCollectionViewPageCell";

#pragma mark-  ViewLife Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    //1.标题
    self.leftBBI.text = @"筛选";
    
    //初始化数组
//    self.typeArray = [NSArray array];
//    self.areaArray = [NSArray array];
//    self.timeArray = [NSArray array];
    
    
    
    
    // 2.添加collectionView
    [self loadCollectionView];
    
    [self getFilterOptionTabData];
    [self requestFilterDataWithTypeAndAreaAndTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- private methods
- (void)setFilterOptionTitleView
{
    // 地区选项卡
    _areaOptionView = [SCFliterOptionView viewWithType:@"地区"];
    _areaOptionView.dataArray = _areaArray;
    [_areaOptionView setFrame:CGRectMake(0, (self.filterTitleView.bounds.size.height-21)/2, kMainScreenWidth, 21)];
    [self.filterTitleView addSubview:_areaOptionView];
    // 类型选项卡
    _typeOptionView = [SCFliterOptionView viewWithType:@"类型"];
    _typeOptionView.dataArray = _typeArray;
    [_typeOptionView setFrame:CGRectMake(0, self.areaOptionView.frame.origin.y-20-21, kMainScreenWidth, 21)];
    [self.filterTitleView addSubview:_typeOptionView];
    // 时间选项卡
    _timeOptionView = [SCFliterOptionView viewWithType:@"时间"];
    _timeOptionView.dataArray = _timeArray;
    [_timeOptionView setFrame:CGRectMake(0, self.areaOptionView.frame.origin.y+20+21, kMainScreenWidth, 21)];
    [self.filterTitleView addSubview:_timeOptionView];
   
    
}

- (void)loadCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];// 布局对象
    _collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 80+135, kMainScreenWidth, kMainScreenHeight-80-135) collectionViewLayout:layout];
    _collView.backgroundColor = [UIColor whiteColor];
    _collView.alwaysBounceVertical=YES;
    _collView.dataSource = self;
    _collView.delegate = self;
    
    [self.view addSubview:_collView];
    
    // 注册cell、sectionHeader、sectionFooter
    [_collView registerNib:[UINib nibWithNibName:@"SCCollectionViewPageCell" bundle:nil] forCellWithReuseIdentifier:cellId];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 16;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [_collView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"======点击=====");
    SCPlayerViewController *teleplayPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
    teleplayPlayer.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:teleplayPlayer animated:YES];
    
}


#pragma mark- Event reponse


#pragma mark- 网络请求
// 获取筛选选项卡
- (void)getFilterOptionTabData{
    
    [CommonFunc showLoadingWithTips:@""];
    
    NSDictionary *parameters = @{@"cate" : [_filmClassModel._KeyValue description]};
    
    NSString *urlStr = [FilterOptionTypeTabUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [FilterOptionAreaAndTimeTab2Url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    //1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //3.多次使用队列组的方法执行任务, 只有异步方法
    //afn内部是一个block，等数据请求完成之后dispatch_group_notify已经执行过了，所以这里要手动管理group进出
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [requestDataManager requestDataWithUrl:urlStr parameters:parameters success:^(id  _Nullable responseObject){
//            NSLog(@"==========dic:::%@========",responseObject);
            self.typeArray = [NSMutableArray arrayWithArray:responseObject[@"Label"][@"LabelName"]];
            [_typeArray insertObject:@"全部" atIndex:0];
            dispatch_group_leave(group);
        } failure:^(id  _Nullable errorObject) {
            
            [CommonFunc dismiss];
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [requestDataManager requestDataWithUrl:urlString parameters:parameters success:^(id  _Nullable responseObject){
//            NSLog(@"==========dic:::%@========",responseObject);
            
            self.areaArray = [NSMutableArray arrayWithArray:[responseObject[@"Label"] firstObject][@"LabelName"]];
            self.timeArray = [NSMutableArray arrayWithArray:[responseObject[@"Label"] lastObject][@"LabelName"]];
            [_areaArray insertObject:@"全部" atIndex:0];
            [_timeArray insertObject:@"全部" atIndex:0];
            
            dispatch_group_leave(group);
        } failure:^(id  _Nullable errorObject) {
            
            [CommonFunc dismiss];
            dispatch_group_leave(group);
        }];
    });

    //4.都完成后会自动通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
      
        [self setFilterOptionTitleView];
        [CommonFunc dismiss];
    });

}
// 筛选搜索
- (void)requestFilterDataWithTypeAndAreaAndTime{
    
    NSDictionary *parameters = @{@"page" : @"1",
                                 @"style" : @"",
                                 @"zone" : @"",
                                 @"time" : @"",
                                 @"mtype" : @"",
                                 @"column" : @""};

    [requestDataManager requestDataWithUrl:FilterUrl parameters:parameters success:^(id  _Nullable responseObject){
        NSLog(@"==========dic:::%@========",responseObject);
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
        
    }];

    
}

@end
