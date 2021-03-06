//
//  SCMyWatchingHistoryVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/14.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  观看记录

#import "SCMyWatchingHistoryVC.h"
#import "SCWatchingHistoryCell.h"
#import "SCProgramListCell.h"
#import "SCWatchHistoryModel.h"
#import "HLJRequest.h"
#import "HLJUUID.h"
#import "SCPlayerViewController.h"
#import "SCFilmModel.h"

@interface SCMyWatchingHistoryVC () <UITableViewDelegate, UITableViewDataSource>

/** 编辑按钮 */
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UITableView *listView;
/** 存放全部的观看记录 */
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *bottomBtnView;
/** 全选按钮 */
@property (nonatomic, strong) UIButton *selectAllBtn;
/** 标记是否正在编辑 */
@property (nonatomic, assign) BOOL isEditing;
/** 标记是否被全部选中 */
@property (nonatomic, assign, getter = isSelectAll) BOOL selectAll;
/** 保存临时选择的要删除的watchHistoryModel */
@property (nonatomic, strong) NSMutableArray *tempArray;
/** 分页的页码 */
@property (nonatomic, assign) NSInteger page;
/** 总页数 */
@property (nonatomic, assign) NSInteger totalPageCount;
/** ip转换工具 */
@property (nonatomic, strong) HLJRequest *hljRequest;
/** 动态域名获取工具 */
@property (nonatomic, strong) SCDomaintransformTool *domainTransformTool;

@end

@implementation SCMyWatchingHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    // 1.初始化
    _isEditing = NO;
    self.tempArray = [NSMutableArray arrayWithCapacity:0];
    
    // 2. 编辑按钮
    [self addRightBBI];
    
    // 3. 获取数据 添加视图
//    [self getMyWatchHistoryRecord];
    
    
    [self setTableView];
    // 4.3 全选/删除
    [self setBottomBtnView];
    
    
    //2.集成刷新
    [self setTabelViewRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Private Method
//添加 全选 || 删除 按钮视图
- (void)setBottomBtnView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView.layer setBorderWidth:1.f];
    [bottomView.layer setBorderColor:[UIColor grayColor].CGColor];
    
    UIView *separateLine = [[UIView alloc] init];
    //中间分割线
    separateLine.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:separateLine];
    [separateLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(bottomView);
        make.size.mas_equalTo(CGSizeMake(1, 60));
    }];
    
    //全选按钮
    UIButton *selectAllBtn = [[UIButton alloc] init];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    _selectAllBtn = selectAllBtn;
    [selectAllBtn addTarget:self action:@selector(selcetAll) forControlEvents:UIControlEventTouchUpInside];
    [selectAllBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bottomView addSubview:selectAllBtn];
    [selectAllBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(bottomView.mas_left);
        make.bottom.equalTo(bottomView.mas_bottom);
        make.right.equalTo(separateLine);
        
    }];
    
    //删除按钮
    UIButton *deleteAllBtn = [[UIButton alloc] init];
    [deleteAllBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteAllBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [deleteAllBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [deleteAllBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bottomView addSubview:deleteAllBtn];
    [deleteAllBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(separateLine);
        make.bottom.equalTo(bottomView.mas_bottom);
        make.right.equalTo(bottomView.mas_right);
    }];
    
    _bottomBtnView = bottomView;
    [self.view addSubview:bottomView];
    
}

- (void)selcetAll
{
    if (!self.isSelectAll) {
        _selectAll = YES;
        [_selectAllBtn setTitle:@"全部取消" forState:UIControlStateNormal];
        //遍历model以更改cell视图
        [_tempArray removeAllObjects];
        [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SCWatchHistoryModel *watchHistoryModel = obj;
            watchHistoryModel.selected = YES;
            [_tempArray addObject:watchHistoryModel];
        }];
        
    } else {
        
        _selectAll = NO;
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_tempArray removeAllObjects];
        [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SCWatchHistoryModel *watchHistoryModel = obj;
            watchHistoryModel.selected = NO;
        }];
    }
    
    [_listView reloadData];
}

- (void)deleteAction
{
    if (_tempArray.count == _dataArray.count) {
        // 调用全部删除方法
        [_tempArray removeAllObjects];
        [_dataArray removeAllObjects];
        [_listView reloadData];
        [self deleteAllWatchHistoryRecord];
        
    } else {
        
        // 1.从数据库中删除数据
        NSMutableArray *indexPathArray = [NSMutableArray arrayWithCapacity:0];
        [_tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SCWatchHistoryModel *watchHistoryModel = obj;
            NSInteger index = [_dataArray indexOfObject:watchHistoryModel];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [indexPathArray addObject:indexPath];
            //从服务器中删除数据
            [self deleteWatchHistoryRecordWithModel:watchHistoryModel];
        }];
        
        [_dataArray removeObjectsInArray:_tempArray];
        // 2.把view相应的cell删掉
        [_listView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
        [_tempArray removeAllObjects];
        [indexPathArray removeAllObjects];
        
    }

}

