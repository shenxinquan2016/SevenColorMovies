//
//  SCDevicesListView.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/10.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCDevicesListView.h"
#import "SCDeviceCell.h"

@interface SCDevicesListView ()<UITableViewDelegate, UITableViewDataSource>

/** 回调回传model */
@property (nonatomic, strong) SCDeviceModel *deviceModel;

@end

@implementation SCDevicesListView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupTableView];
    [self setBottomBtnView];
    self.hidden = YES;
}

- (void)setupTableView
{
    if (!self.tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor colorWithHex:@"f3f3f3"];
        tableView.tableFooterView = [UIView new];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        [self addSubview:tableView];
        _tableView = tableView;
    }
}


//全选 || 删除 按钮视图
- (void)setBottomBtnView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 60, kMainScreenWidth, 60)];
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
    
    //重新扫描按钮
    UIButton *reScanBtn = [[UIButton alloc] init];
    [reScanBtn setTitle:@"重新扫描" forState:UIControlStateNormal];
    reScanBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [reScanBtn addTarget:self action:@selector(reScanDevice) forControlEvents:UIControlEventTouchUpInside];
    [reScanBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bottomView addSubview:reScanBtn];
    [reScanBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(bottomView.mas_left);
        make.bottom.equalTo(bottomView.mas_bottom);
        make.right.equalTo(separateLine);
        
    }];
    
    //链接按钮
    UIButton *connectBtn = [[UIButton alloc] init];
    [connectBtn setTitle:@"连接" forState:UIControlStateNormal];
    connectBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [connectBtn addTarget:self action:@selector(connectToDevice) forControlEvents:UIControlEventTouchUpInside];
    [connectBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bottomView addSubview:connectBtn];
    [connectBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(separateLine);
        make.bottom.equalTo(bottomView.mas_bottom);
        make.right.equalTo(bottomView.mas_right);
    }];
    
    [self addSubview:bottomView];
    
}

- (void)reScanDevice
{
    if (self.scanDeviceBlock) {
        self.scanDeviceBlock();
    }
}

- (void)connectToDevice
{
    if (self.connectTCPBlock) {
        self.connectTCPBlock(_deviceModel);
    }
}

//section header
- (UIView *)addSectionHeaderView
{
    UIView *view = [[UIImageView alloc] init];
    view.frame = CGRectMake(0, 10, kMainScreenWidth, 40.f);
    view.backgroundColor = [UIColor whiteColor];
    //图标
    UIImageView *iv = [[UIImageView alloc] init];
    [iv setImage:[UIImage imageNamed:@"SectionLeftImage"]];
    [view addSubview:iv];
    [iv mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.centerY.equalTo(view.mas_centerY);
        make.size.mas_equalTo(iv.image.size);
    }];
    //标题label
    UILabel *label = [[UILabel alloc] init];
    label.text = @"选择可连接设备";
    [label setFont :[UIFont fontWithName :@"Helvetica-Bold" size :20]];//加粗
    label.font = [UIFont systemFontOfSize:13.f];
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).and.offset(12);
        make.size.mas_equalTo(CGSizeMake(100, 21));
        
    }];
    
    //分割线
    UILabel *separateLinelabel = [[UILabel alloc] init];
    separateLinelabel.backgroundColor = [UIColor colorWithHex:@"#f1f1f2"];
    [view addSubview:separateLinelabel];
    [separateLinelabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view);
        make.left.equalTo(view).and.offset(12);
        make.size.mas_equalTo(CGSizeMake(kMainScreenWidth-12, 1));
        
    }];
    
    return view;
}


#pragma mark - UITableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
//    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCDeviceCell *cell = [SCDeviceCell cellWithTableView:tableView];
    cell.deviceModel = _dataArray[indexPath.row];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self addSectionHeaderView];
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
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    SCDeviceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SCDeviceModel *model = [[SCDeviceModel alloc] init];
//    cell.deviceModel = model;
    DONG_Log(@"cell选中.selected:%d",cell.selected);
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    SCDeviceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SCDeviceModel *model = [[SCDeviceModel alloc] init];
//    cell.deviceModel = model;
    
    DONG_Log(@"cell取消选中.selected:%d",cell.selected);
}

@end
