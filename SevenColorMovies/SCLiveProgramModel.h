//
//  SCLiveProgramModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/24.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCLiveProgramModel : NSObject

@property (nonatomic, strong) NSString *filmName;/* 节目名称 */
@property (nonatomic, strong) NSString *programTime;/* 节目时间 */
@property (nonatomic, assign) SCLiveProgramState programState;/* 节目状态 */

@end
