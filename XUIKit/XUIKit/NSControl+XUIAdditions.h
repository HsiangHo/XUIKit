//
//  NSControl+XUIAdditions.h
//  XUIKit
//
//  Created by Jovi on 6/13/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XUIType.h"

@interface NSControl (XUIAdditions)

@property(nonatomic,readonly) XUIControlState state;

@property (nonatomic, assign) BOOL acceptsFirstMouse;

// add target/action for particular event. you can call this multiple times and you can specify multiple target/actions for a particular event.
// passing in nil as the target goes up the responder chain. The action may optionally include the sender and the event in that order
// the action cannot be NULL. Note that the target is not retained.
- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(XUIControlEvents)controlEvents;
- (void)addActionForControlEvents:(XUIControlEvents)controlEvents block:(void(^)(void))action;

// remove the target/action for a set of events. pass in NULL for the action to remove all actions for that target
- (void)removeTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(XUIControlEvents)controlEvents;
- (void)removeAllTargets;


- (NSSet *)allTargets;
- (XUIControlEvents)allControlEvents;
- (NSArray *)actionsForTarget:(id)target forControlEvent:(XUIControlEvents)controlEvent;

- (void)sendAction:(SEL)action to:(id)target forEvent:(NSEvent *)event;
- (void)sendActionsForControlEvents:(XUIControlEvents)controlEvents;

@end
