//
//  SCNetRequsetManger+iCloudRemoteControl.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/12/22.
//  Copyright © 2016年 yesdgq. All rights reserved.
//  语音识别服务器网络通信工具类

#import "SCNetRequsetManger+iCloudRemoteControl.h"

@implementation SCNetRequsetManger (iCloudRemoteControl)

- (void)postRequestDataToCloudRemoteControlServerWithUrl:(nullable NSString *)urlString parameters:(nullable id)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(id _Nullable errorObject))faild
{
    
    [self POSTPOSTRequestDataWithUrl:urlString parameters:parameters success:^(id _Nullable responseObject){
        
        success(responseObject);
        
        
    } faild:^(id _Nullable errorObject) {
        //数据请求失败
        if (![SCNetHelper isNetConnect]) {
            faild(@"网络异常，请检查网络设置!");
            [MBProgressHUD showError:@"网络异常，请检查网络设置!"];
        } else {
            faild(errorObject);
            [MBProgressHUD showError:@"获取数据失败!"];
        }
    }];
 
    
}

//******************☝️☝️☝️☝️☝️☝️☝️☝️下面为通用请求方法☝️☝️☝️☝️☝️☝️☝️☝️****************

- (void)POSTPOSTRequestDataWithUrl:(NSString *)urlString parameters:(_Nullable id)parameters success:(void (^)(id _Nullable))success faild:(void (^)(id _Nullable))faild {
    //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //此处设置后返回的默认是NSData的数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 1.2返回XMLParser
    //    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"multipart/form-data",nil];
    
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",nil];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 声明请求的数据是json类型
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];

    
    
    manager.requestSerializer.timeoutInterval = 2;//请求超时时间设置
    //设置请求格式
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //    NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    // 手机串号
    //    NSArray *deviceIds = [DEVICE_ID componentsSeparatedByString:@"-"];
    //    NSString *uid = [deviceIds componentsJoinedByString:@""];
    
    
    
    //    [newParameters setObject:@"iOS" forKey:@"system"];//客户端操作系统
    //    [newParameters setObject:[DNIPhoneInfo deviceType] forKey:@"device"];// 客户端机型
    //    [newParameters setObject:[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] forKey:@"version"];//客户端版本
    //    [newParameters setObject:[[UIDevice currentDevice] systemVersion] forKey:@"sysModel"];
    //    NSLog(@"---- %@",newParameters);
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            
            NSError *myError;
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&myError];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&myError];
            
            success(dic);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"------%@》》》》》》", error);
        if (faild) {
            
        }
    }];
}




- (void)postDataToCloudRemoteControlServerWithUrl:(nullable NSString *)urlString parameters:(nullable id)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(id _Nullable errorObject))faild {
    
    // 1.URL
    NSURL *url = [NSURL URLWithString:urlString];
    // 2.请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 3.请求方法
    request.HTTPMethod = @"POST";
    NSData *json = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = json;
    // 5.设置请求头：这次请求体的数据不再是普通的参数，而是一个JSON数据
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 6.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data == nil || connectionError) return;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        success(dict);
        
    
    }];
}

@end
