//
//  XUIAlertController.h
//  XUIKit
//
//  Created by Jovi on 8/2/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XUIView.h"

NS_ASSUME_NONNULL_BEGIN

@class XUIAlertAction;
typedef void(^XUIAlertActionHandlerBlock)(XUIAlertAction *action);

typedef NS_ENUM(NSInteger, XUIAlertActionStyle) {
    XUIAlertActionStyleDefault = 0,
    XUIAlertActionStyleDestructive
};

@interface XUIAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(XUIAlertActionStyle)style handler:(XUIAlertActionHandlerBlock)handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) XUIAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

@interface XUIAlertController : NSViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

- (void)addAction:(XUIAlertAction *)action;
@property (nonatomic, readonly) NSArray<XUIAlertAction *> *actions;

@property (nonatomic, strong, nullable) XUIAlertAction *preferredAction;

@property (nullable, nonatomic, strong) XUIView *accessoryView;

@property (nullable, nonatomic, copy) NSString *AlertTitle;
@property (nullable, nonatomic, copy) NSString *AlertMessage;

@end

NS_ASSUME_NONNULL_END
