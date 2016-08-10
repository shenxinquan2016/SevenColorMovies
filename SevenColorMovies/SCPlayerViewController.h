//
//  SCPlayerViewController.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilmModel.h"
@interface SCPlayerViewController : UIViewController

@property (nonatomic, strong) SCFilmModel *filmModel;

@property (nonatomic, strong) NSString *filmType;


- (instancetype)initWithWithFilmType:(NSString *)tpye;

@end
