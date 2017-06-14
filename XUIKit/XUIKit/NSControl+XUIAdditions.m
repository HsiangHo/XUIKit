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
#import "NSControl+Private.h"

#define kAcceptsFirstMouse          @"acceptsFirstMouse"

@implementation NSControl (XUIAdditions)

- (BOOL)acceptsFirstMouse
{
    return [(NSNumber *)XUI_GET_PROPERTY(kAcceptsFirstMouse) boolValue];
}

- (void)setAcceptsFirstMouse:(BOOL)acceptsFirstMouse
{
    XUI_SET_PROPERTY([NSNumber numberWithBool:acceptsFirstMouse], kAcceptsFirstMouse);
}

- (XUIControlState)state
{
    XUIControlState actual = XUIControlStateNormal;
    return actual;
}

#pragma mark - Override

- (BOOL)acceptsFirstMouse:(NSEvent *)event{
    return [self acceptsFirstMouse];
}

- (void)mouseDown:(NSEvent *)event{
    [super mouseDown:event];
    
    [self __stateWillChange];
    
    [self __stateDidChange];
    
    if([event clickCount] < 2) {
        [self sendActionsForControlEvents:XUIControlEventTouchDown];
    } else {
        [self sendActionsForControlEvents:XUIControlEventTouchDownRepeat];
    }
    
    [self setNeedsDisplay];
}

- (void)mouseUp:(NSEvent *)event{
    [super mouseUp:event];
    
    [self __stateWillChange];
    
    [self __stateDidChange];
    
    if([self eventInside:event]) {
            [self sendActionsForControlEvents:XUIControlEventTouchUpInside];
    } else {
        [self sendActionsForControlEvents:XUIControlEventTouchUpOutside];
    }
    
    [self setNeedsDisplay];
}

@end
