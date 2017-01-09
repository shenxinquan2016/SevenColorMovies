//
//  SCXMPPManager.h
//  SevenColorMovies
//
//  Created by yesdgq on 17/1/9.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPP.h>

@protocol SCXMPPManagerDelegate <NSObject>
@required
- (void)didReceiveMessage:(XMPPMessage*)message;

@end


@interface SCXMPPManager : NSObject

@property (nonatomic, weak) id<SCXMPPManagerDelegate> delegate;

+ (instancetype)shareManager;
- (void)disconnect;
- (void)initXMPPWithUserName:(NSString *)name andPassWord:(NSString *)passWord;
- (XMPPMessage *)sendMessageWithBody:(NSString *)body andToName:(NSString *)toName andType:(NSString *)type;


@end

