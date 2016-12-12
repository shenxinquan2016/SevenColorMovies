//
//  SCRemoteControlVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/29.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCOtherBaseViewController.h"

@class SCDeviceModel;

@interface SCRemoteControlVC : SCOtherBaseViewController

@property (nonatomic, strong) SCDeviceModel *deviceModel;

@end