- (void)addRightBBI {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 45, 23);
    
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.enlargedEdge = 5.f;
    [btn.layer setBorderWidth:1.5f];
    [btn.layer setBorderColor:[UIColor grayColor].CGColor];
    [btn addTarget:self action:@selector(doEditingAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];
    _editBtn = btn;
    _editBtn.selected = NO;
}

- (void)doEditingAction{
    if (_editBtn.selected == NO) {//正在编辑
        _isEditing = YES;
        _editBtn.selected = YES;
        [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
        //[_listView setEditing:YES];
        [UIView animateWithDuration:0.2f animations:^{
            [_bottomBtnView setFrame:(CGRect){0, kMainScreenHeight-60, kMainScreenWidth, 60}];
        }];
        
        [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SCWatchHistoryModel *watchHistoryModel = obj;
            watchHistoryModel.showDeleteBtn = YES;
        }];
        [_listView reloadData];
        
        
    }else if (_editBtn.selected != NO){//完成编辑
        _isEditing = NO;
        _editBtn.selected = NO;
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        //[_listView setEditing:NO];
        [UIView animateWithDuration:0.2f animations:^{
            [_bottomBtnView setFrame:(CGRect){0, kMainScreenHeight, kMainScreenWidth, 60}];
        }];
        
        [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SCWatchHistoryModel *watchHistoryModel = obj;
            watchHistoryModel.showDeleteBtn = NO;
        }];
        [_listView reloadData];
    }
}

- (void)setTableView{
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.backgroundColor = [UIColor colorWithHex:@"f3f3f3"];
    _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listView.tableFooterView = [UIView new];
    _listView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    [self.view addSubview:_listView];
}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCWatchingHistoryCell *cell = [SCWatchingHistoryCell cellWithTableView:tableView];
    cell.watchHistoryModel = _dataArray[indexPath.row];
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NULL;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return NULL;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SCWatchHistoryModel *watchHistoryModel = _dataArray[indexPath.row];
        // 1.把model相应的数据删掉
        [self.dataArray removeObject:watchHistoryModel];
        
        // 2.把view相应的cell删掉
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_tempArray removeObject:watchHistoryModel];
        // 3.删除服务器中数据
        [self deleteWatchHistoryRecordWithModel:watchHistoryModel];
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

//将delete改为删除
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    SCWatchHistoryModel *watchHistoryModel = _dataArray[indexPath.row];
    if (_isEditing) {//处在编辑状态
        SCWatchingHistoryCell *cell = (SCWatchingHistoryCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if (watchHistoryModel.isSelecting) {
            watchHistoryModel.selected = NO;
            //从临时数据中删除
            [_tempArray removeObject:watchHistoryModel];
            
        } else {
            watchHistoryModel.selected = YES;
            //添加到临时数组中 待确定后从数据库中删除
            [_tempArray addObject:watchHistoryModel];
        }
        cell.watchHistoryModel = watchHistoryModel;
        
    } else {//非编辑状态，点击cell播放film
        
        SCFilmModel *filmModel = [[SCFilmModel alloc] init];
        filmModel.FilmName     = watchHistoryModel.title;
        filmModel._Mid          = watchHistoryModel.mid;
        filmModel.mtype        = watchHistoryModel.mtype;
        filmModel.jiIndex      = [watchHistoryModel.sid integerValue];
        filmModel._FilmID      = watchHistoryModel.fid;
        filmModel.currentPlayTime     = watchHistoryModel.playtime;
        
        DONG_Log(@"sid:%@",watchHistoryModel.sid);
        
        
        
        SCPlayerViewController *playerVC = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
        playerVC.filmModel = filmModel;
        [self.navigationController pushViewController:playerVC animated:YES];
    }
}

#pragma mark - 集成刷新

- (void)setTabelViewRefresh
{
   [CommonFunc setupRefreshWithView:self.listView withSelf:self headerFunc:@selector(headerRefresh) headerFuncFirst:YES footerFunc:@selector(loadMoreData)];
}

- (void)headerRefresh
{
    _page = 1;
    [self getMyWatchHistoryRecord:_page];
}

- (void)loadMoreData
{
    _page++;
    if (_page <= _totalPageCount ) {
        [self getMyWatchHistoryRecord:_page];
    } else {
        [self.listView.mj_header endRefreshing];
        [self.listView.mj_footer endRefreshing];
    }
}

#pragma mark - NetRequest

