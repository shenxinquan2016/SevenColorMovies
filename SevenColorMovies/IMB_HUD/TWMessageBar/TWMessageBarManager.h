//
//  TWMessageBarManager.h
//
//  Created by Terry Worona on 5/13/13.
//  Copyright (c) 2013 Terry Worona. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  VIEW 宽高和名字（可改）
 *
 *  @return nil...
 */
#define TW_HEIGHT 35
#define TW_WIDTH 280
#define TWBar [TWMessageBarManager sharedInstance]

/**
 *  Three base message bar types. Their look & feel is defined within the MessageBarStyleSheet.
 */

typedef enum {
    TWError,
    TWSuccess,
    TWInfo
} TWMessageBarMessageType;

@protocol TWMessageBarStyleSheet <NSObject>

/**
 *  Background color of message view.
 *
 *  @param type A MessageBarMessageType (error, information, success, etc).
 *
 *  @return UIColor istance representing the message view's background color.
 */
- (UIColor *)backgroundColorForMessageType:(TWMessageBarMessageType)type;

/**
 *  Bottom stroke color of message view.
 *
 *  @param type A MessageBarMessageType (error, information, success, etc).
 *
 *  @return UIColor istance representing the message view's bottom stroke color.
 */
- (UIColor *)strokeColorForMessageType:(TWMessageBarMessageType)type;

/**
 *  Icon image of the message view.
 *
 *  @param type A MessageBarMessageType (error, information, success, etc)
 *
 *  @return UIImage istance representing the message view's icon.
 */
- (UIImage *)iconImageForMessageType:(TWMessageBarMessageType)type;

@end

@interface TWMessageBarManager : NSObject

/**
 *  Singleton instance through which all presentation is managed.
 *
 *  @return MessageBarManager instance (singleton).
 */
+ (TWMessageBarManager *)sharedInstance;

/**
 *  An object conforming to the TWMessageBarStyleSheet protocol defines the message bar's look and feel.
 *  If no style sheet is supplied, a default class is provided on initialization (see implementation for details).
 */
@property (nonatomic, strong) NSObject<TWMessageBarStyleSheet> *styleSheet;

/**
 *  Shows a message with the supplied title, description and type (dictates color, stroke and icon).
 *
 *  @param title        Header text in the message view.
 *  @param description  Description text in the message view.
 *  @param type         Type dictates color, stroke and icon shown in the message view.
 */
- (void)showMessageWithTitle:(NSString *)title description:(NSString *)description type:(TWMessageBarMessageType)type;

/**
 *  Shows a message with the supplied title, description, type (dictates color, stroke and icon) & callback block.
 *
 *  @param title        Header text in the message view.
 *  @param description  Description text in the message view.
 *  @param type         Type dictates color, stroke and icon shown in the message view.
 *  @param callback     Callback block to be executed if a message is tapped.
 */
- (void)showMessageWithTitle:(NSString *)title description:(NSString *)description type:(TWMessageBarMessageType)type callback:(void (^)())callback;

/**
 *  Shows a message with the supplied title, description, type (dictates color, stroke and icon) & duration.
 *
 *  @param title        Header text in the message view.
 *  @param description  Description text in the message view.
 *  @param type         Type dictates color, stroke and icon shown in the message view.
 *  @param duration     Default duration is 3 seconds, this can be overridden by supplying an optional duration parameter.
 */
- (void)showMessageWithTitle:(NSString *)title description:(NSString *)description type:(TWMessageBarMessageType)type duration:(CGFloat)duration;

/**
 *  Shows a message with the supplied title, description, type (dictates color, stroke and icon), callback block & duration.
 *
 *  @param title        Header text in the message view.
 *  @param description  Description text in the message view.
 *  @param type         Type dictates color, stroke and icon shown in the message view.
 *  @param duration     Default duration is 3 seconds, this can be overridden by supplying an optional duration parameter.
 *  @param callback     Callback block to be executed if a message is tapped.
 */
// modify by lzc 简化
- (void)showMessageWithTitle:(NSString *)title description:(NSString *)description type:(TWMessageBarMessageType)type duration:(CGFloat)duration callback:(void (^)())callback;

/**
 *  Hides the topmost message from view and removes all remaining messages in the queue (not animated).
 */
- (void)hideAll;

/**
 *  view刚出现时原始位置
 */
@property (nonatomic) NSInteger originalLocation;

/**
 *  view最终显示的位置
 */
@property (nonatomic) NSInteger dispLocation;

/**
 *  初始化
 *
 *  @param title       view的标题
 *  @param type        view的类型
 *  @param duration    view持续显示的时间
 *  @param locations   view的原始位置和最终显示的位置。索引0为原始、1为最终显示的位置
 *  @param callBack    view回调
 */
- (void)title:(NSString *)title type:(TWMessageBarMessageType)type duration:(CGFloat)duration places:(NSArray *)places callBack:(void(^)())callBack;

@end
