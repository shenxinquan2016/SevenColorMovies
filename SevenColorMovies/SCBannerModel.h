//
//  SCBannerModel.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/29.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCBannerModel : NSObject

/** banner图片url*/
@property (nonatomic, copy) NSString *_ImgUrlOriginal;

/** film url*/
@property (nonatomic, copy) NSString *_SourceUrl;

/** film type */
@property (nonatomic,copy) NSString *_FilmType;

/** FilmID */
@property (nonatomic,copy) NSString *_FilmID;

/** 影片介绍 */
@property (nonatomic,copy) NSString *Introduction;

/** 影片区域 */
@property (nonatomic,copy) NSString *_Area;

@end