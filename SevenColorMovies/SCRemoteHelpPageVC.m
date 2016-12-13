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
    [self.scrollView setContentSize:CGSizeMake(kMainScreenWidth, 1300)];

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
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo((CGSize){292, 164});
    }];
    
    // NO.3
    UIImageView *iv3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Help_3_1"]];
    [iv3 setFrame:CGRectMake(20, 140, kMainScreenWidth -20, 22)];
    [self.scrollView addSubview:iv3];
    [iv3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv2_2.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.textAlignment = NSTextAlignmentLeft;
    NSString *string3 = @"搜索设备并连接（如需去换设备，可到遥控器的右上角点击断开按钮重新搜索连接）";
    NSMutableParagraphStyle *paragraphStyle3 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2.f];//调整行间距
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:string3 attributes:@{NSParagraphStyleAttributeName : paragraphStyle3,
                                       NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
    label3.attributedText = attributedString3;
    label3.numberOfLines = 0;
    [label3 sizeToFit];
    label3.textColor = [UIColor colorWithHex:@"#666666"];
    [self.scrollView addSubview:label3];
    [label3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv3.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        
    }];
    
    UIImageView *iv3_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Help_3_2"]];
    [self.scrollView addSubview:iv3_2];
    [iv3_2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo((CGSize){292, 164});
    }];

    // NO.4
    UIImageView *iv4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Help_4_1"]];
    [iv4 setFrame:CGRectMake(20, 140, kMainScreenWidth -20, 22)];
    [self.scrollView addSubview:iv4];
    [iv4 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv3_2.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.textAlignment = NSTextAlignmentLeft;
    NSString *string4 = @"点击七彩影视详情页中的飞屏按钮，视屏就投放到电视上播放了！";
    NSMutableParagraphStyle *paragraphStyle4 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2.f];//调整行间距
    NSMutableAttributedString *attributedString4 = [[NSMutableAttributedString alloc] initWithString:string4 attributes:@{NSParagraphStyleAttributeName : paragraphStyle4,
                                       NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
    label4.attributedText = attributedString4;
    label4.numberOfLines = 0;
    [label4 sizeToFit];
    label4.textColor = [UIColor colorWithHex:@"#666666"];
    [self.scrollView addSubview:label4];
    [label4 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv4.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        
    }];
    
    UIImageView *iv4_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Help_4_2"]];
    [self.scrollView addSubview:iv4_2];
    [iv4_2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label4.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo((CGSize){168, 157});
    }];
    
    // NO.5
    UIImageView *iv5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Help_5_1"]];
    [iv5 setFrame:CGRectMake(20, 140, kMainScreenWidth -20, 22)];
    [self.scrollView addSubview:iv5];
    [iv5 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv4_2.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UILabel *label5 = [[UILabel alloc] init];
    label5.textAlignment = NSTextAlignmentLeft;
    NSString *string5 = @"连接成功之后就可以使用手机遥控器控制盒子，不用瞄准，完美触控";
    NSMutableParagraphStyle *paragraphStyle5 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2.f];//调整行间距
    NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:string5 attributes:@{NSParagraphStyleAttributeName : paragraphStyle5,
                                       NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
    label5.attributedText = attributedString5;
    label5.numberOfLines = 0;
    [label5 sizeToFit];
    label5.textColor = [UIColor colorWithHex:@"#666666"];
    [self.scrollView addSubview:label5];
    [label5 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv5.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        
    }];
    
    UIImageView *iv5_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Help_5_2"]];
    [self.scrollView addSubview:iv5_2];
    [iv5_2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label5.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo((CGSize){113, 141});
    }];

    

}


@end
