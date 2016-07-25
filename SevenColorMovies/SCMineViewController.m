//
//  SCMineViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/18.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCMineViewController.h"
#import "SCMineTopCell.h"
#import "SCMineOtherCell.h"

@interface SCMineViewController ()

/** leftBarItem 商标 */
@property (nonatomic,strong) UIButton *leftBBI;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation SCMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"dddddd"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setTableView];
    
    //1.商标
    [self addLeftBBI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- private methods
- (void)addLeftBBI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 30);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"BusinessLogo"] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    leftNegativeSpacer.width = -6;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftNegativeSpacer,item, nil];
    _leftBBI = btn;
}

#pragma mark- private methods
- (void)setTableView{
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#F0F1F2"];
//    _tableView.scrollEnabled = NO;
    
}

#pragma mark- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataSource.count > section) {
        NSArray *array = self.dataSource[section];
        return array.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < self.dataSource.count) {
        NSArray *array = self.dataSource[indexPath.section];
        if (indexPath.row < array.count) {
            NSDictionary *dict = [array objectAtIndex:indexPath.row];
            if (indexPath.section == 0) {
                SCMineTopCell *cell = [SCMineTopCell cellWithTableView:tableView];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }else{
                SCMineOtherCell *cell = [SCMineOtherCell cellWithTableView:tableView];
                [cell setModel:dict IndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    return nil;
}

#pragma mark -  UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 90.f;
    else return 56.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"======indexPath.section:%ld",indexPath.section);
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

#pragma mark- Getters and Setters
- (NSArray *)dataSource{
    if (!_dataSource) {
        NSArray *array = @[@[@{@"Default_Avatar" : @"Hi,您好"}],
                           @[@{@"Associator" : @"会员中心"}],
                           @[@{@"Moive_list" : @"我的节目单"}, @{@"Watch_Record" : @"观看记录"}, @{@"Collection" : @"我的收藏"}],
                           @[@{@"Download" : @"下载管理"}],
                           @[@{@"Message" : @"消息"}],
                           @[@{@"Setting" : @"设置"}]];
        _dataSource = array;
    }
    return _dataSource;
}



@end
