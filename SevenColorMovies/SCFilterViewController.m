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
#import "SCFilterOptionTabModel.h"
#import "SCFilmModel.h"
#import "SCCollectionViewPageCell.h"

@interface SCFilterViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collView;

@property (weak, nonatomic) IBOutlet UIView *filterTitleView;/* 筛选项背景 */
@property (nonatomic, strong) SCFliterOptionView *typeOptionView;/* 类型选项卡 */
@property (nonatomic, strong) SCFliterOptionView *areaOptionView;/* 地区选项卡 */
@property (nonatomic, strong) SCFliterOptionView *timeOptionView;/* 时间选项卡 */
@property (nonatomic, strong) NSMutableArray *typeArray;/* 类型 */
@property (nonatomic, strong) NSMutableArray *areaArray;/* 区域 */
@property (nonatomic, strong) NSMutableArray *timeArray;/* 时间 */
@property (nonatomic, copy) NSString *type;/* 筛选参数 */
@property (nonatomic, copy) NSString *area;/* 筛选参数 */
@property (nonatomic, copy) NSString *time;/* 筛选参数 */
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
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
    
    //2.初始化数组
    self.typeArray = [NSMutableArray arrayWithCapacity:0];
    self.areaArray = [NSMutableArray arrayWithCapacity:0];
    self.timeArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    //3.初始化page
    self.page = 2;
    //4.添加筛选选项卡
    [self getFilterOptionTabData];
    //5.添加collectionView
    [self loadCollectionView];
    //6.进入页面先请求全局筛选数据一次
    [self requestFilterDataWithTypeAndAreaAndTimeAndPage:1];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doFilterAction:) name:FilterOptionChanged object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FilterOptionChanged object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- private methods
- (void)setFilterOptionTitleView
{
    // 1.地区选项卡
    _areaOptionView = [SCFliterOptionView viewWithType:@"地区"];
    _areaOptionView.dataArray = _areaArray;
    _areaOptionView.type = FilmArea;
    [_areaOptionView setFrame:CGRectMake(0, (self.filterTitleView.bounds.size.height-21)/2, kMainScreenWidth, 21)];
    [self.filterTitleView addSubview:_areaOptionView];
    // 2.类型选项卡
    _typeOptionView = [SCFliterOptionView viewWithType:@"类型"];
    _typeOptionView.dataArray = _typeArray;
    _typeOptionView.type = FilmType;
    [_typeOptionView setFrame:CGRectMake(0, self.areaOptionView.frame.origin.y-20-21, kMainScreenWidth, 21)];
    [self.filterTitleView addSubview:_typeOptionView];
    // 3.时间选项卡
    _timeOptionView = [SCFliterOptionView viewWithType:@"时间"];
    _timeOptionView.dataArray = _timeArray;
    _timeOptionView.type = FilmTime;
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
    
    //集成上拉加载更多
    [self setTableViewRefresh];
}


#pragma mark - 集成刷新
- (void)setTableViewRefresh {
    [CommonFunc setupRefreshWithView:_collView withSelf:self headerFunc:nil headerFuncFirst:YES footerFunc:@selector(footerRefresh)];
    
}

- (void)footerRefresh{
    
    [self requestFilterDataWithTypeAndAreaAndTimeAndPage:_page++];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCCollectionViewPageCell *cell = [_collView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = _dataArray[indexPath.row];
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
    SCPlayerViewController *teleplayPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
    SCFilmModel *filmModel = _dataArray[indexPath.row];
    teleplayPlayer.filmModel = filmModel;
    teleplayPlayer.bannerFilmModelArray = self.bannerFilmModelArray;
    teleplayPlayer.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:teleplayPlayer animated:YES];
}

