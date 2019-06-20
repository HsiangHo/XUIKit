//
//  NSControl+XUIAdditions.m
//  XUIKit
//
//  Created by Jovi on 6/13/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "NSControl+XUIAdditions.h"
#import "NSResponder+Private.h"
#import "XUIProperty.h"
#import "XUIView.h"
#import "XUIControlTargetAction.h"
#import "NSControl+Private.h"
#import "XUIMethodsHelper.h"

#define kAcceptsFirstMouse          @"acceptsFirstMouse"
#define kTargetActions              @"targetActions"
#define kCurrentStateFlags          @"currentStateFlag"
#define kEffictiveAreaPath          @"effictiveAreaPath"
#define kStateWillChangeBlock       @"stateWillChangeBlock"
#define kStateDidChangeBlock        @"stateDidChangeBlock"

typedef struct _xui_stateFlags{
    unsigned char down;
    unsigned char tracking;
    unsigned char inside;
}xui_stateFlags;

@implementation NSControl (XUIAdditions)

+(void)load{
    //SwizzleMethods
    RSSwizzleInstanceMethod([NSControl class], @selector(mouseDown:), RSSWReturnType(void), RSSWArguments(NSEvent *event), RSSWReplacement({
        [self __stateWillChange];
        xui_stateFlags flags = [self __currentStateFlags];
        flags.down = 1;
        flags.inside = 1;
        flags.tracking = 0;
        [self __setCurrentStateFlags:flags];
        [self __stateDidChange];
        [self setNeedsDisplay];

        if(!((NSButton *)self).enabled){
            RSSWCallOriginal(event);
        }else{
            if([event clickCount] < 2) {
                [self sendActionsForControlEvents:XUIControlEventTouchDown];
            } else {
                [self sendActionsForControlEvents:XUIControlEventTouchDownRepeat];
            }
            RSSWCallOriginal(event);
            [self mouseUp:event];
        }
    }), RSSwizzleModeAlways, NULL);

    RSSwizzleInstanceMethod([NSControl class], @selector(mouseUp:), RSSWReturnType(void), RSSWArguments(NSEvent *event), RSSWReplacement({
        [self __stateWillChange];
        xui_stateFlags flags = [self __currentStateFlags];
        flags.down = 0;
        flags.tracking = 0;
        [self __setCurrentStateFlags:flags];
        [self __stateDidChange];
        [self setNeedsDisplay];

        if(((NSButton *)self).enabled){
            if([self eventInside:event]) {
                [self sendActionsForControlEvents:XUIControlEventTouchUpInside];
            }else{
                [self sendActionsForControlEvents:XUIControlEventTouchUpOutside];
            }
        }
        RSSWCallOriginal(event);
    }), RSSwizzleModeAlways, NULL);

    RSSwizzleInstanceMethod([NSControl class], @selector(mouseEntered:), RSSWReturnType(void), RSSWArguments(NSEvent *event), RSSWReplacement({
        RSSWCallOriginal(event);
        if([self __isPointInEffectiveArea:event.locationInWindow]){
            [self __stateWillChange];
            xui_stateFlags flags = [self __currentStateFlags];
            flags.tracking = 1;
            flags.inside = 1;
            [self __setCurrentStateFlags:flags];
            [self __stateDidChange];
            [self setNeedsDisplay];
        }
    }), RSSwizzleModeAlways, NULL);

    RSSwizzleInstanceMethod([NSControl class], @selector(mouseExited:), RSSWReturnType(void), RSSWArguments(NSEvent *event), RSSWReplacement({
        RSSWCallOriginal(event);
        [self __stateWillChange];
        xui_stateFlags flags = [self __currentStateFlags];
        flags.tracking = 0;
        flags.inside = 0;
        [self __setCurrentStateFlags:flags];
        [self __stateDidChange];
        [self setNeedsDisplay];
    }), RSSwizzleModeAlways, NULL);

    RSSwizzleInstanceMethod([NSControl class], @selector(mouseMoved:), RSSWReturnType(void), RSSWArguments(NSEvent *event), RSSWReplacement({
        RSSWCallOriginal(event);
        [self __stateWillChange];
        xui_stateFlags flags = [self __currentStateFlags];
        if([self __isPointInEffectiveArea:event.locationInWindow]){
            flags.tracking = 1;
            flags.inside = 1;
        }else{
            flags.tracking = 0;
            flags.inside = 0;
        }
        [self __setCurrentStateFlags:flags];
        [self __stateDidChange];

        [self setNeedsDisplay];
    }), RSSwizzleModeAlways, NULL);

    RSSwizzleInstanceMethod([NSControl class], @selector(hitTest:), RSSWReturnType(NSView *), RSSWArguments(NSPoint point), RSSWReplacement({
        NSView *view = nil;
        if ([self isUserInteractionEnabled]) {
            view = RSSWCallOriginal(point);
            if (nil != view && ![self __isPointInEffectiveArea:point]){
                view = nil;
            }
        }
        return view;
    }), RSSwizzleModeAlways, NULL);

    RSSwizzleInstanceMethod([NSControl class], @selector(setEnabled:), RSSWReturnType(void), RSSWArguments(BOOL enabled), RSSWReplacement({
        if (enabled != [self isEnabled]) {
            [self __stateWillChange];
            RSSWCallOriginal(enabled);
            [self __stateDidChange];
        }else{
            RSSWCallOriginal(enabled);
        }
    }), RSSwizzleModeAlways, NULL);

    Class cls = [NSControl class];
    XUISwizzleMethod(cls, '-', @selector(xui_becomeFirstResponder),@selector(becomeFirstResponder));
}

