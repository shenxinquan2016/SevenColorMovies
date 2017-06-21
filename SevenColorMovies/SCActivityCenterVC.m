//
//  SCActivityCenterVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/21.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCActivityCenterVC.h"
#import "SCLovelyBabyLoginVC.h"
#import "SCMyLovelyBabyVC.h"

@interface SCActivityCenterVC ()

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
    
    [self initializeLabelConfiguration];
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


@end
