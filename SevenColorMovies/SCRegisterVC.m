//
//  SCRegisterVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/7/31.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCRegisterVC.h"

@interface SCRegisterVC ()

@end

@implementation SCRegisterVC

- (void)awakeFromNib
{
    [super awakeFromNib];
    DONG_Log(@"🔴%s 第%d行\n\n",__func__, __LINE__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DONG_Log(@"🔴%s 第%d行\n\n",__func__, __LINE__);
    self.leftBBI.text = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
