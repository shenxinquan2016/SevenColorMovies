//
//  SCNetRequsetManger.m
//  SevenColorMovies
//
//  Created by yesdgq on 16/7/27.
//  Copyright © 2016年 yesdgq. All rights reserved.
//

#import "SCNetRequsetManger.h"
#import "DNIPhoneInfo.h"// iphone型号 iOS版本号
#import "SCNetHelper.h"


@implementation SCNetRequsetManger

+ (instancetype)shareManager {
    static SCNetRequsetManger *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SCNetRequsetManger alloc] init];
    });
    return manager;
}


//******************☝️☝️☝️☝️☝️☝️☝️☝️下面为某个需要调用的方法☝️☝️☝️☝️☝️☝️☝️☝️****************

/**
 *  GET 或则 POST 请求根据自己的需求来定
 *
 *  @param urlString     请求的url（某个特定接口可以写在此方法内不需要传过来）
 *  @param parameters    请求的参数 (某个特定接口可以写在此方法内不需要传递过来)
 *  @param modelType     数据模型 （返回的数据需要转换的模型）
 *  @param success       成功的返回 （如果模型存在，成功后直接返回模型数组）
 *  @param faild         失败的返回
 */

- (void)requestDataWithModelType:(id)modelType success:(void (^)(id _Nullable))success failure:(void (^)(id _Nullable))faild {
    
    NSString *urlString = @"";//请求所需的url
    NSDictionary *parameters = @{
                                 @"first":@"One",
                                 @"second":@"Two"
                                 };
    [self POSTRequestDataWithUrl:urlString parameters:parameters success:^(id  _Nullable responseObject) {
        NSMutableArray *returnArray = [[NSMutableArray alloc]init];//要返回的数组
        for (NSDictionary *dataSource in responseObject) {
            if ([dataSource isKindOfClass:[NSDictionary class]]) {
                
                //RDLivingVCModel *livingVCModel = [RDLivingVCModel objectWithKeyValues:dataSource];
                //[returnArray addObject:livingVCModel];//返回的数组里面是model类型
            }
        }
        
        if (returnArray.count) {
            success(returnArray);
        } else {
            faild(@"暂无更多数据");
        }
    } faild:^(id  _Nullable errorObject) {
        //数据请求失败
        if (![SCNetHelper isNetConnect]) {
            faild(@"网络异常，请检查网络设置!");
        } else {
            faild(@"网络访问超时，请检查网络设置!");
        }
    }];
}


/** Banner数据 */
- (void)requestBannerDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id _Nullable))success failure:(void (^)(id _Nullable))faild{
    
    [self GETRequestDataWithUrl:urlString parameters:parameters success:^(id _Nullable responseObject) {
        success(responseObject);
        
        
    } faild:^(id _Nullable errorObject) {
        //数据请求失败
        if (![SCNetHelper isNetConnect]) {
            faild(@"网络异常，请检查网络设置!");
        } else {
            faild(@"网络访问超时，请检查网络设置!");
        }
        
    }];
    
}


/** filmList */
- (void)requestFilmListDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id _Nullable))success failure:(void (^)(id _Nullable))faild{
    
    [self GETRequestDataWithUrl:urlString parameters:parameters success:^(id _Nullable responseObject) {
        success(responseObject);
        
    } faild:^(id _Nullable errorObject) {
        //数据请求失败
        if (![SCNetHelper isNetConnect]) {
            faild(@"网络异常，请检查网络设置!");
        } else {
            faild(@"网络访问超时，请检查网络设置!");
        }
        
        
    }];
    
}

/** 请求filmClass */
- (void)requestFilmClassDataWithUrl:(nullable NSString *)urlString parameters:(nullable NSDictionary *)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(id _Nullable errorObject))faild{
    
    [self GETRequestDataWithUrl:urlString parameters:parameters success:^(id _Nullable responseObject) {
        success(responseObject);
        
    } faild:^(id _Nullable errorObject) {
        //数据请求失败
        if (![SCNetHelper isNetConnect]) {
            faild(@"网络异常，请检查网络设置!");
        } else {
            faild(@"网络访问超时，请检查网络设置!");
        }
    }];
}

