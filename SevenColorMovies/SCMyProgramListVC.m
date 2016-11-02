//
//  SCMyProgramListVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/14.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  我的节目单控制器

#import "SCMyProgramListVC.h"
#import "SCProgramListCell.h"
#import "SCFilmModel.h"
#import "SCHuikanPlayerViewController.h"
#import <Realm/Realm.h>//数据库

@interface SCMyProgramListVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *editBtn;/** 编辑按钮 */
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *bottomBtnView;
@property (nonatomic, strong) UIButton *selectAllBtn;/** 全选按钮 */
@property (nonatomic, assign) BOOL isEditing;/** 标记是否正在编辑 */
@property (nonatomic, assign, getter = isSelectAll) BOOL selectAll;/** 标记是否被全部选中 */
@property (nonatomic, strong) NSMutableArray *tempArray;/** 保存临时选择的要删除的filmModel */

@end

@implementation SCMyProgramListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    // 1.初始化数组
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    // 2.读取数据库信息
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *results = [SCFilmModel allObjectsInRealm:realm];
    
    for (int i = 0; i< results.count; i++) {
        SCFilmModel  *filmModel = results[i];
        
        [_dataArray addObject:filmModel];
    }
    
    DONG_Log(@"%@",[RLMRealmConfiguration defaultConfiguration].fileURL);
    
    // 3.初始化
    _isEditing = NO;
    self.tempArray = [NSMutableArray arrayWithCapacity:0];
    
    // 4 加载分视图
    // 4.1 编辑按钮
    [self addRightBBI];
    if (_dataArray.count == 0) {
        [CommonFunc noDataOrNoNetTipsString:@"还没有添加任何节目哦" addView:self.view];
    }else{
        [CommonFunc hideTipsViews:_listView];
        // 4.2 tableview
        [self setTableView];
    }
    // 4.3 全选/删除
    [self setBottomBtnView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    [deleteAllBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
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
            SCFilmModel *filmModel = obj;
            filmModel.selected = YES;
            [_tempArray addObject:filmModel];
        }];
    }else{
        _selectAll = NO;
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_tempArray removeAllObjects];
        [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SCFilmModel *filmModel = obj;
            filmModel.selected = NO;
        }];
    }
    [_listView reloadData];
}

- (void)delete{
    // 遍历model获取对应的下标
    NSMutableArray *indexPathArray = [NSMutableArray arrayWithCapacity:0];
    [_tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SCFilmModel *filmModel = obj;
        NSInteger index = [_dataArray indexOfObject:filmModel];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [indexPathArray addObject:indexPath];
    }];
    
    // 删除cell前 必须先删除tableview的数据源
    [_dataArray removeObjectsInArray:_tempArray];
    // 把view相应的cell删掉
    [_listView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    
    // 删除数据库中的数据 如果filmModel的filmSetModel不为空 要删除filmSetmodel再删除filmModel
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    for (SCFilmModel *filmModel in _tempArray) {
        // 若只删除filmModel 数据库中的filmSetModel不会被删除 故要先删除filmModel.filmSetModel
        if (filmModel.filmSetModel) {// 不能删除空对象
            [realm deleteObject:filmModel.filmSetModel];
        }
        [realm deleteObject:filmModel];
    }
    [realm commitWriteTransaction];
    
    // 清空变量
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
            SCFilmModel *filmModel = obj;
            filmModel.showDeleteBtn = YES;
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
            SCFilmModel *filmModel = obj;
            filmModel.showDeleteBtn = NO;
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
    SCProgramListCell *cell = [SCProgramListCell cellWithTableView:tableView];
    cell.filmModel = _dataArray[indexPath.row];
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
        SCFilmModel *filmModel = _dataArray[indexPath.row];
        // 1.把model相应的数据删掉
        [self.dataArray removeObject:filmModel];
        
        // 2.把view相应的cell删掉
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_tempArray removeObject:filmModel];
        
        // 3.删除数据库中的数据
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        //若只删除filmModel 数据库中的filmSetModel不会被删除 故要先删除filmModel.filmSetModel
        if (filmModel.filmSetModel) {//不能删除空对象
            [realm deleteObject:filmModel.filmSetModel];
        }
        [realm deleteObject:filmModel];
        [realm commitWriteTransaction];
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
        SCFilmModel *filmModel = _dataArray[indexPath.row];
        SCProgramListCell *cell = (SCProgramListCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if (filmModel.isSelecting) {
            filmModel.selected = NO;
            //从临时数据中删除
            [_tempArray removeObject:filmModel];
            
        }else{
            filmModel.selected = YES;
            //添加到临时数组中 待确定后从数据库中删除
            [_tempArray addObject:filmModel];
            
        }
        cell.filmModel = filmModel;
        
    }else{//非编辑状态，点击cell播放film
        
        SCFilmModel *filmModel = _dataArray[indexPath.row];
        SCHuikanPlayerViewController *playerVC = [SCHuikanPlayerViewController initPlayerWithFilmModel:filmModel];
        [self.navigationController pushViewController:playerVC animated:YES];
    }
}


@end
