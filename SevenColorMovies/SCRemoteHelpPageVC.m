//
//  SCRemoteHelpPageVC.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/10.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCRemoteHelpPageVC.h"

@interface SCRemoteHelpPageVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SCRemoteHelpPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"#f1f1f1"];
    //1.标题
    self.leftBBI.text = @"帮助";
    
    
    [self setUpScrollViewContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setUpScrollViewContent
{
    [self.scrollView setContentSize:CGSizeMake(kMainScreenWidth, 1000)];

    // NO.1
    UIImageView *iv1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Help_1"]];
    [self.scrollView addSubview:iv1];
    [iv1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.textAlignment = NSTextAlignmentLeft;
    NSString *string = @"请保证机顶盒处于开机转态。如果您是初次使用机顶盒，需要打开一次机顶盒中的点播直播回看应用。";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2.f];//调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName : paragraphStyle,
                                      NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
    label1.attributedText = attributedString;
    label1.numberOfLines = 0;
    [label1 sizeToFit];
    label1.textColor = [UIColor colorWithHex:@"#666666"];
    [self.scrollView addSubview:label1];
    [label1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv1.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        
    }];
    
    // NO.2
    UIImageView *iv2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Help_2_1"]];
    [iv2 setFrame:CGRectMake(20, 140, kMainScreenWidth -20, 22)];
    [self.scrollView addSubview:iv2];
    [iv2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textAlignment = NSTextAlignmentLeft;
    NSString *string2 = @"智能设备需要和机顶盒处于同一局域网。";
    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2.f];//调整行间距
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:string2 attributes:@{NSParagraphStyleAttributeName : paragraphStyle2,
                                       NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
    label2.attributedText = attributedString2;
    label2.numberOfLines = 0;
    [label2 sizeToFit];
    label2.textColor = [UIColor colorWithHex:@"#666666"];
    [self.scrollView addSubview:label2];
    [label2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv2.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        
    }];

    UIImageView *iv2_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Help_2_2"]];
    [self.scrollView addSubview:iv2_2];
    [iv2_2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset((kMainScreenWidth - 292) / 2);
        make.size.mas_equalTo((CGSize){292, 164});
    }];
    

}


@end
