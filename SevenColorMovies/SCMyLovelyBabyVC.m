//
//  SCMyLovelyBabyVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/21.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  我的视频

#import "SCMyLovelyBabyVC.h"
#import "SCLovelyBabyLoginVC.h"

@interface SCMyLovelyBabyVC ()

@end

@implementation SCMyLovelyBabyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftBBI.text = @"我的视频";
    
    [self getMyVideoDataRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - NetworkRequest

- (void)getMyVideoDataRequest
{
    NSDictionary *parameters = @{@"siteId"      : @"hlj_appjh",
                                 @"memberId"    : UserInfoManager.lovelyBabyMemberId,
                                 @"searchName"  : @"",
                                 @"searchType"  : @"paike",
                                 @"pageYema"    : @"1",
                                 @"pageSize"    : @"500",
                                 @"token"       : UserInfoManager.lovelyBabyToken
                                 };
    
    [CommonFunc showLoadingWithTips:@""];
    [requestDataManager getRequestJsonDataWithUrl:LovelyBabyVideoList parameters:parameters success:^(id  _Nullable responseObject) {
        DONG_Log(@"responseObject-->%@",responseObject);
        NSString *resultCode = responseObject[@"resultCode"];
        
        if ([resultCode isEqualToString:@"success"]) {
            
            
            
        } else if ([resultCode isEqualToString:@"tokenInvalid"]) {
            
            UserInfoManager.lovelyBabyIsLogin = NO;
            [UserInfoManager removeUserInfo];
            SCLovelyBabyLoginVC *loginVC = DONG_INSTANT_VC_WITH_ID(@"LovelyBaby", @"SCLovelyBabyLoginVC");
            [self.navigationController pushViewController:loginVC animated:YES];
            
        } else {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
        }
        
        [CommonFunc dismiss];
        
    } failure:^(id  _Nullable errorObject) {
        
        [CommonFunc dismiss];
    }];
}


@end
