//
//  Dong_NullDataView.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/26.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "Dong_NullDataView.h"

static const NSInteger kViewTag = 523100;

@implementation Dong_NullDataView

+ (void)addImage:(UIImage *)image text:(NSString *)text view:(UIView*)view
{
    UIImageView *noDataImage = (UIImageView *)[view viewWithTag:kViewTag];
    if (!noDataImage && image) {
        noDataImage = [[UIImageView alloc]initWithImage:image];
        noDataImage.tag = kViewTag;
    }
    UILabel* tipLabel = (UILabel *)[view viewWithTag:kViewTag+1];
    if (!tipLabel && text) {
        tipLabel = [[UILabel alloc]init];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont systemFontOfSize:16];
        tipLabel.textColor = [UIColor colorWithHex:@"#c0c0c0"];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.tag = kViewTag + 1;
    }
    if (noDataImage && view) {
        if (!noDataImage.superview) {
            [view addSubview:noDataImage];
        }
        [noDataImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(view);
            make.centerY.equalTo(view).offset(-20);
//            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.size.mas_equalTo(noDataImage.image.size);
        }];
        
    }
    if (tipLabel  && view){
        if (!tipLabel.superview) {
            [view addSubview:tipLabel];
        }
        [tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(noDataImage);
            make.centerY.equalTo(noDataImage.mas_centerY).offset(45);
            make.size.mas_equalTo(CGSizeMake(160, 40));
        }];
        tipLabel.text = text;
    }
}

+ (void)removeViewFromView:(UIView*)view {
    if (!view) {
        return;
    }
    UIImageView* imageView = (UIImageView*)[view viewWithTag:kViewTag];
    if(imageView){
        [imageView removeFromSuperview];
        imageView = nil;
    }
    
    UILabel* label = (UILabel*)[view viewWithTag:kViewTag+1];
    if(label){
        [label removeFromSuperview];
        label = nil;
    }
}

+ (void)addTapAction:(id)target action:(SEL)selector view:(UIView*)view {
    if (!view) {
        return;
    }
    UIImageView* imageView = (UIImageView*)[view viewWithTag:kViewTag];
    UILabel* label = (UILabel*)[view viewWithTag:kViewTag+1];
    
    imageView.userInteractionEnabled = YES;
    label.userInteractionEnabled = YES;
    
    if (imageView && label) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];

        [imageView addGestureRecognizer:tap];
        [label addGestureRecognizer:tap2];
    }
}

@end
