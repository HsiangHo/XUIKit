//
//  XUIAlertController.m
//  XUIKit
//
//  Created by Jovi on 8/2/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIAlertController.h"

@implementation XUIAlertAction{
    NSString                        *_title;
    XUIAlertActionStyle             _style;
    BOOL                            _enabled;
    XUIAlertActionHandlerBlock      _handler;
}

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(XUIAlertActionStyle)style handler:(XUIAlertActionHandlerBlock)handler{
    return [[XUIAlertAction alloc] initWithTitle:title style:style handler:handler];
}

-(instancetype)initWithTitle:(nullable NSString *)title style:(XUIAlertActionStyle)style handler:(XUIAlertActionHandlerBlock)handler{
    if(self = [super init]){
        _title = title;
        _style = style;
        _enabled = YES;
        _handler = handler;
    }
    return self;
}

@end


@interface XUIAlertController ()

@end

@implementation XUIAlertController{
    NSMutableArray<XUIAlertAction *>        *_actions;
    XUIAlertAction                          *_preferredAction;
    XUIView                                 *_accessoryView;
    NSString                                *_alertTitle;
    NSString                                *_alertMessage;
}

#pragma mark - Override methods

- (instancetype)initAlertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message{
    if (self = [super init]) {
        _alertTitle = title;
        _alertMessage = message;
        [self __initializeXUIAlertController];
    }
    return self;
}

#pragma mark - Public methods

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message{
    return [[XUIAlertController alloc] initAlertControllerWithTitle:title message:message];
}

- (void)addAction:(XUIAlertAction *)action{
    
}

-(NSArray<XUIAlertAction *> *)actions{
    return [_actions copy];
}

#pragma mark - Private methods

- (void)__initializeXUIAlertController{
    _actions = [[NSMutableArray alloc] init];
    _accessoryView = nil;
}

@end
