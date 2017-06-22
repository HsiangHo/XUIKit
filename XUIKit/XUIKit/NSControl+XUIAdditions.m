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
#define kCurrentStateFlags          @"currentStateFlag"

typedef struct _xui_stateFlags{
    unsigned char down;
    unsigned char tracking;
    unsigned char inside;
}xui_stateFlags;

@implementation NSControl (XUIAdditions)

+(void)load{
    Class cls = [NSControl class];
    XUISwizzleMethod(cls, '-', @selector(xui_mouseDown:),@selector(mouseDown:));
    XUISwizzleMethod(cls, '-', @selector(xui_mouseUp:),@selector(mouseUp:));
    XUISwizzleMethod(cls, '-', @selector(xui_mouseEntered:),@selector(mouseEntered:));
    XUISwizzleMethod(cls, '-', @selector(xui_mouseExited:),@selector(mouseExited:));
    XUISwizzleMethod(cls, '-', @selector(xui_mouseMoved:),@selector(mouseMoved:));
    XUISwizzleMethod(cls, '-', @selector(xui_hitTest:),@selector(hitTest:));
    XUISwizzleMethod(cls, '-', @selector(xui_setEnabled:),@selector(setEnabled:));
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
    XUIControlState state = XUIControlStateNormal;
    xui_stateFlags flags = [self __currentStateFlags];
    if(self.enabled){
        if(flags.tracking && flags.inside){
            state = XUIControlStateHovered;
        }else if(!flags.tracking && flags.inside){
            if(flags.down){
                state = XUIControlStateDown;
            }else{
                state = XUIControlStateUp;
            }
        }else{
            if(self == [[self window] firstResponder]){
                state = XUIControlStateFocused;
            }
        }
    }else{
        state = XUIControlStateDisabled;
    }
    return state;
}

#pragma mark - Override

- (BOOL)acceptsFirstMouse:(NSEvent *)event{
    return [self acceptsFirstMouse];
}

#pragma mark - Private Functions

-(xui_stateFlags)__currentStateFlags{
    xui_stateFlags flags = { 0 };
    [(NSValue *)XUI_GET_PROPERTY(kCurrentStateFlags) getValue:&flags];
    return flags;
}

-(void)__setCurrentStateFlags:(xui_stateFlags)flags{
    NSValue *value = [NSValue valueWithBytes:&flags objCType:@encode(xui_stateFlags)];
    XUI_SET_PROPERTY(value, kCurrentStateFlags);
}

#pragma mark - Swizzle Functions

- (void)xui_mouseDown:(NSEvent *)event{
    [self __stateWillChange];
    xui_stateFlags flags = [self __currentStateFlags];
    flags.down = 1;
    flags.inside = 1;
    flags.tracking = 0;
    [self __setCurrentStateFlags:flags];
    [self __stateDidChange];
    [self setNeedsDisplay];
    
    if(!self.enabled){
        [self xui_mouseDown:event];
    }else{
        if([event clickCount] < 2) {
            [self sendActionsForControlEvents:XUIControlEventTouchDown];
        } else {
            [self sendActionsForControlEvents:XUIControlEventTouchDownRepeat];
        }
        [self xui_mouseDown:event];
        [self mouseUp:event];
    }
}

- (void)xui_mouseUp:(NSEvent *)event{
    [self __stateWillChange];
    xui_stateFlags flags = [self __currentStateFlags];
    flags.down = 0;
    flags.tracking = 0;
    [self __setCurrentStateFlags:flags];
    [self __stateDidChange];
    [self setNeedsDisplay];
    
    if(self.enabled){
        if([self eventInside:event]) {
            [self sendActionsForControlEvents:XUIControlEventTouchUpInside];
        }else{
            [self sendActionsForControlEvents:XUIControlEventTouchUpOutside];
        }
    }
    [self xui_mouseUp:event];
}

-(void)xui_mouseMoved:(NSEvent *)event{
    [self xui_mouseMoved:event];
    
    [self __stateWillChange];
    xui_stateFlags flags = [self __currentStateFlags];
    flags.tracking = 1;
    flags.inside = 1;
    [self __setCurrentStateFlags:flags];
    [self __stateDidChange];
    
    [self setNeedsDisplay];
}

- (void)xui_mouseEntered:(NSEvent *)event{
    [self xui_mouseEntered:event];
    
    [self __stateWillChange];
    xui_stateFlags flags = [self __currentStateFlags];
    flags.tracking = 1;
    flags.inside = 1;
    [self __setCurrentStateFlags:flags];
    [self __stateDidChange];
    
    [self setNeedsDisplay];
}

- (void)xui_mouseExited:(NSEvent *)event{
    [self xui_mouseExited:event];
    
    [self __stateWillChange];
    xui_stateFlags flags = [self __currentStateFlags];
    flags.tracking = 0;
    flags.inside = 0;
    [self __setCurrentStateFlags:flags];
    [self __stateDidChange];
    
    [self setNeedsDisplay];
}

-(NSView *)xui_hitTest:(NSPoint)point{
    NSView *view = nil;
    if ([self isUserInteractionEnabled]) {
        view = [self xui_hitTest:point];
    }
    return view;
}

-(void)xui_setEnabled:(BOOL)enabled{
    if (enabled != [self isEnabled]) {
        [self __stateWillChange];
        [self xui_setEnabled:enabled];
        [self __stateDidChange];
    }else{
        [self xui_setEnabled:enabled];
    }
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