#pragma mark- Event reponse
- (void)doFilterAction:(NSNotification *)notification{
    
    NSDictionary *dic = notification.object;
    
    switch ([dic[@"type"] integerValue]) {
        case FilmType:
            _type = [dic[@"tabText"] isEqualToString:@"全部"]? @"" : dic[@"tabText"];
            NSLog(@">>>>>>>>>%@>>>>>>>>",_type);
            break;
            
        case FilmArea:
            _area = [dic[@"tabText"] isEqualToString:@"全部"]? @"" : dic[@"tabText"];
            NSLog(@">>>>>>>>>%@>>>>>>>>",_area);
            break;
            
        case FilmTime:
            _time = [dic[@"tabText"] isEqualToString:@"全部"]? @"" : dic[@"tabText"];
            NSLog(@">>>>>>>>>%@>>>>>>>>",_time);
            break;
            
        default:
            break;
    }
    // 开始筛选
    [self requestFilterDataWithTypeAndAreaAndTimeAndPage:1];
    
}

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
            
            [_typeArray removeAllObjects];
            
            for (NSString *tabText in responseObject[@"Label"][@"LabelName"]) {
                
                SCFilterOptionTabModel *optionTabModel = [[SCFilterOptionTabModel alloc] init];
                optionTabModel.tabText = tabText;
                [_typeArray addObject:optionTabModel];
            }
            
            SCFilterOptionTabModel *model = [[SCFilterOptionTabModel alloc] init];
            model.tabText = @"全部";
            model.selected = YES;
            [_typeArray insertObject:model atIndex:0];
            
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
            
            [_timeArray removeAllObjects];
            [_areaArray removeAllObjects];
            
            for (NSString *tabText in [responseObject[@"Label"] firstObject][@"LabelName"]) {
                
                SCFilterOptionTabModel *optionTabModel = [[SCFilterOptionTabModel alloc] init];
                optionTabModel.tabText = tabText;
                [_areaArray addObject:optionTabModel];
            }
            
            SCFilterOptionTabModel *model1 = [[SCFilterOptionTabModel alloc] init];
            model1.tabText = @"全部";
            model1.selected = YES;
            [_areaArray insertObject:model1 atIndex:0];
            
            for (NSString *tabText in [responseObject[@"Label"] lastObject][@"LabelName"]) {
                
                SCFilterOptionTabModel *optionTabModel = [[SCFilterOptionTabModel alloc] init];
                optionTabModel.tabText = tabText;
                [_timeArray addObject:optionTabModel];
            }
            
            SCFilterOptionTabModel *model2 = [[SCFilterOptionTabModel alloc] init];
            model2.tabText = @"全部";
            model2.selected = YES;
            [_timeArray insertObject:model2 atIndex:0];
            
            dispatch_group_leave(group);
        } failure:^(id  _Nullable errorObject) {
            
            [CommonFunc dismiss];
            dispatch_group_leave(group);
        }];
    });
    
    //4.都完成后会自动通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [self setFilterOptionTitleView];
        DONG_AFTER(0.5f, [CommonFunc dismiss]);
        
    });
    
}

// 筛选搜索
- (void)requestFilterDataWithTypeAndAreaAndTimeAndPage:(NSInteger)page{
    
    [CommonFunc showLoadingWithTips:@""];
    
    if (page == 1) {
        [_dataArray removeAllObjects];
    }
    
    NSDictionary *parameters = @{@"page" : [NSString stringWithFormat:@"%ld",(long)page],
                                 @"style" : _type? _type : @"",
                                 @"zone" : _area? _area : @"",
                                 @"time" : _time? _time : @"",
                                 @"mtype" : _mtype? _mtype : @"",
                                 @"column" : _filmClassModel._FilmClassID? _filmClassModel._FilmClassID : @""};
    
    [requestDataManager requestDataWithUrl:FilterUrl parameters:parameters success:^(id  _Nullable responseObject){
        //        NSLog(@"==========dic:::%@========",responseObject);
        
        if ([responseObject[@"Film"] isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in responseObject[@"Film"]) {
                
                SCFilmModel *filmModel = [SCFilmModel mj_objectWithKeyValues:dic];
                
                [_dataArray addObject:filmModel];
            }
            
        }
        
        [_collView reloadData];
        [_collView.mj_footer endRefreshing];
        [CommonFunc dismiss];
        
        if (_dataArray.count == 0) {
            [CommonFunc noDataOrNoNetTipsString:@"暂无结果" addView:self.collView];
        }else{
            [CommonFunc hideTipsViews:self.collView];
        }
        
    } failure:^(id  _Nullable errorObject) {
        
        [_collView.mj_footer endRefreshing];
        [CommonFunc dismiss];
        [_collView reloadData];
    }];
    
}

@end