- (BOOL)acceptsFirstMouse{
    return ![(NSNumber *)XUI_GET_PROPERTY(kAcceptsFirstMouse) boolValue];
}

- (void)setAcceptsFirstMouse:(BOOL)acceptsFirstMouse{
    XUI_SET_PROPERTY([NSNumber numberWithBool:!acceptsFirstMouse], kAcceptsFirstMouse);
}

-(NSBezierPath *)effectiveAreaPath{
    return XUI_GET_PROPERTY(kEffictiveAreaPath);
}

-(void)setEffectiveAreaPath:(NSBezierPath *)effectiveAreaPath{
    XUI_SET_PROPERTY(effectiveAreaPath, kEffictiveAreaPath);
}

-(void)setStateWillChangeBlock:(XUIControlStateActionBlock) block{
    XUI_SET_PROPERTY(block, kStateWillChangeBlock);
}

-(void)setStateDidChangeBlock:(XUIControlStateActionBlock) block{
    XUI_SET_PROPERTY(block, kStateDidChangeBlock);
}

- (XUIControlState)controlState{
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

#pragma mark - Override Functions

-(void)__firstResponderChanged:(NSResponder *)oldFirstResponder withNewResponder:(NSResponder *)newFirstResponder{
    if(oldFirstResponder == self || newFirstResponder == self){
        [self __stateDidChange];
    }
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

-(BOOL)__isPointInEffectiveArea:(NSPoint)point{
    BOOL bRtn = YES;
    //transform effectiveAreaPath to control's frame
    NSBezierPath *path = [[self effectiveAreaPath] copy];
    if (nil != path) {
        NSAffineTransform *transform = [NSAffineTransform transform];
        [transform translateXBy: self.frame.origin.x yBy: self.frame.origin.y];
        [path transformUsingAffineTransform:transform];
        bRtn = [path containsPoint:point];
    }
    return bRtn;
}

-(XUIControlStateActionBlock)__stateDidChangeBlock{
    return XUI_GET_PROPERTY(kStateDidChangeBlock);
}

-(XUIControlStateActionBlock)__stateWillChangeBlock{
    return XUI_GET_PROPERTY(kStateWillChangeBlock);
}

#pragma mark - Swizzle Functions

-(BOOL)xui_becomeFirstResponder{
    BOOL bRtn = [self xui_becomeFirstResponder];
    [super becomeFirstResponder];
    return bRtn;
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

@implementation NSControl (Private)

- (void)__stateWillChange{
    XUIControlStateActionBlock block = [self __stateWillChangeBlock];
    if(nil != block){
        block(self, [self controlState]);
    }
}

- (void)__stateDidChange{
    XUIControlStateActionBlock block = [self __stateDidChangeBlock];
    if(nil != block){
        block(self, [self controlState]);
    }
}

@end

