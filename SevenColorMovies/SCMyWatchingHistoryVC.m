//
//  SCMyWatchingHistoryVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/10/14.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCMyWatchingHistoryVC.h"

@interface SCMyWatchingHistoryVC ()

@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation SCMyWatchingHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightBBI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Private Method
- (void)addRightBBI {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 45, 23);
    
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.enlargedEdge = 5.f;
    [btn.layer setBorderWidth:1.5f];
    [btn.layer setBorderColor:[UIColor grayColor].CGColor];
    [btn addTarget:self action:@selector(doEditingAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -4;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightNegativeSpacer,item, nil];
    _editBtn = btn;
    _editBtn.selected = NO;
}

- (void)doEditingAction{
    if (_editBtn.selected == NO) {
        _editBtn.selected = YES;
        [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
        
    }else if (_editBtn.selected != NO){
        _editBtn.selected = NO;
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        
        NSLog(@">>>>>>>>>>完成编辑>>>>>>>>>>>>");
    }
}
@end
