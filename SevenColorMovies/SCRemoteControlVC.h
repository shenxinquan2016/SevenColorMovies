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

/** 扫码得到的智能卡号 */
@property (nonatomic, copy) NSString *uid;
/** 扫码得到的mac地址 */
@property (nonatomic, copy) NSString *hid;

@end