/** post通用请求方法 */
- (void)postRequestDataWithUrl:(nullable NSString *)urlString parameters:(nullable NSDictionary *)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(id _Nullable errorObject))faild
{
    [self POSTRequestDataWithUrl:urlString parameters:parameters success:^(id _Nullable responseObject){
        
        success(responseObject);
        
        
    } faild:^(id _Nullable errorObject) {
        //数据请求失败
        if (![SCNetHelper isNetConnect]) {
            faild(@"网络异常，请检查网络设置!");
            [MBProgressHUD showError:@"网络异常，请检查网络设置!"];
        } else {
            faild(errorObject);
            [MBProgressHUD showError:@"网络访问超时，请检查网络设置!"];
        }
    }];
    
    
}


/** get通用请求方法 */
- (void)requestDataWithUrl:(nullable NSString *)urlString parameters:(nullable NSDictionary *)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(id _Nullable errorObject))faild
{
    [self GETRequestDataWithUrl:urlString parameters:parameters success:^(id _Nullable responseObject) {
        
        success(responseObject);
        
    } faild:^(id _Nullable errorObject) {
        //数据请求失败
        if (![SCNetHelper isNetConnect]) {
            faild(@"网络异常，请检查网络设置!");
        } else {
            faild(@"网络访问超时，请检查网络设置!");
        }
        
    }];
    
}

/** json get通用请求方法 */
- (void)getRequestJsonDataWithUrl:(nullable NSString *)urlString parameters:(nullable NSDictionary *)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(id _Nullable errorObject))faild
{
    [self GETRequestJsonDataWithUrl:urlString parameters:parameters success:^(id _Nullable responseObject) {
        
        success(responseObject);
        
    } faild:^(id _Nullable errorObject) {
        //数据请求失败
        if (![SCNetHelper isNetConnect]) {
            faild(@"网络异常，请检查网络设置!");
        } else {
            faild(@"网络访问超时，请检查网络设置!");
        }
        
    }];
}

/** json post通用请求方法 */
- (void)postRequestJsonDataWithUrl:(nullable NSString *)urlString parameters:(nullable NSDictionary *)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(id _Nullable errorObject))faild
{
    [self POSTRequestJsonDataWithUrl:urlString parameters:parameters success:^(id _Nullable responseObject) {
        
        success(responseObject);
        
    } faild:^(id _Nullable errorObject) {
        //数据请求失败
        if (![SCNetHelper isNetConnect]) {
            faild(@"网络异常，请检查网络设置!");
        } else {
            faild(@"网络访问超时，请检查网络设置!");
        }
        
    }];
}


/** 域名替换成IP */
- (void)requestDataToReplaceDomainNameWithUrl:(nullable NSString *)urlString parameters:(nullable NSDictionary *)parameters success:(nullable void(^)(id _Nullable responseObject))success failure:(nullable void(^)(id _Nullable errorObject))faild
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //1.设置请求格式 返回XMLData
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //2.请求超时时间设置
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"------%@》》》》》》", error);
        if (faild) {
            faild(error);
        }
    }];
    
}

/** 文件上传 */
- (void)postUploadDataWithUrl:(nullable NSString *)urlStr video:(nullable NSData *)videoData imgData:(nullable NSData *)imgData  parameters:(NSDictionary *)parameters success:(nullable void (^)(id _Nullable responseObject))success fail:(nullable void (^)(id _Nullable errorObject))fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imgData name:@"pick" fileName:@"upload.png" mimeType:@"image/png"];
        [formData appendPartWithFileData:videoData name:@"video" fileName:@"upload.mp4" mimeType:@"video/mp4"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (success) {
            NSError *myError;
            id dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&myError];
            success(dic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //数据请求失败
        if (![SCNetHelper isNetConnect]) {
            fail(@"网络异常，请检查网络设置!");
            [MBProgressHUD showError:@"网络异常，请检查网络设置!"];
        } else {
            fail(@"获取数据失败!");
            [MBProgressHUD showError:@"提交失败，请重试!"];
        }
        
    }];
    
    
    
    
}














