//
//  SCDevicesListView.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/10.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCDeviceModel;

typedef void(^ReScanDeviceBlock)(void);
typedef void(^ConnectTCPBlock)(SCDeviceModel *deviceModel);

@interface SCDevicesListView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, copy) ReScanDeviceBlock scanDeviceBlock;
@property (nonatomic, copy) ConnectTCPBlock connectTCPBlock;
/** 回调回传model */
@property (nonatomic, strong) SCDeviceModel *deviceModel;

@end
