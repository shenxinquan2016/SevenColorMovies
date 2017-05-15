//
//  NotificationMacro.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/19.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#ifndef NotificationMacro_h
#define NotificationMacro_h

static NSString *const SwitchToFullScreen = @"SwitchToFullScreen"; /** 进入全屏 */
static NSString *const SwitchToSmallScreen = @"SwitchToSmallScreen"; /** 进入小屏 */
static NSString *const ChangeCellStateWhenPlayNextProgrom = @"ChangeCellStateWhenPlayNextProgrom"; /** 直播自动播放下一个节目时改变cell状态 */
static NSString *const ChangeCellStateWhenPlayNextVODFilm = @"ChangeCellStateWhenPlayNextVODFilm"; /** VOD自动播放下一个节目时改变cell状态 */
static NSString *const ChangeCellStateWhenClickProgramList = @"ChangeCellStateWhenClickProgramList"; /** 点击播放列通知其他cell改为非选中状态 */
static NSString *const FilterOptionChanged = @"FilterOptionChanged"; /** 点击筛选卡 */
static NSString *const PlayVODFilmWhenClick = @"PlayVODFilmWhenClick"; /** 点击点播节目列表 */
static NSString *const CutOffTcpConnectByUser = @"CutOffTcpConnectByUser"; /** 用户断开设备连接 */

static NSString *const AppWillResignActive = @"AppWillResignActive"; /** app失去活性 */
static NSString *const AppDidBecomeActive = @"AppDidBecomeActive"; /** app被激活 */



#define k_for_Live_selectedViewIndex @"k_for_Live_selectedViewIndex" /** 正在展示页标识 直播 */
#define k_for_Live_selectedCellIndex @"k_for_Live_selectedCellIndex" /** 点击cell的标识  直播 */
#define k_for_VOD_selectedViewIndex @"k_for_VOD_selectedViewIndex" /** 正在展示页标识 点播 */
#define k_for_VOD_selectedCellIndex @"k_for_VOD_selectedCellIndex" /** 点击cell的标识  点播 */
#define kFilmClassTitleArray @"kFilmClassTitleArray" /** 节目分类title保存到本地 */
#define kMobileNetworkAlert @"kMobileNetworkAlert" /** 移动网络播放时提醒 */
#define kCurrentPlayTimeWhenGotoBG @"kCurrentPlayTimeWhenGotoBG" /** 进入后台时的当前播放时间 */
#define kUidByTVBox @"kUidByTVBox"
#define KHidByTVBox @"KHidByTVBox"

#endif /* NotificationMacro_h */
