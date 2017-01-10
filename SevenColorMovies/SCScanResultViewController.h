//
//  SCScanResultViewController.h
//  SevenColorMovies
//
//  Created by yesdgq on 17/1/10.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "SCOtherBaseViewController.h"

@interface SCScanResultViewController : SCOtherBaseViewController

/** 扫码图片 */
@property (nonatomic, strong) UIImage* imgScan;
/** 扫码信息 */
@property (nonatomic, copy) NSString* strScan;
/** 扫码类型 */
@property (nonatomic, copy) NSString *strCodeType;

@end
