//
//  SCFunctionDescriptionVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/5/16.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCFunctionDescriptionVC.h"
#import "SCGroupModel.h"
#import "SCFuncDescriptionCell.h"

static char arrowIVKey;

@interface SCFunctionDescriptionVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *groupDataArray;

@end

@implementation SCFunctionDescriptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 1.初始化Group数据
    [self initialGroupDataSource];
    // 2.加载tableView
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initialGroupDataSource
{
    self.groupDataArray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *jsonDic =@{@"group":
                                 @[
                                     @{@"groupName":@"扫一扫功能说明",@"groupCount":@"1",@"cellHeightOpen":@"1867",@"cellHeightClose":@"0"},
                                     @{@"groupName":@"遥控器功能说明",@"groupCount":@"1",@"cellHeightOpen":@"1867",@"cellHeightClose":@"0"}
                                     ]};
    
    for (NSDictionary *groupDic in jsonDic[@"group"]) {
        SCGroupModel *groupModel = [[SCGroupModel alloc] init];
        groupModel.groupName = groupDic[@"groupName"];
        groupModel.cellHeightOpen = [groupDic[@"cellHeightOpen"] integerValue];
        groupModel.cellHeightClose = [groupDic[@"cellHeightClose"] integerValue];
        groupModel.groupCount = [groupDic[@"groupCount"] integerValue];
        groupModel.isOpened = NO;
        
        [_groupDataArray addObject:groupModel];
    }
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#dddddd"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return _groupDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SCGroupModel *groupModel = _groupDataArray[section];
    return groupModel.isOpened? groupModel.groupCount : 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SCFuncDescriptionCell *cell = [SCFuncDescriptionCell cellWithTableView:tableView];
        cell.contentIV.image = [UIImage imageNamed:@"SaoyisaoContent"];
        return cell;
        
    } else if (indexPath.section == 1) {
        SCFuncDescriptionCell *cell = [SCFuncDescriptionCell cellWithTableView:tableView];
        cell.contentIV.image = [UIImage imageNamed:@"SaoyisaoContent"];
        return cell;
    }
    return nil;
}

#pragma mark -  UITableViewDataDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCGroupModel *groupModel = _groupDataArray[indexPath.section];
    
    return groupModel.isOpened? groupModel.cellHeightOpen : groupModel.cellHeightClose;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self drawSectionHeaderView:section];
}

// headerView
- (UIView *)drawSectionHeaderView:(NSInteger)section
{
    // 大背景
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    headerView.backgroundColor = [UIColor colorWithHex:@"#dddddd"];
 
    // 按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 10, self.view.frame.size.width, 60)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTag:section];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(headerViewPress:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    SCGroupModel *groupModel = _groupDataArray[section];
    titleLabel.text = groupModel.groupName;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17.f];
    [button addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180, 30));
        make.left.equalTo(button).offset(15);
        make.centerY.equalTo(button.mas_centerY);
        
    }];
    
    // 更多
//    UILabel *moreLabel = [[UILabel alloc] init];
//    moreLabel.text = groupModel.isOpened? @"收起" : @"更多";
//    moreLabel.textColor = [UIColor blackColor];
//    moreLabel.font = [UIFont systemFontOfSize:17.f];
//    moreLabel.textAlignment = NSTextAlignmentCenter;
//    //    moreLabel.backgroundColor = [UIColor orangeColor];
//    [headerView addSubview:moreLabel];
//    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(40, 30));
//        make.right.equalTo(headerView).offset(-30);
//        make.centerY.equalTo(headerView.mas_centerY);
//    }];
    
    // 箭头
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow_Right"]];
    // 如果是打开 图片要先旋转 刷新section是会重新调用这里
    if (groupModel.isOpened) {
        arrowIV.transform = CGAffineTransformRotate(arrowIV.transform, M_PI/2); // 在现在的基础上旋转指定角度
    }
    
    // 关联函数
    objc_setAssociatedObject(button, &arrowIVKey, arrowIV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [button addSubview:arrowIV];
    [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.right.equalTo(button).offset(-15);
        make.centerY.equalTo(button.mas_centerY);
        
    }];
    
    return headerView;
}

// sectionHeader点击
- (void)headerViewPress:(UIButton *)sender
{
    SCGroupModel *groupModel = _groupDataArray[sender.tag];
    UIImageView *arrowIV = objc_getAssociatedObject(sender, &arrowIVKey);
    
    if (groupModel.isOpened) {
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            arrowIV.transform = CGAffineTransformRotate(arrowIV.transform, -M_PI/2); // 在现在的基础上旋转指定角度
        } completion:^(BOOL finished) {
        }];
        
    } else {
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            arrowIV.transform = CGAffineTransformRotate(arrowIV.transform, M_PI/2); // 在现在的基础上旋转指定角度
        } completion:^(BOOL finished) {
        }];
        
    }
    groupModel.isOpened = !groupModel.isOpened;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
