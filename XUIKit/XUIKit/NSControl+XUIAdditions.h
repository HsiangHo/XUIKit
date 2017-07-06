//
//  NSControl+XUIAdditions.h
//  XUIKit
//
//  Created by Jovi on 6/13/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XUIType.h"

typedef void (^XUIControlStateActionBlock)( NSControl * _Nonnull control, XUIControlState currentState);

@interface NSControl (XUIAdditions)

@property(nonatomic,readonly) XUIControlState controlState;

@property (nonatomic, assign) BOOL acceptsFirstMouse;

// effectiveAreaPath will affect the control's response area.
@property (nullable, nonatomic, strong) NSBezierPath  *effectiveAreaPath;

// if state is changing or changed,the block will be called.
-(void)setStateWillChangeBlock:(nullable XUIControlStateActionBlock) block;
-(void)setStateDidChangeBlock:(nullable XUIControlStateActionBlock) block;

// add target/action for particular event. you can call this multiple times and you can specify multiple target/actions for a particular event.
// passing in nil as the target goes up the responder chain. The action may optionally include the sender and the event in that order
// the action cannot be NULL. Note that the target is not retained.
- (void)addTarget:(nullable id)target action:(nonnull SEL)action forControlEvents:(XUIControlEvents)controlEvents;
- (void)addActionForControlEvents:(XUIControlEvents)controlEvents block:(nonnull void(^)(void))action;

// remove the target/action for a set of events. pass in NULL for the action to remove all actions for that target
- (void)removeTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(XUIControlEvents)controlEvents;
- (void)removeAllTargets;


- (nonnull NSSet *)allTargets;
- (XUIControlEvents)allControlEvents;
- (nullable NSArray *)actionsForTarget:(nullable id)target forControlEvent:(XUIControlEvents)controlEvent;

- (void)sendAction:(nonnull SEL)action to:(nullable id)target forEvent:(nullable NSEvent *)event;
- (void)sendActionsForControlEvents:(XUIControlEvents)controlEvents;

@end
