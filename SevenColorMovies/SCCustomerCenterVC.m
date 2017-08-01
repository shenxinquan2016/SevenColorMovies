//
//  SCCustomerCenterVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/8/1.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  用户中心

#import "SCCustomerCenterVC.h"
#import "SCCostomerCenterCell.h"

@interface SCCustomerCenterVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation SCCustomerCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.leftBBI.text = @"用户";
    
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor colorWithHex:@"#dddddd"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark- UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArray.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCCostomerCenterCell *cell = [SCCostomerCenterCell cellWithTableView:tableView];
    return cell;
}

#pragma mark -  UITableViewDataDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}

#pragma mark- Getters and Setters

- (NSArray *)dataArray
{
    if (!_dataArray) {
        NSArray *array = @[@{@"ChangeBind" : @"修改绑定"},
                           @{@"ChangePassword" : @"修改密码"},
                           @{@"CustomerUpgrade" : @"用户升级"}];
        _dataArray = array;
    }
    return _dataArray;
}



@end
