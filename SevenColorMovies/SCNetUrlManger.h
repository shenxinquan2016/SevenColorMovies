//
//  SCNetUrlManger.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/15.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NetUrlManager [SCNetUrlManger shareManager]

@interface SCNetUrlManger : NSObject

+(instancetype)shareManager;

/**
 *  domain
 */
@property (nonatomic,copy) NSString *domainName;
@property (nonatomic,copy) NSString *commonPort; /**< common端口 */
@property (nonatomic,copy) NSString *searchPort;/**<  search端口 */
@property (nonatomic,copy) NSString *payPort;/**< 支付端口 */





@end
