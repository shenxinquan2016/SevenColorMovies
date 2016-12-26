//
//  IMB_ASIProgressView.m
//  ArtPraise
//
//  Created by gcz on 14-6-25.
//  Copyright (c) 2014年 闫建刚. All rights reserved.
//

#import "IMB_ASIProgressView.h"

@interface IMB_ASIProgressView ()
{
    BOOL hasComplete_;
}
@end

@implementation IMB_ASIProgressView

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 0)];
    [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"已上传%0.f%%",progress*100] maskType:SVProgressHUDMaskTypeClear];
    if (progress == 1.0f && !hasComplete_) {
        hasComplete_ = YES;
        //[self performSelector:@selector(showSuccessUpload) withObject:nil afterDelay:0.1f];
    }
    
}

//- (void)showSuccessUpload
//{
//    [Dialog showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeBlack];
//}

@end
