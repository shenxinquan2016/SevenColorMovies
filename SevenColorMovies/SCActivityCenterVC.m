//
//  SCActivityCenterVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/21.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  活动详情

#import "SCActivityCenterVC.h"
#import "SCLovelyBabyLoginVC.h"
#import "SCMyLovelyBabyVC.h"

@interface SCActivityCenterVC ()

@property (weak, nonatomic) IBOutlet UIImageView *backGroundIV; // 大背景
@property (weak, nonatomic) IBOutlet UIImageView *bannerIV; // 活动详情图片
@property (weak, nonatomic) IBOutlet UIView *activityRulesView; // 底部视图

@property (weak, nonatomic) IBOutlet UILabel *signUpCondition;
@property (weak, nonatomic) IBOutlet UILabel *singUpConditionLabel2;
@property (weak, nonatomic) IBOutlet UILabel *signUpTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *signUpTimeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *uploadTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadTimeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *pullSupportTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pullSupportTimeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel2;



@end

@implementation SCActivityCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backGroundIV.hidden = YES;
    _activityRulesView.hidden = YES;
    
    [self initializeLabelConfiguration];
    [self getVideoTaskData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initializeLabelConfiguration
{
    [_signUpCondition setFont :[UIFont fontWithName :@"Helvetica-Bold" size :13.f]];
    [_signUpTimeLabel setFont :[UIFont fontWithName :@"Helvetica-Bold" size :13.f]];
    [_uploadTimeLabel setFont :[UIFont fontWithName :@"Helvetica-Bold" size :13.f]];
    [_pullSupportTimeLabel setFont :[UIFont fontWithName :@"Helvetica-Bold" size :13.f]];
    [_releaseTimeLabel setFont :[UIFont fontWithName :@"Helvetica-Bold" size :13.f]];
    
}

- (IBAction)gobackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)joinTheActivity:(id)sender
{
    if (UserInfoManager.lovelyBabyIsLogin) {
        SCMyLovelyBabyVC *myVideoVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCMyLovelyBabyVC");
        [self.navigationController pushViewController:myVideoVC animated:YES];
    } else {
        SCLovelyBabyLoginVC *loginVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCLovelyBabyLoginVC");
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

#pragma mark - Network Request

// 获取任务列表
- (void)getVideoTaskData
{
    NSDictionary *parameters = @{@"siteId"      : @"hlj_appjh",
                                 @"ljwl"        : @"",
                                 @"pageYema"    : @"1",
                                 @"pageSize"    : @"1000"
                                 };
    
    [CommonFunc showLoadingWithTips:@""];
    
    [requestDataManager getRequestJsonDataWithUrl:LovelyBabyVideoTask parameters:parameters success:^(id  _Nullable responseObject) {
        
        DONG_Log(@"responseObject-->%@", responseObject);
        
        if ([responseObject[@"resultCode"] isEqualToString:@"success"]) {
            
            NSArray *taskArr = responseObject[@"data"];
            NSURL *bannerUrl = [NSURL URLWithString:taskArr.firstObject[@"bannerImg"]];
            [_bannerIV sd_setImageWithURL:bannerUrl placeholderImage:[UIImage imageNamed:@""]];
            
        } else {
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
    
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate
{
    return NO;
}

@end
