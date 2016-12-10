//
//  SCSearchEquipmentVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/9.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCSearchEquipmentVC.h"
#import "SCRemoteHelpPageVC.h"

@interface SCSearchEquipmentVC ()

@end

@implementation SCSearchEquipmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    //1.标题
    self.leftBBI.text = @"遥控器";
    
    [self addRightBBI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
@end
