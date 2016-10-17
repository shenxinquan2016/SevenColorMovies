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

@interface SCMyProgramListVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *editBtn;/** 编辑按钮 */
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *bottomBtnView;
@property (nonatomic, strong) UIButton *selectAllBtn;/** 全选按钮 */
@property (nonatomic, assign) BOOL isEditing;/** 标记是否正在编辑 */
@property (nonatomic, assign, getter = isSelectAll) BOOL selectAll;/** 标记是否被全部选中 */

@end

@implementation SCMyProgramListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    //假数据
    for (int i = 0; i<5; i++) {
        SCFilmModel *filmModel = [[SCFilmModel alloc] init];
        [_dataArray addObject:filmModel];
    }
    
    
    
    
    //1.初始化
    _isEditing = NO;
    
    //2.加载分视图
    [self addRightBBI];
    [self setTableView];
    [self setBottomBtnView];
    
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
        [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SCFilmModel *filmModel = obj;
            filmModel.selected = YES;
        }];
    }else{
        _selectAll = NO;
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SCFilmModel *filmModel = obj;
            filmModel.selected = NO;
        }];
    }
    [_listView reloadData];
    
}

- (void)deleteAll{
    

    
}

- (void)setTableView{
    _listView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.backgroundColor = [UIColor colorWithHex:@"f3f3f3"];
    _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listView.tableFooterView = [UIView new];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        // 1.把model相应的数据删掉
       // [self.members removeObjectAtIndex:indexPath.row];
        
        // 2.把view相应的cell删掉
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
        
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (_isEditing) {//处在编辑状态
        SCFilmModel *filmModel = _dataArray[indexPath.row];
        SCProgramListCell *cell = (SCProgramListCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (filmModel.isSelecting) {
            filmModel.selected = NO;
            //从临时数据中删除
            
        }else{
            filmModel.selected = YES;
            //添加到临时数组中 待确定后从数据库中删除
            

        }
        cell.filmModel = filmModel;
    }
}

@end
