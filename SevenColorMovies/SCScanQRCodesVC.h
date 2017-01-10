//
//  SCScanQRCodesVC.h
//  SevenColorMovies
//
//  Created by yesdgq on 17/1/9.
//  Copyright © 2017年 yesdgq. All rights reserved.
//  扫码控制器

#import "LBXScanViewController.h"

@interface SCScanQRCodesVC : LBXScanViewController

@property (nonatomic, assign) BOOL isQQSimulator;
/** 扫码区域上方提示文字 */
@property (nonatomic, strong) UILabel *topTitle;
/** 增加拉近/远视频界面 */
@property (nonatomic, assign) BOOL isVideoZoom;
#pragma mark - 底部几个功能：开启闪光灯、相册、我的二维码
//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;
//相册
@property (nonatomic, strong) UIButton *btnPhoto;
//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;
//我的二维码
@property (nonatomic, strong) UIButton *btnMyQR;

@end
