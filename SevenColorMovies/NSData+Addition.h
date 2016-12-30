//
//  NSData+Addition.h
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/30.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Addition)

- (NSData *)md5Digest;

- (NSData *)sha1Digest;

- (NSString *)hexStringValue;

- (NSString *)base64Encoded;

- (NSData *)base64Decoded;

@end
