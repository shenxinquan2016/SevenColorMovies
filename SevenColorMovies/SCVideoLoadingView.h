//
//  SCVideoLoadingView.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/29.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCVideoLoadingView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;


// 开始加载
- (void)startAnimating;

// 结束加载
- (void)endAnimating;

@end
