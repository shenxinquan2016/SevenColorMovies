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

@interface SCMyWatchingHistoryVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *editBtn;/** 编辑按钮 */
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *bottomBtnView;
@property (nonatomic, strong) UIButton *selectAllBtn;/** 全选按钮 */
@property (nonatomic, assign) BOOL isEditing;/** 标记是否正在编辑 */
@property (nonatomic, assign, getter = isSelectAll) BOOL selectAll;/** 标记是否被全部选中 */
@property (nonatomic, strong) NSMutableArray *tempArray;/** 保存临时选择的要删除的watchHistoryModel */
@property (nonatomic, strong) HLJRequest *hljRequest;
@property (nonatomic,assign) NSInteger page;/**< 分页的页码 */
@end

@implementation SCMyWatchingHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    
    // 3.初始化
    _isEditing = NO;
    self.tempArray = [NSMutableArray arrayWithCapacity:0];
    // 4.加载分视图
    // 4.1 编辑按钮
    [self addRightBBI];
    
    
    [self getMyWatchHistoryRecord];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Private Method
//全选 || 删除 按钮视图
- (void)setBottomBtnView{
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
    [deleteAllBtn addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
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

- (void)selcetAll{
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
    }else{
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

- (void)deleteAll{
    //1.从数据库中删除数据
    NSMutableArray *indexPathArray = [NSMutableArray arrayWithCapacity:0];
    [_tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SCWatchHistoryModel *watchHistoryModel = obj;
        NSInteger index = [_dataArray indexOfObject:watchHistoryModel];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [indexPathArray addObject:indexPath];
    }];
    [_dataArray removeObjectsInArray:_tempArray];
    // 2.把view相应的cell删掉
    [_listView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    [_tempArray removeAllObjects];
    [indexPathArray removeAllObjects];
    
}

- (void)setTableView{
    _listView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.backgroundColor = [UIColor colorWithHex:@"f3f3f3"];
    _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listView.tableFooterView = [UIView new];
    _listView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    [self.view addSubview:_listView];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (_isEditing) {//处在编辑状态
        SCWatchHistoryModel *watchHistoryModel = _dataArray[indexPath.row];
        SCWatchingHistoryCell *cell = (SCWatchingHistoryCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if (watchHistoryModel.isSelecting) {
            watchHistoryModel.selected = NO;
            //从临时数据中删除
            [_tempArray removeObject:watchHistoryModel];
            
            
        }else{
            watchHistoryModel.selected = YES;
            //添加到临时数组中 待确定后从数据库中删除
            [_tempArray addObject:watchHistoryModel];
            
            
        }
        cell.watchHistoryModel = watchHistoryModel;
        
        
    }else{//非编辑状态，点击cell播放film
        
        
        
    }
}

#pragma mark - NetRequest
- (void)getMyWatchHistoryRecord
{
    [CommonFunc showLoadingWithTips:@""];
    
    
    NSNumber *oemid     = [NSNumber numberWithInt:300126];
    NSString *uuidStr   = [HLJUUID getUUID];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[NSDate timeStampFromDate:[NSDate date]]];
    NSNumber *page      = [NSNumber numberWithInteger:1];
    NSDictionary *parameters = @{@"oemid"    : oemid,
                                 @"hid"      : @"96BE56AA5BEB4AFBA97887CE4A8C00dd",
                                 @"datetime" : timeStamp,
                                 @"page"     : page
                                 };
    
    
    //请求film详细信息
    //    self.hljRequest = [HLJRequest requestWithPlayVideoURL:GetWatchHistory];
    //    [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
    //
    //    } failure:^(id  _Nullable errorObject) {
    //        [CommonFunc dismiss];
    //    }];
    
    
    //请求播放地址
    [requestDataManager requestDataWithUrl:GetWatchHistory parameters:parameters success:^(id  _Nullable responseObject) {
        
        NSDictionary *dic = responseObject[@"contentlist"];
        if (dic) {
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
                [self setTableView];
                // 4.3 全选/删除
                [self setBottomBtnView];
                
            } else {
                [CommonFunc noDataOrNoNetTipsString:@"还没有收藏任何节目哦" addView:self.view];
            }
        }
        
        DONG_Log(@"获取观看记录成功:%@", responseObject);
        [CommonFunc dismiss];
    }failure:^(id  _Nullable errorObject) {
        [CommonFunc dismiss];
    }];
    
    
}





// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}

@end
