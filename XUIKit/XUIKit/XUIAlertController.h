//
//  XUIAlertController.h
//  XUIKit
//
//  Created by Jovi on 8/2/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XUIView.h"
#import "XUIButton.h"

NS_ASSUME_NONNULL_BEGIN

@class XUIAlertAction;
typedef void(^XUIAlertActionHandlerBlock)(XUIAlertAction *action);

@interface XUIAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title handler:(XUIAlertActionHandlerBlock)handler;

@property (nullable, nonatomic, readonly) XUIButton *actionButton;

@end

@interface XUIAlertController : NSViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

- (void)addAction:(XUIAlertAction *)action;
@property (nonatomic, readonly) NSArray<XUIAlertAction *> *actions;

@property (nullable, nonatomic, strong) XUIView *accessoryView;

@property (nullable, nonatomic, copy) NSString *alertTitle;
@property (nullable, nonatomic, copy) NSString *alertMessage;

@property (nullable, nonatomic, strong) NSColor *alertTitleColor;
@property (nullable, nonatomic, strong) NSColor *alertMessageColor;
@property (nullable, nonatomic, strong) NSColor *alertBackgroundColor;

@end

NS_ASSUME_NONNULL_END
