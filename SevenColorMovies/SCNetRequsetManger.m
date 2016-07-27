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



//例子1
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
#warning 这里换成自己需要的model
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
            faild(@"获取数据失败!");
        }
    }];
}
//******************☝️☝️☝️☝️☝️☝️☝️☝️下面为某个需要调用的方法☝️☝️☝️☝️☝️☝️☝️☝️****************


















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
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"multipart/form-data",nil];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",nil];
    
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;//请求超时时间设置
    //设置请求格式
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    // 手机串号
    //    NSArray *deviceIds = [DEVICE_ID componentsSeparatedByString:@"-"];
    //    NSString *uid = [deviceIds componentsJoinedByString:@""];
    
    
    
    [newParameters setObject:@"iOS" forKey:@"system"];//客户端操作系统
    [newParameters setObject:[DNIPhoneInfo deviceType] forKey:@"device"];// 客户端机型
    [newParameters setObject:[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] forKey:@"version"];//客户端版本
    [newParameters setObject:[[UIDevice currentDevice] systemVersion] forKey:@"sysModel"];
    //    NSLog(@"---- %@",newParameters);
    
    [manager POST:urlString parameters:newParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            //            NSLog(@"==============%@===============",operation);
            NSError *myError;
            id dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&myError];
            
            if ([dic[@"msg"] isEqualToString:@"无效Token"] || [[dic[@"code"] description] isEqualToString:@"110"]) {//token无效的code是 110
//                if (_loginVC == nil) {
//                    _loginVC = TL_INSTANT_VC_WITH_ID(@"Main", @"CPLoginViewController");
//                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_loginVC];
//                    [TL_KEYWINDOW.rootViewController presentViewController:nav animated:YES completion:nil];
//                }
                UserInfoManager.isLogin = NO;
                [dic setObject:@"用户身份已过期，请重新登录！" forKey:@"msg"];
                return ;
                //success(dic);
            } else {
                success(dic);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"------%@》》》》》》", error);
        if (faild) {
            faild(error);
        }
    }];
}


- (void)GETRequestDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(id _Nullable))success faild:(void (^)(id _Nullable))faild {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    manager.requestSerializer.timeoutInterval = 10;//请求超时时间设置
    // 设置请求格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSError *myError;
            id dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&myError];
            success(dic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"------%@》》》》》》", error);
        if (faild) {
            faild(error);
        }
    }];
}


@end
