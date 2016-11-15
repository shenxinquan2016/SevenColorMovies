//
//  SCDownloadView.h
//  SCDSJDownloadView
//
//  Created by yesdgq on 16/11/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BackBtnBlock)(void);

@interface SCDSJDownloadView : UIView

@property (nonatomic, strong) NSArray *dataSourceArray;

@property (nonatomic, copy) BackBtnBlock backBtnBlock;

@end
