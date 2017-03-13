//
//  SCJiaotongVC1.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/3/12.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCJiaotongVC1.h"
#import "SCJiaotongVC2.h"

@interface SCJiaotongVC1 ()

@end

@implementation SCJiaotongVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"便民服务";
    
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setupViews
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"交通违章1"]];
    imageView.frame = CGRectMake(0, 17, kMainScreenWidth, kMainScreenHeight-17);
    [self.view addSubview:imageView];
    
    // 高速缴罚
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(80, kMainScreenHeight-590, kMainScreenWidth-90, 65)];
    
    btn1.backgroundColor = [UIColor clearColor];
//    btn1.backgroundColor = [UIColor colorWithHex:@"#1F90E6"];
    [btn1 addTarget:self action:@selector(goGaosu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    // 道路交通罚款
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(80, kMainScreenHeight-505, kMainScreenWidth-90, 65)];
    btn2.backgroundColor = [UIColor clearColor];
//     btn2.backgroundColor = [UIColor colorWithHex:@"#1F90E6"];
    [btn2 addTarget:self action:@selector(goDaolujiaotong) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    // 违章停车缴费
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(80, kMainScreenHeight-410, kMainScreenWidth-90, 65)];
    btn3.backgroundColor = [UIColor clearColor];
//    btn3.backgroundColor = [UIColor colorWithHex:@"#1F90E6"];
    
    [btn3 addTarget:self action:@selector(goWeizhangtingche) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
}

- (void)goGaosu
{
    DONG_Log(@"高速缴罚");
    SCJiaotongVC2 *thirdLevel  = [[SCJiaotongVC2 alloc] initWithWithTitle:self._title];
    thirdLevel.titleStr = @"高速缴罚";
    [self.navigationController pushViewController:thirdLevel animated:YES];
}

- (void)goDaolujiaotong
{
    DONG_Log(@"道路交通");
    SCJiaotongVC2 *thirdLevel  = [[SCJiaotongVC2 alloc] initWithWithTitle:self._title];
    thirdLevel.titleStr = @"道路交通";
    [self.navigationController pushViewController:thirdLevel animated:YES];
}

- (void)goWeizhangtingche
{
    DONG_Log(@"违章停车");
    SCJiaotongVC2 *thirdLevel  = [[SCJiaotongVC2 alloc] initWithWithTitle:self._title];
    thirdLevel.titleStr = @"违章停车";
    [self.navigationController pushViewController:thirdLevel animated:YES];
}

// 禁止旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}

@end
