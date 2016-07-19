//
//  IMB_DownImageHelper.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/19.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "IMB_DownImageHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

@implementation IMB_DownImageHelper

+ (void)downImageWithURL:(NSURL *)imgURL imageView:(IMB_DownImageView *)imageView placeHolder:(UIImage *)placeHolder
{
    UIImage *cachedImage = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:[imgURL absoluteString]]; // 将需要缓存的图片加载进来
    //[SDManager diskImageExistsForURL:imgURL]; //判断是否已缓存该图片
    //    NSLog(@"url = %@",imgURL);
    
    //    [imageView setImgURL:imgURL];
    
    imageView.imgURL = imgURL;
    if (cachedImage) {
        // 如果Cache命中，则直接利用缓存的图片进行有关操作
        // Use the cached image immediatly
        //        if (cachedImage.size.width > 1000) {
        //            cachedImage = [cachedImage imageByScalingToSize:CGSizeMake(1000, 1000*cachedImage.size.height/cachedImage.size.width)];
        //        }
        imageView.image = cachedImage;
    } else {
        //添加指示器
        /* UIActivityIndicatorView *indicator;
         static NSInteger indicatorTag = 20140402;
         
         if (![imageView viewWithTag:indicatorTag]) {
         BOOL isNightMode = [[RNThemeManager sharedManager].currentThemeName isEqualToString:@"hicontrast"]?YES:NO;
         indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:!isNightMode? UIActivityIndicatorViewStyleGray:UIActivityIndicatorViewStyleWhite];
         [indicator setHidesWhenStopped:YES];
         
         [indicator setCenter:CGPointMake(ViewWidth(imageView)/2,ViewHeight(imageView)/2)];
         indicator.tag = indicatorTag;
         [imageView addSubview:indicator];
         }else{
         indicator = (UIActivityIndicatorView *)[imageView viewWithTag:indicatorTag];
         }
         [indicator startAnimating]; */
        
        // 如果Cache没有命中，则去下载指定网络位置的图片
        // Start an async download
        
        __weak IMB_DownImageView *weakImageView = imageView;
        
        //        [imageView sd_setImageWithURL:imgURL placeholderImage:placeHolder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //
        //        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //            // do something with image
        //            if ([weakImageView.imgURL isEqual:imgURL]) {
        //                if (image) {
        //                    //[indicator stopAnimating];
        //
        //                    weakImageView.alpha = 0;
        //                    if (image.size.width > 1000) {
        //                        image = [image imageByScalingToSize:CGSizeMake(1000, 1000*image.size.height/image.size.width)];
        //                    }
        //                    weakImageView.image = image;
        //                    //NSLog(@"第%ld下载完成!",indexPath.row+1);
        //
        //                    [UIView animateWithDuration:1.0 animations:^{
        //                        weakImageView.alpha = 1.0;
        //                    }];
        //
        //                }else{
        //                    //[indicator stopAnimating];
        //                    //[SVProgressHUD showErrorWithStatus:@"图片下载失败"];
        //                }
        //            }
        //        }];
        
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:imgURL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            // do something with image
            if ([weakImageView.imgURL isEqual:imgURL]) {
                if (image) {
                    //[indicator stopAnimating];
                    
                    weakImageView.alpha = 0;
                    
                    // 压缩图片
                    //                    CGFloat maxWidth = 1000;
                    //
                    //                    if (image.size.width > maxWidth) {
                    //                        BACK(^{
                    //                            UIImage *newImg;
                    //                            newImg = [image imageByScalingToSize:CGSizeMake(maxWidth, maxWidth*image.size.height/image.size.width)];
                    //                            if (newImg) {
                    ////                                image = newImg;
                    //                                MAIN(^{
                    //                                    [[SDImageCache sharedImageCache] storeImage:newImg
                    //
                    //                                                                         forKey:[imgURL absoluteString]
                    //
                    //                                                                         toDisk:YES];
                    //                                    weakImageView.image = newImg;
                    //                                    //NSLog(@"第%ld下载完成!",indexPath.row+1);
                    //
                    //                                    [UIView animateWithDuration:1.0 animations:^{
                    //                                        weakImageView.alpha = 1.0;
                    //                                    }];
                    //                                });
                    //                            }
                    //                        });
                    //                    }else{
                    //                        [[SDImageCache sharedImageCache] storeImage:image
                    //
                    //                                                             forKey:[imgURL absoluteString]
                    //
                    //                                                             toDisk:YES];
                    //                        weakImageView.image = image;
                    //                        //NSLog(@"第%ld下载完成!",indexPath.row+1);
                    //
                    //                        [UIView animateWithDuration:1.0 animations:^{
                    //                            weakImageView.alpha = 1.0;
                    //                        }];
                    //                    }
                    
                    [[SDImageCache sharedImageCache] storeImage:image
                     
                                                         forKey:[imgURL absoluteString]
                     
                                                         toDisk:YES];
                    weakImageView.image = image;
                    //NSLog(@"第%ld下载完成!",indexPath.row+1);
                    
                    [UIView animateWithDuration:1.0 animations:^{
                        weakImageView.alpha = 1.0;
                    }];
                    
                    
                    
                    
                }else{
                    //[indicator stopAnimating];
                    //[SVProgressHUD showErrorWithStatus:@"图片下载失败"];
                    weakImageView.image = placeHolder;
                }
            }
        }];
        
    }
    
}