//******************☝️☝️☝️☝️☝️☝️☝️☝️下面为通用请求方法☝️☝️☝️☝️☝️☝️☝️☝️****************
//******************☝️☝️☝️☝️☝️☝️☝️☝️下面为通用请求方法☝️☝️☝️☝️☝️☝️☝️☝️****************
//******************☝️☝️☝️☝️☝️☝️☝️☝️下面为通用请求方法☝️☝️☝️☝️☝️☝️☝️☝️****************

- (void)POSTRequestDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id _Nullable))success faild:(void (^)(id _Nullable))faild {
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
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"text/xml", nil];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;//请求超时时间设置
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
            //利用XMLDictionary工具，将返回的XML直接转换为字典
            //            NSDictionary *dic = [NSDictionary dictionaryWithXMLParser:responseObject];
            NSDictionary *dic = [NSDictionary dictionaryWithXMLData:responseObject];
            //                        DONG_Log(@"======successdic:%@",dic);
            success(dic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"------%@》》》》》》", error);
        if (faild) {
            
        }
    }];
}

/** 返回数据为xml格式的GET请求 */
- (void)GETRequestDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id _Nullable))success faild:(void (^)(id _Nullable))faild {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    DONG_Log(@"url-->%@", urlString);
    DONG_Log(@"parameters-->%@", parameters);
    
    //1.设置请求格式
    // 1.1
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"text/xml", nil];
    // 1.2返回XMLParser
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    // 1.3返回XMLData
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //2.请求超时时间设置
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            //利用XMLDictionary工具，将返回的XML直接转换为字典
            NSDictionary *dic = [NSDictionary dictionaryWithXMLParser:responseObject];
            //NSDictionary *dic = [NSDictionary dictionaryWithXMLData:responseObject];
            //            NSLog(@"======dic:%@",dic);
            success(dic);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"------%@》》》》》》", error);
        if (faild) {
            //数据请求失败
            if (![SCNetHelper isNetConnect]) {
                faild(@"网络异常，请检查网络设置!");
                [MBProgressHUD showError:@"网络异常，请检查网络设置!"];
            } else {
                faild(error);
                [MBProgressHUD showError:@"网络访问超时，请检查网络设置!"];
            }
        }
    }];
}


/** 返回数据为json格式GET请求 */
- (void)GETRequestJsonDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id _Nullable))success faild:(void (^)(id _Nullable))faild {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    DONG_Log(@"url-->%@", urlString);
    DONG_Log(@"parameters-->%@", parameters);
    
    //1.设置请求格式
    // 1.1返回json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //2.请求超时时间设置
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSError *myError;
            id dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&myError];
            success(dic);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"------%@》》》》》》", error);
        if (faild) {
            //数据请求失败
            if (![SCNetHelper isNetConnect]) {
                faild(@"网络异常，请检查网络设置!");
                [MBProgressHUD showError:@"网络异常，请检查网络设置!"];
            } else {
                faild(error);
                [MBProgressHUD showError:@"网络访问超时，请检查网络设置!"];
            }
        }
    }];
}

/** 返回数据为json格式POST请求 */
- (void)POSTRequestJsonDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id _Nullable))success faild:(void (^)(id _Nullable))faild {
    
    DONG_Log(@"url-->%@", urlString);
    DONG_Log(@"parameters-->%@", parameters);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 响应序列化设置
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    // 请求序列化设置
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    
    manager.requestSerializer.timeoutInterval = 10;//请求超时时间设置
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSError *myError;
            id dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&myError];
            success(dic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"------%@》》》》》》", error);
        if (faild) {
            //数据请求失败
            if (![SCNetHelper isNetConnect]) {
                faild(@"网络异常，请检查网络设置!");
                [MBProgressHUD showError:@"网络异常，请检查网络设置!"];
            } else {
                faild(error);
                [MBProgressHUD showError:@"网络访问超时，请检查网络设置!"];
            }
        }
    }];
}




@end
