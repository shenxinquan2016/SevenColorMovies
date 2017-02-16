//
//  SCPastVideoTableView.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/21.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCPastVideoTableView.h"
#import "SCPastVideoTableViewCell.h"
#import "SCLiveProgramModel.h"
#import "SCHuikanPlayerViewController.h"

@interface SCPastVideoTableView ()

/** channel Logo字典 */
@property (nonatomic, strong) NSMutableDictionary *channelLogoDictionary;
/** 键盘输入的内容 */
@property (nonatomic, copy) NSString *keyWord;
/** ip转换工具 */
@property (nonatomic, strong) HLJRequest *hljRequest;
/** 动态域名获取工具 */
@property (nonatomic, strong) SCDomaintransformTool *domainTransformTool;

@end

@implementation SCPastVideoTableView

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
    
    [self  getProgramHavePastSearchResultWithFilmName:self.keyWord Page:_page++ CallBack:^(id obj) {
        
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
    
    SCPastVideoTableViewCell *cell = [SCPastVideoTableViewCell cellWithTableView:tableView];
    cell.programModel = _dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 94;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCHuikanPlayerViewController *playerVC = [SCHuikanPlayerViewController initPlayerWithProgramModel:_dataSource[indexPath.row]];
    [self.navigationController pushViewController:playerVC animated:YES];
    
}

#pragma mark- 网络请求
// 获取搜索结果+台标
- (void)getSearchResultAndChannelLogoWithFilmName:(NSString *)keyword Page:(NSInteger)pageNumber CallBack:(CallBack)callBack{
    
    [CommonFunc showLoadingWithTips:@""];
    
    // 获取台标
    // 域名获取
    _domainTransformTool = [[SCDomaintransformTool alloc] init];
    [_domainTransformTool getNewDomainByUrlString:GetChannelLogoUrl key:@"skhkjmd" success:^(id  _Nullable newUrlString) {
        
        DONG_Log(@"newUrlString:%@",newUrlString);
        // ip转换
        _hljRequest = [HLJRequest requestWithPlayVideoURL:newUrlString];
        [_hljRequest getNewVideoURLSuccess:^(NSString *newVideoUrl) {
            
            DONG_Log(@"newVideoUrl:%@",newVideoUrl);
            
            [requestDataManager requestDataWithUrl:newVideoUrl parameters:nil success:^(id  _Nullable responseObject) {
                
                DONG_Log(@"==========dic:::%@========",responseObject);
                
                self.channelLogoDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
                [_channelLogoDictionary removeAllObjects];
                
                NSArray *array1 = responseObject[@"LiveLookback"];
                for (NSDictionary *dic1 in array1) {
                    
                    if ([dic1[@"ContentSet"][@"Content"] isKindOfClass:[NSArray class]]) {
                        
                        NSArray *array2 = dic1[@"ContentSet"][@"Content"];
                        for (NSDictionary *dic2 in array2) {
                            
                            NSString *key = dic2[@"_ChannelName"] ?  dic2[@"_ChannelName"] : @"1";
                            NSString *value = dic2[@"ImgUrl"] ? dic2[@"ImgUrl"] : @"1";
                            [self.channelLogoDictionary setObject:value forKey:key];
                        }
                    }
                }
                
                // 获取搜索结果
                [self getProgramHavePastSearchResultWithFilmName:keyword Page:pageNumber CallBack:^(id obj) {
                    
                    callBack(obj);
                }];
                
            } failure:^(id  _Nullable errorObject) {
                
                [CommonFunc dismiss];
            }];
            
        } failure:^(NSError *error) {
            
            [CommonFunc dismiss];
            
        }];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
        
    }];
    
    
}

// 获取搜索结果
- (void)getProgramHavePastSearchResultWithFilmName:(NSString *)keyword Page:(NSInteger)pageNumber CallBack:(CallBack)callBack{
    
    self.keyWord = keyword;//保存keyword 供加载更多时使用
    
    if (pageNumber == 1) {
        [_dataSource removeAllObjects];
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *thisWeek = [now dateByAddingTimeInterval: -7*24*3600];
    NSString *startTime = [formatter stringFromDate:thisWeek];
    NSString *endTime = [formatter stringFromDate:now];
    
    DONG_Log(@"startTime:%@ \nendTime:%@",startTime,endTime);
    
    NSString *statrTimeStr = [startTime stringByTrimmingBlank];
    NSString *endTimeStr = [endTime stringByTrimmingBlank];
    
    NSDictionary *parameters = @{@"keyword" : keyword? keyword : @"",
                                 @"starttime" : statrTimeStr,
                                 @"endtime" : endTimeStr,
                                 @"pg" : [NSString stringWithFormat:@"%zd",pageNumber]};
    
    // 域名获取
    
    
    NSString *domainUrl = [_domainTransformTool getNewViedoURLByUrlString:SearchProgramHavePastUrl key:@"PlayBackSearch"];
    DONG_Log(@"domainUrl:%@",domainUrl);
    // ip转换
    NSString *newVideoUrl = [_hljRequest getNewViedoURLByOriginVideoURL:domainUrl];
    DONG_Log(@"newVideoUrl:%@",newVideoUrl);
    
    [requestDataManager requestDataWithUrl:newVideoUrl parameters:parameters success:^(id  _Nullable responseObject) {
        
        DONG_Log(@"==========dic:::%@========",responseObject);
        
        if ([responseObject[@"program"] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dic = responseObject[@"program"];
            SCLiveProgramModel *programModel = [SCLiveProgramModel mj_objectWithKeyValues:dic];
            
            [_dataSource addObject:programModel];
            
            
        }else if ([responseObject[@"program"] isKindOfClass:[NSArray class]]){
            
            for (NSDictionary *dic in responseObject[@"program"]) {
                
                SCLiveProgramModel *programModel = [SCLiveProgramModel mj_objectWithKeyValues:dic];
                programModel.channelLogoUrl = [self.channelLogoDictionary objectForKey:programModel.tvchannelen];
                //                DONG_Log(@"%@",programModel.tvid);
                [_dataSource addObject:programModel];
            }
        }
        
        //总的搜索条数
        NSString *lookBackVideoTotalCount ;
        if (responseObject[@"_dbtotal"]) {
            lookBackVideoTotalCount = responseObject[@"_dbtotal"];
        }else{
            lookBackVideoTotalCount = @"0";
        }
        callBack(lookBackVideoTotalCount);
        
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        [CommonFunc dismiss];
        
        if (_dataSource.count == 0) {
            [CommonFunc hideTipsViews:self.tableView];
            [CommonFunc noDataOrNoNetTipsString:@"暂无结果" addView:self.view];
        }else{
            [CommonFunc hideTipsViews:self.tableView];
        }
        
        [CommonFunc mj_FooterViewHidden:self.tableView dataArray:_dataSource pageMaxNumber:40 responseObject:responseObject[@"program"]];
        
    } failure:^(id  _Nullable errorObject) {
        
        //总的搜索条数
        NSString *VODTotalCount = @"0";
        callBack(VODTotalCount);
        [self.tableView reloadData];
        [CommonFunc hideTipsViews:self.tableView];
        [CommonFunc noDataOrNoNetTipsString:@"暂无结果" addView:self.view];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = YES;
        [CommonFunc dismiss];
    }];
    
    
}


@end
