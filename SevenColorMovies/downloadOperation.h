//
//  downloadOperation.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/11/7.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface downloadOperation : NSOperation

+ (instancetype)downloadWith:(NSURL *)url progressBlock:(void (^)(CGFloat progress))progressBlock complete:(void (^)(NSString *path,NSError *error))complete;


- (void)cancleDown;


@end
