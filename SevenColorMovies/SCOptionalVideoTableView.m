//
//  SCSearchTableViewController.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCOptionalVideoTableView.h"
#import "SCOptionalVideoTableViewCell.h"



@interface SCOptionalVideoTableView ()

//@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *keyWord;/** 键盘输入的内容 */

@end

@implementation SCOptionalVideoTableView

NSString *identifier;
+ (instancetype)initTableViewWithIdentifier:(NSString *)tag{
    SCOptionalVideoTableView *tableView = [[SCOptionalVideoTableView alloc] init];
    identifier = tag;
    return tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    //集成上拉加载更多
    [self setTableViewRefresh];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 集成刷新
- (void)setTableViewRefresh {
    [CommonFunc setupRefreshWithView:self.tableView withSelf:self headerFunc:nil headerFuncFirst:YES footerFunc:@selector(footerRefresh)];
}

- (void)footerRefresh{
    
    [self  getVODSearchResultDataWithFilmName:self.keyWord Page:_page++ CallBack:^(id obj) {
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCOptionalVideoTableViewCell *cell = [SCOptionalVideoTableViewCell cellWithTableView:tableView];
    cell.filmModel = self.dataSource[indexPath.row];
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 164;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"======indexPath.section:%ld",indexPath.section);
}


#pragma mark- 网络请求
- (void)getVODSearchResultDataWithFilmName:(NSString *)keyword Page:(NSInteger)pageNumber CallBack:(CallBack)callBack{
    
    self.keyWord = keyword;//保存keyword 供加载更多时使用
    
    if (pageNumber == 1) {
        [_dataSource removeAllObjects];
    }
    NSDictionary *parameters = @{@"keyword" : keyword,
                                 @"pg" : [NSString stringWithFormat:@"%zd",pageNumber]};
    
    [requestDataManager requestDataWithUrl:SearchVODUrl parameters:parameters success:^(id  _Nullable responseObject) {
        
//        NSLog(@"==========dic:::%@========",responseObject);
        
        if ([responseObject[@"movieinfo"] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dic = responseObject[@"movieinfo"];
            SCFilmModel *filmModel = [SCFilmModel mj_objectWithKeyValues:dic];
            if (filmModel) {
                [_dataSource addObject:filmModel];
            }
            
        }else if ([responseObject[@"movieinfo"] isKindOfClass:[NSArray class]]){
            
            for (NSDictionary *dic in responseObject[@"movieinfo"]) {
                
                SCFilmModel *filmModel = [SCFilmModel mj_objectWithKeyValues:dic];
                if (filmModel) {
                    [_dataSource addObject:filmModel];
                }
            }
        }
        
        //总的搜索条数
        NSString *VODTotalCount ;
        if (responseObject[@"_dbtotal"]) {
            VODTotalCount = responseObject[@"_dbtotal"];
        }else{
            VODTotalCount = @"0";
        }
        
        callBack(VODTotalCount);
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];

        if (_dataSource.count == 0) {
            [CommonFunc noDataOrNoNetTipsString:@"暂无结果" addView:self.view];
        }else{
            [CommonFunc hideTipsViews:self.tableView];
        }
        
        [CommonFunc mj_FooterViewHidden:self.tableView dataArray:_dataSource pageMaxNumber:4 responseObject:responseObject[@"movieinfo"]];
        
    } failure:^(id  _Nullable errorObject) {
        //总的搜索条数
        NSString *VODTotalCount = @"0";
        callBack(VODTotalCount);
        [self.tableView reloadData];
        [CommonFunc noDataOrNoNetTipsString:@"暂无结果" addView:self.view];
        [self.tableView.mj_footer endRefreshing];
        [CommonFunc dismiss];
    }];
    
    
}

@end
