//
//  SCThirdLevelVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 2017/3/12.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCThirdLevelVC.h"

@interface SCThirdLevelVC ()

@end

@implementation SCThirdLevelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"便民服务";
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews
{
     if ([self._title isEqualToString:@"水费"]) {
         
         UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"水2"]];
         imageView.frame = CGRectMake(0, 22, kMainScreenWidth, kMainScreenHeight-22);
         [self.view addSubview:imageView];
         
     } else if ([self._title isEqualToString:@"电费"]) {
       
         UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"电费2"]];
         imageView.frame = CGRectMake(0, 22, kMainScreenWidth, kMainScreenHeight-22);
         [self.view addSubview:imageView];
         
     } else if ([self._title isEqualToString:@"燃气费"]) {
         
         UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"燃气费2"]];
         imageView.frame = CGRectMake(0, 22, kMainScreenWidth, kMainScreenHeight-22);
         [self.view addSubview:imageView];
         
     }

}



@end
