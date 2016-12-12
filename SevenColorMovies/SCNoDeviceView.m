//
//  SCNoDeviceView.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/10.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCNoDeviceView.h"

@implementation SCNoDeviceView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.hidden = YES;
}

//扫描设备
- (IBAction)ReScanDevicr:(id)sender {
    if (self.scanDevice) {
        self.scanDevice();
    }
}

//帮助
- (IBAction)gotoHelpPage:(id)sender {
    if (self.gotoHelpPage) {
        self.gotoHelpPage();
    }
}

@end
