//
//  SCMyDownloadManagerVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/14.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCMyDownloadManagerVC.h"
#import "SCMyDownLoadManagerCell.h"//正在下载cell
#import "SCDownloadedCell.h"//下载完成时的cell

#import "SCFilmModel.h"
#import "Dong_DownloadManager.h"//下载器
#import "Dong_DownloadModel.h"//下载数据模型
#import "ZFDownloadManager.h"//第三方下载工具
#import "SCHuikanPlayerViewController.h"

#define  DownloadManager  [ZFDownloadManager sharedDownloadManager]

@interface SCMyDownloadManagerVC () <UITableViewDelegate, UITableViewDataSource, ZFDownloadDelegate>

@property (nonatomic, strong) UIButton *editBtn;/** 编辑按钮 */
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *bottomBtnView;
@property (nonatomic, strong) UIButton *selectAllBtn;/** 全选按钮 */
@property (nonatomic, assign) BOOL isEditing;/** 标记是否正在编辑 */
@property (nonatomic, assign, getter = isSelectAll) BOOL selectAll;/** 标记是否被全部选中 */
@property (nonatomic, strong) NSMutableArray *tempArray;/** 保存临时选择的要删除的filmModel */

@property (atomic, strong) NSMutableArray *downloadObjectArr;

@end

@implementation SCMyDownloadManagerVC

{
    UIImageView *downloadIV_;
    UILabel *headerTitlelabel_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    DownloadManager.downloadDelegate = self;
    
    //3.初始化
    _isEditing = NO;
    self.tempArray = [NSMutableArray arrayWithCapacity:0];
    
    //4.加载分视图
    //4.1 编辑按钮
    [self addRightBBI];
    
    //4.3 全选/删除
    [self setBottomBtnView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // 更新数据源
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Private Method
- (void)initData {
    [DownloadManager startLoad];
    NSMutableArray *downladed = DownloadManager.finishedlist;
    NSMutableArray *downloading = DownloadManager.downinglist;
    self.downloadObjectArr = @[].mutableCopy;
    [self.downloadObjectArr addObject:downladed];
    [self.downloadObjectArr addObject:downloading];
    
    if ([_downloadObjectArr.firstObject count] == 0 && [_downloadObjectArr.lastObject count] == 0) {
        [CommonFunc noDataOrNoNetTipsString:@"还没有下载任何视频哦" addView:self.view];
    }else{
        [CommonFunc hideTipsViews:_listView];
        // 4.2 tableview
        [self setTableView];
    }
}

//全选 || 删除 按钮视图
- (void)setBottomBtnView {
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
    [deleteAllBtn addTarget:self action:@selector(deleteSelected) forControlEvents:UIControlEventTouchUpInside];
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

- (void)selcetAll {
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

- (void)deleteSelected {
    //1.从数据库中删除数据
    NSMutableArray *indexPathArray = [NSMutableArray arrayWithCapacity:0];
    [_tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SCFilmModel *filmModel = obj;
        NSInteger index = [_dataArray indexOfObject:filmModel];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [indexPathArray addObject:indexPath];
    }];
    [_dataArray removeObjectsInArray:_tempArray];
    // 2.把view相应的cell删掉
    [_listView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    [_tempArray removeAllObjects];
    [indexPathArray removeAllObjects];
}

- (void)setTableView {
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.backgroundColor = [UIColor colorWithHex:@"f3f3f3"];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.tableFooterView = [UIView new];
        _listView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        [self setTableViewTopButton];
        [self.view addSubview:_listView];
        //4.3 全选/删除
        [self setBottomBtnView];
    } else {
        [self.listView reloadData];
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

- (void)doEditingAction {
    NSMutableArray *downladed = DownloadManager.finishedlist;
    NSMutableArray *downloading = DownloadManager.downinglist;
    
    if (_editBtn.selected == NO) {//正在编辑
        _isEditing = YES;
        _editBtn.selected = YES;
        [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
        //        [_listView setEditing:YES];
        //        _listView.allowsMultipleSelectionDuringEditing = YES;
        [UIView animateWithDuration:0.2f animations:^{
            [_bottomBtnView setFrame:(CGRect){0, kMainScreenHeight-60, kMainScreenWidth, 60}];
        }];
        // 已下载
        [downladed enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZFFileModel *fileInfo = obj;
            fileInfo.showDeleteBtn = YES;
        }];
        // 正在下载
        [downloading enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZFHttpRequest *request = obj;
            ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
            fileInfo.showDeleteBtn = YES;
        }];
        [_listView reloadData];
        
    } else if (_editBtn.selected != NO){//完成编辑
        _isEditing = NO;
        _editBtn.selected = NO;
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        //[_listView setEditing:NO];
        [UIView animateWithDuration:0.2f animations:^{
            [_bottomBtnView setFrame:(CGRect){0, kMainScreenHeight, kMainScreenWidth, 60}];
        }];
        
        // 已下载
        [downladed enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZFFileModel *fileInfo = obj;
            fileInfo.showDeleteBtn = NO;
        }];
        // 正在下载
        [downloading enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZFHttpRequest *request = obj;
            ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
            fileInfo.showDeleteBtn = NO;
        }];
        [_listView reloadData];
    }
    
}

- (void)setTableViewTopButton {
    UIView *view = [[UIImageView alloc] init];
    view.frame = CGRectMake(0, 0, kMainScreenWidth, 40.f);
    view.backgroundColor = [UIColor whiteColor];
    
    //下载图标
    UIImageView *downLoadIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DownLoadIMG"]];
    [view addSubview:downLoadIV];
    [downLoadIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).and.offset(12);
        make.size.mas_equalTo(CGSizeMake(21, 21));
        
    }];
    
    //全部开始
    UILabel *headerTitlelabel = [[UILabel alloc] init];
    headerTitlelabel.text = @"全部开始";
    headerTitlelabel.font = [UIFont systemFontOfSize:15];
    headerTitlelabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:headerTitlelabel];
    [headerTitlelabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(downLoadIV.mas_right).and.offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 21));
        
    }];
    
    downloadIV_ = downLoadIV;
    headerTitlelabel_ = headerTitlelabel;
    
    //header点击手势
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginOrPauseDownload)];
    [view addGestureRecognizer:headerTap];
    view.userInteractionEnabled = YES;
    //把View添加到tableHeaderView上
    self.listView.tableHeaderView = view;
}

