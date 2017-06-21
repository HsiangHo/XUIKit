//
//  NSControl+XUIAdditions.m
//  XUIKit
//
//  Created by Jovi on 6/13/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "NSControl+XUIAdditions.h"
#import "XUIProperty.h"
#import "XUIView.h"
#import "XUIControlTargetAction.h"
#import "NSControl+Private.h"
#import "XUIMethodsHelper.h"

#define kAcceptsFirstMouse          @"acceptsFirstMouse"
#define kTargetActions              @"targetActions"
#define kCurrentState               @"currentState"

@implementation NSControl (XUIAdditions)

+(void)load{
    Class cls = [NSControl class];
    XUISwizzleMethod(cls, '-', @selector(xui_mouseDown:),@selector(mouseDown:));
    XUISwizzleMethod(cls, '-', @selector(xui_mouseUp:),@selector(mouseUp:));
    XUISwizzleMethod(cls, '-', @selector(xui_mouseEntered:),@selector(mouseEntered:));
    XUISwizzleMethod(cls, '-', @selector(xui_mouseExited:),@selector(mouseExited:));
    XUISwizzleMethod(cls, '-', @selector(xui_mouseMoved:),@selector(mouseMoved:));
}

- (BOOL)acceptsFirstMouse
{
    return [(NSNumber *)XUI_GET_PROPERTY(kAcceptsFirstMouse) boolValue];
}

- (void)setAcceptsFirstMouse:(BOOL)acceptsFirstMouse
{
    XUI_SET_PROPERTY([NSNumber numberWithBool:acceptsFirstMouse], kAcceptsFirstMouse);
}

- (XUIControlState)controlState
{
    return [self __currentState];
}

#pragma mark - Override

- (BOOL)acceptsFirstMouse:(NSEvent *)event{
    return [self acceptsFirstMouse];
}

#pragma mark - Private Functions

-(XUIControlState)__currentState{
    return [(NSNumber *)XUI_GET_PROPERTY(kCurrentState) unsignedIntegerValue];
}

-(void)__setCurrentState:(XUIControlState)state{
    XUI_SET_PROPERTY([NSNumber numberWithUnsignedInteger:state], kCurrentState);
}

#pragma mark - Swizzle Functions

- (void)xui_mouseDown:(NSEvent *)event{
    [self xui_mouseDown:event];
    
    [self __stateWillChange];
    [self __setCurrentState:XUIControlStateDown];
    [self __stateDidChange];
    
    if([event clickCount] < 2) {
        [self sendActionsForControlEvents:XUIControlEventTouchDown];
    } else {
        [self sendActionsForControlEvents:XUIControlEventTouchDownRepeat];
    }
    
    [self setNeedsDisplay];
}

- (void)xui_mouseUp:(NSEvent *)event{
    [self xui_mouseUp:event];

    [self __stateWillChange];
    [self __setCurrentState:XUIControlStateUp];
    [self __stateDidChange];
    
    if([self eventInside:event]) {
            [self sendActionsForControlEvents:XUIControlEventTouchUpInside];
    }else{
        [self sendActionsForControlEvents:XUIControlEventTouchUpOutside];
    }
    
    [self setNeedsDisplay];
}

-(void)xui_mouseMoved:(NSEvent *)event{
    [self xui_mouseMoved:event];
    
    [self __stateWillChange];
    [self __setCurrentState:XUIControlStateHovered];
    [self __stateDidChange];
    
    [self setNeedsDisplay];
}

- (void)xui_mouseEntered:(NSEvent *)event{
    [self xui_mouseEntered:event];
    
    [self __stateWillChange];
    [self __setCurrentState:XUIControlStateHovered];
    [self __stateDidChange];
    
    [self setNeedsDisplay];
}

- (void)xui_mouseExited:(NSEvent *)event{
    [self xui_mouseExited:event];
    
    [self __stateWillChange];
    [self __setCurrentState:XUIControlStateNormal];
    [self __stateDidChange];
    
    [self setNeedsDisplay];
}

#pragma mark - Private Action

-(NSMutableArray *)__targetActions{
    NSMutableArray *arrayTargetActions = XUI_GET_PROPERTY(kTargetActions);
    if (nil == arrayTargetActions) {
        arrayTargetActions = [[NSMutableArray alloc] init];
        XUI_SET_PROPERTY(arrayTargetActions, kTargetActions);
    }
    return arrayTargetActions;
}

#pragma mark - Actions

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(XUIControlEvents)controlEvents{
    if(action) {
        XUIControlTargetAction *cta = [[XUIControlTargetAction alloc] init];
        cta.target = target;
        cta.action = action;
        cta.controlEvents = controlEvents;
        [[self __targetActions] addObject:cta];
    }
}

- (void)addActionForControlEvents:(XUIControlEvents)controlEvents block:(void(^)(void))action{
    if(nil != action) {
        XUIControlTargetAction *cta = [[XUIControlTargetAction alloc] init];
        cta.block = action;
        cta.controlEvents = controlEvents;
        [[self __targetActions] addObject:cta];
    }
}

- (void)removeTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(XUIControlEvents)controlEvents{
    NSMutableArray *targetActionsToRemove = [[NSMutableArray alloc] init];
    NSMutableArray *targetActions = [self __targetActions];
    if (XUIControlEventAllEvents == controlEvents) {
        [targetActions removeAllObjects];
        return;
    }
    for(XUIControlTargetAction *cta in targetActions) {
        BOOL targetMatches = ([target isEqual:cta.target]);
        BOOL eventMatches = (controlEvents == cta.controlEvents);
        if (eventMatches) {
            if (targetMatches || nil == target) {
                [targetActionsToRemove addObject:cta];
            }
        }
    }
    [targetActions removeObjectsInArray:targetActionsToRemove];
}

- (void)removeAllTargets{
    for (id target in [self allTargets]) {
        [self removeTarget:target action:NULL forControlEvents:XUIControlEventAllEvents];
    }
}

- (NSSet *)allTargets{
    NSMutableSet *targets = [NSMutableSet set];
    NSMutableArray *targetActions = [self __targetActions];
    for(XUIControlTargetAction *cta in targetActions) {
        id target = cta.target;
        [targets addObject: target ? target : [NSNull null]];
    }
    return targets;
}

- (XUIControlEvents)allControlEvents{
    XUIControlEvents events = 0;
    for(XUIControlTargetAction *cta in [self __targetActions]) {
        events |= cta.controlEvents;
    }
    return events;
}

- (NSArray *)actionsForTarget:(id)target forControlEvent:(XUIControlEvents)controlEvent{
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    NSMutableArray *targetActions = [self __targetActions];
    for(XUIControlTargetAction *cta in targetActions) {
        if([target isEqual:cta.target] &&(XUIControlEventAllEvents == cta.controlEvents || controlEvent == cta.controlEvents)) {
            [actions addObject:NSStringFromSelector(cta.action)];
        }
    }
    
    if([actions count])
        return actions;
    return nil;
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(NSEvent *)event{
    [NSApp sendAction:action to:target from:self];
}

- (void)sendActionsForControlEvents:(XUIControlEvents)controlEvents{
    NSMutableArray *targetActions = [self __targetActions];
    for(XUIControlTargetAction *cta in targetActions) {
        if(cta.controlEvents == controlEvents || XUIControlEventAllEvents == cta.controlEvents) {
            if(cta.action) {
                [self sendAction:cta.action to:cta.target forEvent:nil];
            }else if(cta.block) {
                cta.block();
            }
        }
    }
}

@end
