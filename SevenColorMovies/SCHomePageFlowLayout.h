//
//  SCHomePageFlowLayout.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/25.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCHomePageFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) BOOL alternateDecorationViews; // 交替DecorationView
@property (nonatomic, assign) BOOL decorationViewContainXib; // default YES decorationView contain xib
@property (nonatomic, strong) NSArray *decorationViewOfKinds;// if decorationViewContainXib is YES xib names,else view names. custom view or xib need inherit UICollectionReusableView

@end
