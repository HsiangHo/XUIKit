//
//  NSControl+XUIAdditions.h
//  XUIKit
//
//  Created by Jovi on 6/13/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum {
    XUIControlEventTouchDown           = 1 <<  0,
    XUIControlEventTouchDownRepeat     = 1 <<  1,
    XUIControlEventTouchUpInside       = 1 <<  2,
    XUIControlEventTouchUpOutside      = 1 <<  3,
};
typedef NSUInteger XUIControlEvents;

enum {
    XUIControlStateNormal       = 0,
    XUIControlStateHovered      = 1 << 0,
    XUIControlStateDown         = 1 << 1,
    XUIControlStateUp           = 1 << 2,
    XUIControlStateDisabled     = 1 << 3,
    XUIControlStateFocused      = 1 << 4,
    XUIControlStateNotKey       = 1 << 11,
};
typedef NSUInteger XUIControlState;

@interface NSControl (XUIAdditions)

@property(nonatomic,readonly) XUIControlState state;

@property (nonatomic, assign) BOOL acceptsFirstMouse;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(XUIControlEvents)controlEvents;

- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(XUIControlEvents)controlEvents;

- (void)addActionForControlEvents:(XUIControlEvents)controlEvents block:(void(^)(void))action;

- (NSSet *)allTargets;
- (XUIControlEvents)allControlEvents;
- (NSArray *)actionsForTarget:(id)target forControlEvent:(XUIControlEvents)controlEvent;

- (void)sendAction:(SEL)action to:(id)target forEvent:(NSEvent *)event;
- (void)sendActionsForControlEvents:(XUIControlEvents)controlEvents;

@end
