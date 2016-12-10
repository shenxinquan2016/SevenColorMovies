//
//  SCSearchDeviceVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCSearchDeviceVC.h"
#import "SCRemoteHelpPageVC.h"
#import "SCSearchingDeviceView.h"
#import "SCNoDeviceView.h"
#import "SCDevicesListView.h"

@interface SCSearchDeviceVC ()

@property (nonatomic, strong) SCSearchingDeviceView *searchingView;
@property (nonatomic, strong) SCNoDeviceView *noDeviceView;
@property (nonatomic, strong) SCDevicesListView *devicesListView;

@end

@implementation SCSearchDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    //1.标题
    self.leftBBI.text = @"遥控器";
    
    [self addRightBBI];
    
    [self loadSubViewsFromXib];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - priva method

- (void)addRightBBI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 25, 25);
    
    [btn setImage:[UIImage imageNamed:@"Romote_Help"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"Romote_Help_Click"] forState:UIControlStateHighlighted];
    btn.enlargedEdge = 5.f;
    [btn addTarget:self action:@selector(toHelpPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];
}

- (void)toHelpPage
{
    SCRemoteHelpPageVC *helpPage = DONG_INSTANT_VC_WITH_ID(@"Discovery", @"SCRemoteHelpPageVC");
    [self.navigationController pushViewController:helpPage animated:YES];
}

- (void)loadSubViewsFromXib
{
    _searchingView = [[NSBundle mainBundle] loadNibNamed:@"SCSearchingDeviceView" owner:nil options:nil][0];
    _noDeviceView = [[NSBundle mainBundle] loadNibNamed:@"SCNoDeviceView" owner:nil options:nil][0];
    _devicesListView = [[NSBundle mainBundle] loadNibNamed:@"SCDevicesListView" owner:nil options:nil][0];
    
    [_searchingView setFrame:self.view.bounds];
    [_noDeviceView setFrame:self.view.bounds];
    [_devicesListView setFrame:self.view.bounds];
    
    [self.view addSubview:_searchingView];
    [self.view addSubview:_noDeviceView];
//    [self.view addSubview:_devicesListView];

}


@end
