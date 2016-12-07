//
//  Dong_RunLabel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/7.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Dong_RunLabel : UIView

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;

- (instancetype)initWithTitle:(NSString *)titleName;

@end
