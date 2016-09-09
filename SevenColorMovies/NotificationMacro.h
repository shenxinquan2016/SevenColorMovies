//
//  NotificationMacro.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/19.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#ifndef NotificationMacro_h
#define NotificationMacro_h

static NSString *const SwitchToFullScreen = @"SwitchToFullScreen";/* 进入全屏 */
static NSString *const SwitchToSmallScreen = @"SwitchToSmallScreen";/* 进入小屏 */
static NSString *const ChangeCellStateWhenPlayNextProgrom = @"ChangeCellStateWhenPlayNextProgrom";/* 自动播放下一个节目时改变cell状态 */
static NSString *const ChangeCellStateWhenClickProgramList = @"ChangeCellStateWhenClickProgramList";/* 点击播放列通知其他cell改为非选中状态 */
static NSString *const FilterOptionChanged = @"FilterOptionChanged";/* 点击筛选卡 */







#define k_for_selectedViewIndex @"k_for_selectedViewIndex"/* 正在展示页标识 */
#define k_for_selectedCellIndex @"k_for_selectedCellIndex"/* 点击cell的标识 */


#endif /* NotificationMacro_h */
