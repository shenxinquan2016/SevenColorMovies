//
//  SCNoDeviceView.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/10.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReScanDeviceBlock)(void);
typedef void(^GotoHelpPageBlock)(void);

@interface SCNoDeviceView : UIView

@property (nonatomic, copy) ReScanDeviceBlock scanDevice;
@property (nonatomic, copy) GotoHelpPageBlock gotoHelpPage;

@end
