//
//  SCSearchBarView.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/20.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCSearchBarView.h"

@interface SCSearchBarView ()


@end

@implementation SCSearchBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setViews];
    }
    
    return self;
}


- (void)setViews
{
    // 搜索图标
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 15, 15)];
    searchImageView.image = [UIImage imageNamed:@"SearchImg"];
    searchImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:searchImageView];
    [searchImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(searchImageView.image.size);
    }];
    
    // 搜索textField
    _searchTF = [[UITextField alloc] init];
    _searchTF.borderStyle = UITextBorderStyleNone;
    _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTF.returnKeyType = UIReturnKeySearch;
    _searchTF.enablesReturnKeyAutomatically = YES;
    _searchTF.backgroundColor = [UIColor colorWithHex:@"dddddd"];
    _searchTF.placeholder =  @"请输入节目名称";
    _searchTF.textColor =[UIColor colorWithHex:@"#333333"];
    _searchTF.font = [UIFont systemFontOfSize:12.f];
    _searchTF.tintColor = [UIColor colorWithHex:@"#02a2e5"];

//    [_searchTF setValue:[UIColor colorWithHex:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
//    [_searchTF setValue:[UIFont systemFontOfSize:12.f] forKeyPath:@"_placeholderLabel.font"];
    
    [self addSubview:_searchTF];
    [_searchTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-searchImageView.image.size.width-5-5);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    self.layer.cornerRadius = 12.0f;
    self.backgroundColor = [UIColor colorWithHex:@"dddddd"];
}


@end
