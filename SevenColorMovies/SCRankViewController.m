//
//  SCRankViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/20.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCRankViewController.h"
#import "SCRankOtherCell.h"
#import "SCTeleplayPlayerVC.h"
#import "SCRankTopRowTableViewCell.h"
#import "SCRankTopRowCollectionViewCell.h"


static  CGFloat const kRankTopCellHeight = 185.f;
static  CGFloat const kRankOtherCellHeight = 50.f;

@interface SCRankViewController()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** tableView数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** section数据源 */
@property (nonatomic, strong) NSMutableArray *sectionArr;

@end

@implementation SCRankViewController

#pragma mark-  ViewLife Cycle
- (void)viewDidLoad {
    //返回按钮
    [self addLeftBBI];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _dataSource = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", nil];
    _sectionArr = [NSMutableArray arrayWithObjects:@"电影排行榜",@"电视剧排行榜",@"动漫排行榜",nil];

//    [self setTableViewRefresh];
}

#pragma mark - 集成刷新
- (void)setTableViewRefresh {
    [CommonFunc setupRefreshWithView:_tableView withSelf:self headerFunc:@selector(headerRefresh) headerFuncFirst:YES footerFunc:nil];
}

- (void)headerRefresh {
    
    
}


#pragma mark- UITableViewDataSource && UITableViewDataDelegate
-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return _sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        SCRankTopRowTableViewCell *cell = [SCRankTopRowTableViewCell cellWithTableView:tableView];
        return cell;
    }else{
        SCRankOtherCell *cell = [SCRankOtherCell cellWithTableView:tableView];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return kRankTopCellHeight;
    }else return kRankOtherCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"======indexPath.section:%ld",indexPath.section);
    SCTeleplayPlayerVC *teleplayPlayer = DONG_INSTANT_VC_WITH_ID(@"HomePage",@"SCTeleplayPlayerVC");
    teleplayPlayer.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:teleplayPlayer animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [self addSectionHeaderViewWithTitle:_sectionArr[section]];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(SCRankTopRowTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
    }
}

#pragma mark  UICollectionViewDataSource && delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SCRankTopRowCollectionViewCell *cell = [SCRankTopRowCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    //    cell.channelName = _selDemandChannelArr[indexPath.row];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了  ---=== %ld",(long)indexPath.item);
//    if (indexPath.row == 7) {
//        SCChannelCatalogueVC *moreView = [[SCChannelCatalogueVC alloc] init];
//        moreView.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:moreView animated:YES];
//    }else{
//        
//        SCChannelCategoryVC *ChannelVC = DONG_INSTANT_VC_WITH_ID(@"HomePage", @"SCChannelCategoryVC");
//        ChannelVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:ChannelVC animated:YES];
//        
//        
//    }
}

#pragma mark- Private methods
//section header
- (UIView *)addSectionHeaderViewWithTitle:(NSString *)title{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50.f)];
    headerView.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
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
    label.text = title;
    [label setFont :[UIFont fontWithName :@"Helvetica-Bold" size :20]];//加粗
    label.font = [UIFont systemFontOfSize:13.f];
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).and.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 21));
        
    }];
    [headerView addSubview:view];
    return headerView;
}

- (void)addLeftBBI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 22);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn setImage:[UIImage imageNamed:@"Back_Arrow"] forState:UIControlStateNormal];
    [btn setTitle: @"排行" forState: UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 19.0];
    [btn setTitleColor:[UIColor colorWithHex:@"#878889"]forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    leftNegativeSpacer.width = -6;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftNegativeSpacer,item, nil];
    _leftBBI = btn;

}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end