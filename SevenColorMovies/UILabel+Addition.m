//
//  UILabel+Addition.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/9/2.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "UILabel+Addition.h"

@implementation UILabel (Addition)

-  (void)alignTop {
    CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label

    CGSize theStringSize = [self.text boundingRectWithSize:CGSizeMake(finalWidth, finalHeight)
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:@{NSFontAttributeName : self.font}
                                             context:nil].size;
    
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
}

- (void)alignBottom {
    CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text boundingRectWithSize:CGSizeMake(finalWidth, finalHeight)
                                                   options:\
                            NSStringDrawingTruncatesLastVisibleLine |
                            NSStringDrawingUsesLineFragmentOrigin |
                            NSStringDrawingUsesFontLeading
                                                attributes:@{NSFontAttributeName : self.font}
                                                   context:nil].size;
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
}

/* 根据label文字的字体多少计算label的frame */
- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

@end
