//
//  SCLovelyBabyRecordVideoVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/6/23.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  视频录制

#import "SCLovelyBabyRecordVideoVC.h"

@interface SCLovelyBabyRecordVideoVC ()

@end

@implementation SCLovelyBabyRecordVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置navigationBar上的title颜色和大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    self.title = @"00:01:00";
    
    // 导航栏按钮
    [self addBBI];
    
   
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置导航栏的主题(效果只作用当前页面）
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.edgesForExtendedLayout = 0;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)addBBI
{
    // 左边
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 32)];
    //    view.backgroundColor = [UIColor redColor];
    // 返回箭头
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Back_Arrow_White"]];
    [view addSubview:imgView];
    //    imgView.backgroundColor = [UIColor grayColor];
    [imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(10, 17));
        
    }];
    // 返回标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 22)];
    //    titleLabel.backgroundColor = [UIColor greenColor];
    
    titleLabel.textColor = [UIColor colorWithHex:@"#878889"];
    titleLabel.font = [UIFont systemFontOfSize: 19.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleLabel];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(imgView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(125, 22));
        
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    [view addGestureRecognizer:tap];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    leftNegativeSpacer.width = -6;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftNegativeSpacer,item, nil];
    
    // 右边
    // 闪光灯
    UIButton *flashBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,25)];
    [flashBtn setImage:[UIImage imageNamed:@"FlashSwitch"] forState:UIControlStateNormal];
    [flashBtn addTarget:self action:@selector(switchFlash) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *flashBtnBarItem = [[UIBarButtonItem alloc] initWithCustomView:flashBtn];
    // 切换镜头
    UIButton *switchCameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,25,20)];
    [switchCameraBtn setImage:[UIImage imageNamed:@"CameraSwitch"] forState:UIControlStateNormal];
    [switchCameraBtn addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *switchCameraBarItem = [[UIBarButtonItem alloc] initWithCustomView:switchCameraBtn];
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    rightNegativeSpacer.width = 5;
    UIBarButtonItem *rightNegativeSpacer2 = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer2.width = 20;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer, switchCameraBarItem,rightNegativeSpacer2,  flashBtnBarItem,  nil];
}

- (void)switchFlash
{
    DONG_Log(@"闪光灯");
}

- (void)switchCamera
{
    DONG_Log(@"摄像头");
}

@end
