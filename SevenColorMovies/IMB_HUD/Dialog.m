
#import "Dialog.h"
#import <unistd.h>

@implementation Dialog

static Dialog *instance = nil;

+ (Dialog *)Instance
{
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [self new];
        }
    }
    return instance;
}

+ (void)alert:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:nil 
                              message:message 
                              delegate:nil 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil, nil];
    [alertView show];
    //[alertView release];
}

+ (void)alertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil, nil];
    [alertView show];
    //[alertView release];
}

+ (void)toast:(UIViewController *)controller withMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
	hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = YES;
	hud.labelText = message;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1.3f];
}

+ (void)toast:(NSString *)message {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//	hud.mode = MBProgressHUDModeText;
//    hud.userInteractionEnabled = YES;
//    hud.animationType = MBProgressHUDAnimationFade;
//	hud.labelText = message;
//	hud.margin = 10.f;
//	hud.yOffset = 150.f;
//	hud.removeFromSuperViewOnHide = YES;
//	[hud hide:YES afterDelay:2];
    [SVProgressHUD setOffsetFromCenter:UIOffsetZero];
    [SVProgressHUD showImage:nil status:message];

}

// add by gcz 14.7.16 底部等待状态
+ (void)toastStatus:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
	hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = YES;
    hud.animationType = MBProgressHUDAnimationFade;
	hud.labelText = message;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
}

// // add by gcz 14.7.16 隐藏底部等待状态
+ (void)hideMBHud
{
    [MBProgressHUD hideHUDForView:TL_Application.keyWindow animated:NO];
}

+ (void)simpleToast:(NSString *)message
{
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, kSCREEN_HEIGHT/2-80)];
    [SVProgressHUD showImage:nil status:message];
}

+ (void)showWithStatus:(NSString *)status maskType:(SVProgressHUDMaskType)maskType
{
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 0)];
    [SVProgressHUD showWithStatus:status maskType:maskType];
    
//    [SVProgressHUD touchSelf];
    
}


+ (void)showSucessWithStatus:(NSString *)status
{
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 0)];
    [SVProgressHUD showSuccessWithStatus:status];
}

+ (void)showFailWithStatus:(NSString *)status
{
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 0)];
//    [SVProgressHUD setErrorImage:IMAGE(@"加载失败")];
    [SVProgressHUD showErrorWithStatus:status];
}

+ (void)showProgress:(CGFloat)progress status:(NSString *)status
{
    [SVProgressHUD setOffsetFromCenter:UIOffsetZero];
    [SVProgressHUD showProgress:progress status:status maskType:SVProgressHUDMaskTypeClear];
}

+ (void)dismissSVHUD
{
    
    [SVProgressHUD dismiss];
}

//
//+ (void)hideSimpleToast
//{
//    [SVProgressHUD dismissAfterDelay:2];
//}

+ (void)toastCenter:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
	hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationFade; //MBProgressHUDAnimationZoomOut
	hud.labelText = message;
	hud.margin = 10.f;
	hud.yOffset = -20.f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:2];
}

+ (void)progressToast:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
	hud.mode = MBProgressHUDModeIndeterminate;
	hud.labelText = message;
	hud.margin = 10.f;
	hud.yOffset = -20.f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:2];
}

- (void)gradient:(UIViewController *)controller seletor:(SEL)method {
    HUD = [[MBProgressHUD alloc] initWithView:controller.view];
	[controller.view addSubview:HUD];
//	HUD.dimBackground = YES;
	HUD.delegate = self;
	[HUD showWhileExecuting:method onTarget:controller withObject:nil animated:YES];
}

- (void)showProgress:(UIViewController *)controller {
    HUD = [[MBProgressHUD alloc] initWithView:controller.view];
    [controller.view addSubview:HUD];
//    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
}

- (void)showProgress:(UIViewController *)controller withLabel:(NSString *)labelText {
    HUD = [[MBProgressHUD alloc] initWithView:controller.view];
    [controller.view addSubview:HUD];
    HUD.delegate = self;
//    HUD.dimBackground = YES;
    HUD.labelText = labelText;
    [HUD show:YES];
}

- (void)showCenterProgressWithLabel:(NSString *)labelText
{
    HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.delegate = self;
    //    HUD.dimBackground = YES;
    HUD.labelText = labelText;
    [HUD show:YES];
}

- (void)hideProgress {
    [HUD hide:YES];
}

- (void)progressWithLabel:(UIViewController *)controller seletor:(SEL)method {
    HUD = [[MBProgressHUD alloc] initWithView:controller.view];
    [controller.view addSubview:HUD];
    HUD.delegate = self;
    //HUD.labelText = @"数据加载中...";
    [HUD showWhileExecuting:method onTarget:controller withObject:nil animated:YES];
}

#pragma mark -
#pragma mark Execution code

- (void)myTask {
	sleep(3);
}

- (void)myProgressTask {
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		HUD.progress = progress;
		usleep(50000);
	}
}

- (void)myMixedTask {
	sleep(2);
	HUD.mode = MBProgressHUDModeDeterminate;
	HUD.labelText = @"Progress";
	float progress = 0.0f;
	while (progress < 1.0f)
	{
		progress += 0.01f;
		HUD.progress = progress;
		usleep(50000);
	}
	HUD.mode = MBProgressHUDModeIndeterminate;
	HUD.labelText = @"Cleaning up";
	sleep(2);
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Completed";
	sleep(2);
}

#pragma mark -
#pragma mark NSURLConnectionDelegete

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	expectedLength = [response expectedContentLength];
	currentLength = 0;
	HUD.mode = MBProgressHUDModeDeterminate;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	currentLength += [data length];
	HUD.progress = currentLength / (float)expectedLength;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:2];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[HUD hide:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	[HUD removeFromSuperview];
	HUD = nil;
}

#pragma mark - TWMessageHUD methods

+ (void)twTitle:(NSString *)title type:(TWMessageBarMessageType)type places:(NSArray *)places
{
    [TWBar title:title type:type duration:2.f places:places callBack:NULL];
}

+ (void)twDismiss
{
    [TWBar hideAll];
}

#pragma mark - MONActivity methods


- (void)showMONto:(UIView *)view center:(CGPoint)center
{
    if (!monView_) {
        monView_ = [[MONActivityIndicatorView alloc] init];
        monView_.delegate = self;
        monView_.numberOfCircles = 4;
        monView_.radius = 10;
        monView_.internalSpacing = 3;
    }
    monView_.center = center;
    [monView_ startAnimating];
    [view addSubview:monView_];
}

- (void)dismissMon
{
    [monView_ stopAnimating];
    //[monView_ removeFromSuperview];
}

#pragma mark -
#pragma mark - MONActivityIndicatorViewDelegate Methods

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