BOOL isLoading = NO;
- (void)beginOrPauseDownload {
    
    if (isLoading) {
        isLoading = !isLoading;
        [downloadIV_ setImage:[UIImage imageNamed:@"DownLoadIMG"]];
        [headerTitlelabel_ setText:@"全部开始"];
        [DownloadManager pauseAllDownloads];
    }else{
        isLoading = !isLoading;
        [downloadIV_ setImage:[UIImage imageNamed:@"PauseDownload"]];
        [headerTitlelabel_ setText:@"全部暂停"];
        [DownloadManager startAllDownloads];
    }
}

#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return _dataArray.count;
    //return [Dong_DownloadManager sharedManager].downloadModels.count;
    NSArray *sectionArray = self.downloadObjectArr[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    SCFilmModel *filmModel =  _dataArray[indexPath.row];
    //    cell.filmModel = filmModel;
    //
    //    //此处为点击cell的downloadBtn的block回调
    //    DONG_WeakSelf(cell);
    //    cell.downloadBlock = ^{
    //        DONG_StrongSelf(cell);
    //        filmModel.isDownLoading = !filmModel.isDownLoading;
    //        strongcell.filmModel = filmModel;
    //    };
    
    
    //    Dong_DownloadModel *downloadModel = [Dong_DownloadManager sharedManager].downloadModels[indexPath.row];
    //    cell.downloadModel = downloadModel;
    //
    //    //下载状态的回调
    //    downloadModel.onStatusChanged = ^(Dong_DownloadModel *changedModel) {
    //        cell.downloadModel = changedModel;
    //    };
    //    //下载进度的回调
    //    downloadModel.onProgressChanged = ^(Dong_DownloadModel *changedModel) {
    //        cell.downloadModel = changedModel;
    //    };
    //
    //    //此处为点击cell的downloadBtn的block回调
    //    DONG_WeakSelf(cell);
    //    cell.downloadBlock = ^{
    //        DONG_StrongSelf(cell);
    //        downloadModel.isDownLoading = !downloadModel.isDownLoading;
    //        strongcell.downloadModel = downloadModel;
    //    };
    
    if (indexPath.section == 0) {
        SCDownloadedCell *cell = [SCDownloadedCell cellWithTableView:tableView];
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        cell.fileInfo = fileInfo;
        return cell;
        
    } else if (indexPath.section == 1) {
        SCMyDownLoadManagerCell *cell = [SCMyDownLoadManagerCell cellWithTableView:tableView];
        
        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        if (request == nil) { return nil; }
        ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
        
        //此处为点击cell的downloadBtn的block回调
        // 下载按钮点击时候的要刷新列表
        DONG_WeakSelf(self);
        cell.downloadBlock = ^{
            DONG_StrongSelf(self);
            [strongself initData];
        };
        // 下载模型赋值
        cell.fileInfo = fileInfo;
        // 下载的request
        cell.request = request;
        
        return cell;
    }
    return nil;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"全部开始";
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
        
        
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    } else {
        return 80;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

//将delete改为删除
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_isEditing) {//处在编辑状态
        if (indexPath.section == 0) {
            SCDownloadedCell *cell = (SCDownloadedCell *)[tableView cellForRowAtIndexPath:indexPath];
            ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
            if (fileInfo.isSelecting) {
                fileInfo.selected = NO;
                //从临时数据中删除
                [_tempArray removeObject:fileInfo];
            }else{
                fileInfo.selected = YES;
                //添加到临时数组中 待确定后从数据库中删除
                [_tempArray addObject:fileInfo];
            }
            cell.fileInfo = fileInfo;
            
        } else if (indexPath.section == 1) {
            SCMyDownLoadManagerCell *cell = (SCMyDownLoadManagerCell *)[tableView cellForRowAtIndexPath:indexPath];
            ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
            if (request == nil) { return; }
            ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
            
            if (fileInfo.isSelecting) {
                fileInfo.selected = NO;
                //从临时数据中删除
                [_tempArray removeObject:fileInfo];
            }else{
                fileInfo.selected = YES;
                //添加到临时数组中 待确定后从数据库中删除
                [_tempArray addObject:fileInfo];
                
            }
            cell.fileInfo = fileInfo;
            
        }else{//非编辑状态 播放
            
            if (indexPath.section == 0) {
                ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
                if ([FileManageCommon IsFileExists:FILE_PATH(fileInfo.fileName)]) {
                    DONG_Log(@"FileManageCommon路径存在");
                    SCHuikanPlayerViewController *playerVC = [SCHuikanPlayerViewController initPlayerWithFilePath:FILE_PATH(fileInfo.fileName)];
                    [self.navigationController pushViewController:playerVC animated:YES];
                } else {
                    [MBProgressHUD showSuccess:@"文件不存在"];
                }
            }
        }
    }
}

#pragma mark - ZFDownloadDelegate
// 开始下载
- (void)startDownload:(ZFHttpRequest *)request {
    NSLog(@"开始下载!");
}

// 下载中
- (void)updateCellProgress:(ZFHttpRequest *)request {
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}

// 下载完成
- (void)finishedDownload:(ZFHttpRequest *)request {
    [self initData];
}

// 更新下载进度
- (void)updateCellOnMainThread:(ZFFileModel *)fileInfo {
    NSArray *cellArr = [self.listView visibleCells];
    for (id obj in cellArr) {
        if([obj isKindOfClass:[SCMyDownLoadManagerCell class]]) {
            SCMyDownLoadManagerCell *cell = (SCMyDownLoadManagerCell *)obj;
            if([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL]) {
                cell.fileInfo = fileInfo;
            }
        }
    }
}

@end