//查看观看记录
- (void)getMyWatchHistoryRecord:(NSInteger)page
{
    [CommonFunc showLoadingWithTips:@""];
    NSString *uuidStr   = [HLJUUID getUUID];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[NSDate timeStampFromDate:[NSDate date]]];
    NSNumber *currentPage      = [NSNumber numberWithInteger:page];
    NSDictionary *parameters = @{@"ctype"    : @"3",
                                 @"hid"      : uuidStr,
                                 @"datetime" : timeStamp,
                                 @"page"     : currentPage,
                                 @"pagesize" : @"20",
                                 @"orderby"  : @"1"
                                 };
    
    //请求播放地址
    // 域名获取
    _domainTransformTool = [[SCDomaintransformTool alloc] init];
    [_domainTransformTool getNewDomainByUrlString:GetWatchHistory key:@"skscxb" success:^(id  _Nullable newUrlString) {
        
        // ip转换
        _hljRequest = [HLJRequest requestWithPlayVideoURL:newUrlString];
        [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
            
            [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
//                DONG_Log(@"responseObject:%@",responseObject);
                self.totalPageCount = [[responseObject objectForKey:@"pagetotal"] integerValue];
                if (page == 1) {
                    [_dataArray removeAllObjects];
                }
                if ([responseObject[@"contentlist"][@"content"] isKindOfClass:[NSDictionary class]]) {
                    
                    SCWatchHistoryModel *watchHistoryModel = [SCWatchHistoryModel mj_objectWithKeyValues:responseObject[@"contentlist"][@"content"]];
                    [_dataArray addObject:watchHistoryModel];
                    
                } else if ([responseObject[@"contentlist"][@"content"] isKindOfClass:[NSArray class]]) {
                    
                    NSArray *contentArray = responseObject[@"contentlist"][@"content"];
                    for (NSDictionary *dic in contentArray) {
                        SCWatchHistoryModel *watchHistoryModel = [SCWatchHistoryModel mj_objectWithKeyValues:dic];
                        [_dataArray addObject:watchHistoryModel];
                    }
                }
                
                if (_dataArray.count) {
                    [_listView reloadData];
                } else {
                    [CommonFunc noDataOrNoNetTipsString:@"还没有观看任何节目哦" addView:self.view];
                }
                [CommonFunc dismiss];
                [self.listView.mj_header endRefreshing];
                [self.listView.mj_footer endRefreshing];
                
            } failure:^(id  _Nullable errorObject) {
                [CommonFunc noDataOrNoNetTipsString:@"网络异常请稍后再试" addView:self.view];
                [CommonFunc dismiss];
            }];
            
        } failure:^(NSError *error) {
            [CommonFunc dismiss];
        }];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
        
    }];
}

// 删除一条观看记录
- (void)deleteWatchHistoryRecordWithModel:(SCWatchHistoryModel *)watchHistoryModel
{
    [CommonFunc showLoadingWithTips:@""];
    NSString *uuidStr   = [HLJUUID getUUID];
    NSString *mid       = watchHistoryModel.mid;
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[NSDate timeStampFromDate:[NSDate date]]];
    NSString *sid       = watchHistoryModel.sid;
    NSString *fid       = watchHistoryModel.fid;
    
    NSDictionary *parameters = @{@"ctype"    : @"4",
                                 @"hid"      : uuidStr,
                                 @"mid"      : mid,
                                 @"datetime" : timeStamp,
                                 @"sid"      : sid,
                                 @"fid"      : fid
                                 };
    
    //请求播放地址
    // 域名获取
    NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:DeleteWatchHistory key:@"skscxb"];
    DONG_Log(@"domainUrl:%@",domainUrl);
    // ip转换
    NSString *newVideoUrl = [_hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
    DONG_Log(@"newVideoUrl:%@",newVideoUrl);
    
    [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
        
        [CommonFunc dismiss];
    }failure:^(id  _Nullable errorObject) {
        [CommonFunc dismiss];
        [MBProgressHUD showError:@"删除失败"];
    }];
}

// 删除全部记录
- (void)deleteAllWatchHistoryRecord
{
    [CommonFunc showLoadingWithTips:@""];
    NSString *uuidStr   = [HLJUUID getUUID];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[NSDate timeStampFromDate:[NSDate date]]];
    
    NSDictionary *parameters = @{
                                 @"ctype"    : @"4",
                                 @"hid"      : uuidStr,
                                 @"datetime" : timeStamp
                                 };
    
    
    //请求播放地址
    // 域名获取
    NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:DeleteWatchHistory key:@"skscxb"];
    DONG_Log(@"domainUrl:%@",domainUrl);
    // ip转换
    NSString *newVideoUrl = [_hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
    DONG_Log(@"newVideoUrl:%@",newVideoUrl);
    
    [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
        // 删除成功
        
        [CommonFunc dismiss];
    }failure:^(id  _Nullable errorObject) {
        [CommonFunc dismiss];
        [MBProgressHUD showError:@"删除失败"];
    }];
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}

@end