// 下载变化图片
+ (void)downDynamicImageWithURL:(NSURL *)imgURL imageView:(IMB_DownImageView *)imageView placeHolder:(UIImage *)placeHolder
{
    //    [self downImageWithURL:imgURL imageView:imageView placeHolder:placeHolder];
    //    return;
    imageView.imgURL = imgURL;
    
    // Start an async download
    
    __weak IMB_DownImageView *weakImageView = imageView;
    
    [imageView sd_setImageWithURL:imgURL placeholderImage:placeHolder options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // do something with image
        if ([weakImageView.imgURL isEqual:imgURL]) {
            if (image) {
                //[indicator stopAnimating];
                
                //                if (image.size.width > 1000) {
                //                    image = [image imageByScalingToSize:CGSizeMake(1000, 1000*image.size.height/image.size.width)];
                //                }
                
                weakImageView.alpha = 0;
                weakImageView.image = image;
                //NSLog(@"第%ld下载完成!",indexPath.row+1);
                
                [UIView animateWithDuration:1.0 animations:^{
                    weakImageView.alpha = 1.0;
                }];
                
            }else{
                // 显示错误图片
                weakImageView.image = placeHolder;
            }
        }
    }];
    
}

+ (void)downImageWithURL:(NSURL *)imgURL button:(UIButton *)imageView placeHolder:(UIImage *)placeHolder
{
    UIImage *cachedImage = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:[imgURL absoluteString]]; // 将需要缓存的图片加载进来
    //[SDManager diskImageExistsForURL:imgURL]; //判断是否已缓存该图片
    //    imageView.imgURL = imgURL;
    //    [imageView setValue:imgURL forKey:@"imgURL"];
    if (cachedImage) {
        // 如果Cache命中，则直接利用缓存的图片进行有关操作
        // Use the cached image immediatly
        //        imageView.image = cachedImage;
        [imageView setImage:cachedImage forState:UIControlStateNormal];
    } else {
        
        // 如果Cache没有命中，则去下载指定网络位置的图片
        // Start an async download
        
        __weak UIButton *weakImageView = imageView;
        
        
        //        [imageView sd_setImageWithURL:imgURL forState:UIControlStateNormal placeholderImage:placeHolder options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //            // do something with image
        //            //if ([[weakImageView valueForKey:@"imgURL"] isEqual:imgURL]) {
        //                if (image) {
        //                    //weakImageView.alpha = 0;
        //                    [weakImageView setImage:image forState:UIControlStateNormal];
        //                    //NSLog(@"第%ld下载完成!",indexPath.row+1);
        //
        ////                    [UIView animateWithDuration:1.0 animations:^{
        ////                        weakImageView.alpha = 1.0;
        ////                    }];
        //
        //                }else{
        //
        //                }
        //            //}
        //        }];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:imgURL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            // do something with image
            if (image) {
                //[indicator stopAnimating];
                
                weakImageView.alpha = 0;
                //                if (image.size.width > 1000) {
                //                    image = [image imageByScalingToSize:CGSizeMake(1000, 1000*image.size.height/image.size.width)];
                //                }
                
                [[SDImageCache sharedImageCache] storeImage:image
                 
                                                     forKey:[imgURL absoluteString]
                 
                                                     toDisk:YES];
                [weakImageView setImage:image forState:UIControlStateNormal];
                //NSLog(@"第%ld下载完成!",indexPath.row+1);
                
                [UIView animateWithDuration:1.0 animations:^{
                    weakImageView.alpha = 1.0;
                }];
                
            }else{
                //[indicator stopAnimating];
                //[SVProgressHUD showErrorWithStatus:@"图片下载失败"];
                [weakImageView setImage:placeHolder forState:UIControlStateNormal];
            }
        }];
        
    }
    
}

+ (void)removeImageCacheWithUrl:(NSString *)url
{
    [[[SDWebImageManager sharedManager] imageCache] removeImageForKey:url withCompletion:^{
    }];
    
}

@end
