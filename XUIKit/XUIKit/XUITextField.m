//
//  XUITextField.m
//  XUIKit
//
//  Created by Jovi on 6/18/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUITextField.h"

@implementation XUITextField{
    NSImage                                 *_background;
    NSImage                                 *_disabledBackground;
    NSView                                  *_leftView;
    NSView                                  *_rightView;
    struct{
        unsigned int clearButtonMode:8;
        unsigned int leftViewMode:8;
        unsigned int rightViewMode:8;
    }_textfieldFlags
}

#pragma mark - Override Methods

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

//Respond to shortcut key
- (BOOL)performKeyEquivalent:(NSEvent *)event {
    if (NSCommandKeyMask == ([event modifierFlags] & NSDeviceIndependentModifierFlagsMask)) {
        // The command key is the ONLY modifier key being pressed.
        if ([[event charactersIgnoringModifiers] isEqualToString:@"x"]) {
            return [NSApp sendAction:@selector(cut:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"c"]) {
            return [NSApp sendAction:@selector(copy:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"v"]) {
            return [NSApp sendAction:@selector(paste:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"a"]) {
            return [NSApp sendAction:@selector(selectAll:) to:[[self window] firstResponder] from:self];
        }
    }
    return [super performKeyEquivalent:event];
}

#pragma mark - Private Methods

- (void)__initializeXUITextField{
    _background = nil;
    _disabledBackground = nil;
    _leftView = nil;
    _rightView = nil;
    _textfieldFlags.clearButtonMode = XUITextFieldViewModeNever;
    _textfieldFlags.leftViewMode = XUITextFieldViewModeNever;
    _textfieldFlags.rightViewMode = XUITextFieldViewModeNever;
}

@end
