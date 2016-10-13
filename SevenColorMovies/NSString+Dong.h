//
//  NSString+Dong.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/8/5.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Dong)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGFloat)heightForLineWithFont:(UIFont *)font;

- (NSMutableAttributedString *)attributedString;

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font;

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing;

- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing characterSpacing:(CGFloat)spacing firstLineSpacing:(CGFloat)firstSpacing;

- (BOOL)isMoreThanOneLineConstraintToWidth:(CGFloat)width withFont:(UIFont *)font;

// 判断是否为空
- (BOOL)isBlank;

+ (instancetype)stringFromIntValue:(int)intValue;
+ (instancetype)stringFromIntegerValue:(NSInteger)integerValue;
+ (instancetype)stringFromUIntegerValue:(NSUInteger)uIntValue;
+ (instancetype)stringFromBOOLValue:(BOOL)boolValue;
+ (instancetype)stringFromNowDate;
+ (instancetype)absoluteStringFromNowDate;

- (instancetype)stringByTrimmingWhitespaceAndNewline;
- (instancetype)stringByTrimmingNewline;
- (instancetype)stringByTrimmingString:(NSString *)string;
// 去除中横线
- (instancetype)stringByTrimmingHyphen;
// 去除空格
- (instancetype)stringByTrimmingBlank;
- (instancetype)absoluteDateString;
// Base64
- (instancetype)stringByBase64Encoding;
- (instancetype)stringByBase64Decoding;



// 获取时间戳
/* 
 * hh与HH的区别:分别表示12小时制,24小时制
 * @"YYYY-MM-dd HH:mm:ss"
 * @"yyyy年MM月dd日 HH时mm分ss秒"
 * @"MM-dd-yyyy HH-mm-ss"
 *
 */
- (double)timestampWithDateFormat:(NSString *)dateFormat;

@end
