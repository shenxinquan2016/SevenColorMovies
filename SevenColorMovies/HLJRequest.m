//
//  HLJRequest.m
//  HLJXmlResqust
//
//  Created by Kevin on 16/4/12.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "HLJRequest.h"
#import "HLJDomainNameModel.h"

//NSString *const DomainNameXMLURL = @"http://10.177.1.198:8095/b2b/search/domainIpRel.htm";
NSString *const DomainNameXMLURL = @"http://10.177.1.100:8095/b2b/search/domainIpRel.htm";

/**
 *  isIpReplace： 是否进行ip转换开关
 *  YES        ： 进行ip转换
 *  NO         ： 不进行ip转换
 */
BOOL isIpReplace = NO;

@interface HLJRequest ()<NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, copy) NSString *currentElementName;
@property (nonatomic, strong) HLJDomainNameModel *model;

/**
 *  含有要解析的域名的播放串
 */
@property (nonatomic, copy) NSString *videoURL;
/**
 *  域名ip字典
 */
@property (nonatomic, strong) NSMutableDictionary *domainNamesDic;
/**
 *  解析成功回调
 */
@property (nonatomic, copy) XMLParseIPSuccess parseIPSuccess;
/**
 *  解析失败回调
 */
@property (nonatomic, copy) XMLParseIPFailure parseIPFailure;

@end

@implementation HLJRequest

+ (instancetype)requestWithPlayVideoURL:(NSString *)videoURL{
    return [[self alloc] initWithVideoURL:videoURL];
}

#pragma mark - 初始化

- (instancetype)initWithVideoURL:(NSString *)videoURL {
    if (self = [super init]) {
        self.videoURL = videoURL;
    }
    return self;
}

#pragma mark - Network

- (void)loadXMLData{
    
    DONG_WeakSelf(self);
    DONG_StrongSelf(self);
    [requestDataManager requestDataToReplaceDomainNameWithUrl:DomainNameXMLURL parameters:nil success:^(id info) {
        
        [strongself beginParse:info];
        
    } failure:^(NSError *error) {
        
        NSLog(@"HLJRequest---loadXMLDataError---%@",error);
        if (strongself.parseIPFailure) {
            strongself.parseIPFailure(error);
        }
    }];
    
}

#pragma mark - XMLParser Delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    
    //获取节点名称
    self.currentElementName = elementName;
    if ([elementName isEqualToString:@"rel"]) {
        self.model = [[HLJDomainNameModel alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if ([self.currentElementName isEqualToString:@"domainName"]) {
        self.model.domainName = string;
    }else if ([self.currentElementName isEqualToString:@"ip"]) {
        self.model.ip = string;
    }
}

#warning      if (self.model.domainName && self.model.ip)
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"rel"]) {
        if (self.model.domainName && self.model.ip) {
            NSDictionary *dic = @{
                                  self.model.domainName:self.model.ip
                                  };
            [self.domainNamesDic setValuesForKeysWithDictionary:dic];
        }
    }
    
    self.currentElementName = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
    NSString *videoURL = [self getNewVideoURL];
    
    //解析完成 实现回调
    if (self.parseIPSuccess) {
        self.parseIPSuccess(videoURL);
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    if (self.parseIPFailure) {
        self.parseIPFailure(parseError);
    }
}

#pragma mark - 根据域名获得ip

- (NSString *)getNewVideoURL{
    
    return [self getNewViedoURLByOriginVideoURL:self.videoURL];
}

- (NSString *)getNewViedoURLByOriginVideoURL:(NSString *)videoURL{
    
    if (isIpReplace) {
    
    NSArray<NSString *> *keysArray = [self.domainNamesDic allKeys];
    
    NSString *ipStr = videoURL;
    
    for (NSString *key in keysArray) {
        if ([videoURL containsString:key]) {
            
            ipStr = [ipStr stringByReplacingOccurrencesOfString:key
                                                     withString:[self.domainNamesDic valueForKey:key]];
            break;
        }
    }
    
    return ipStr;
        
    } else {
        
        return videoURL;
    }
}

#pragma mark - 外部调用接口

- (void)getNewVideoURLSuccess:(XMLParseIPSuccess )parseSuccess
                      failure:(XMLParseIPFailure )parseFailure{
    
    if (isIpReplace) {
        
        self.parseIPSuccess = [parseSuccess copy];
        self.parseIPFailure = [parseFailure copy];
        
        [self loadXMLData];
        
    } else {
        
        parseSuccess(self.videoURL);
    }
    
}

#pragma mark - 解析接口

- (void)beginParse:(NSData *)response{
    
    self.parser = [[NSXMLParser alloc] initWithData:response];
    self.parser.delegate = self;
    [self.parser parse];
}

#pragma mark - 懒加载

- (NSMutableDictionary *)domainNamesDic{
    if (_domainNamesDic == nil) {
        _domainNamesDic = [NSMutableDictionary dictionary];
    }
    return _domainNamesDic;
}

@end
