//
//  SCCustomerCenterVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/8/1.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  用户中心

#import "SCCustomerCenterVC.h"
#import "SCCostomerCenterCell.h"
#import "SCChangeBindVC.h"
#import "SCChangePasswordVC.h"
#import "SCCustomerUpGradeVC.h"


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
    
    [cell setModel:self.dataArray IndexPath:indexPath];
    return cell;
}

#pragma mark -  UITableViewDataDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger number = indexPath.row;
    switch (number) {
        case 0: {
            SCChangeBindVC *changeBindVC = DONG_INSTANT_VC_WITH_ID(@"Mine", @"SCChangeBindVC");
            [self.navigationController pushViewController:changeBindVC animated:YES];
        }
            break;
            
        case 1: {
            SCChangePasswordVC *changePasswordVC = DONG_INSTANT_VC_WITH_ID(@"Mine", @"SCChangePasswordVC");
            [self.navigationController pushViewController:changePasswordVC animated:YES];
        }
            break;
            
        case 2: {
            SCCustomerUpGradeVC *upGradeVC = DONG_INSTANT_VC_WITH_ID(@"Mine", @"SCCustomerUpGradeVC");
            [self.navigationController pushViewController:upGradeVC animated:YES];
        } 
            break;
            
        default:
            break;
    }
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
        NSArray *dataArray = @[@{@"ChangeBind" : @"修改绑定"},
                               @{@"ChangePassword" : @"修改密码"},
                             @{@"CustomerUpgrade" : @"用户升级"}];
        _dataArray = dataArray;
    }
    
    return _dataArray;
}



@end
