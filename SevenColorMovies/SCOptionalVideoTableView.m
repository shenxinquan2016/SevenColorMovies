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
@property (nonatomic,assign) NSInteger page;/**< 分页标签 */

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
    
    //集成上拉加载更多
    [self setTableViewRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 集成刷新
- (void)setTableViewRefresh {
    [CommonFunc setupRefreshWithView:self.tableView withSelf:self headerFunc:@selector(headerRefresh) headerFuncFirst:YES footerFunc:@selector(footerRefresh)];
}

- (void)headerRefresh {
    
}

- (void)footerRefresh {
//    _page++;
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
        SCOptionalVideoTableViewCell *cell = [SCOptionalVideoTableViewCell cellWithTableView:tableView];
    
    
        return cell;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
        return 164;
        
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"======indexPath.section:%ld",indexPath.section);
}

#pragma mark- 网络请求
- (void)getVODSearchResultDataWithFilmName:(NSString *)keyword Page:(NSInteger)pageNumber{
    
    [CommonFunc showLoadingWithTips:@""];
    
    
    
    NSDictionary *parameters = @{@"keyword" : keyword,
                                 @"page" : [NSString stringWithFormat:@"%zd",pageNumber]};
    
    [requestDataManager requestDataWithUrl:SearchVODUrl parameters:parameters success:^(id  _Nullable responseObject) {
        
        NSLog(@"==========dic:::%@========",responseObject);
        

        
        
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
    
    
    
    
    
    
}



@end
