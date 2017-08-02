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

@implementation XUIAlertController


@end
