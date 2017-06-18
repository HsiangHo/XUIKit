//
//  NSTextField+XUIAdditions.m
//  XUIKit
//
//  Created by Jovi on 6/18/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "NSTextField+XUIAdditions.h"

@implementation NSTextField (XUIAdditions)

-(void)setLineBreakMode:(NSLineBreakMode)lineBreakMode{
    [[self cell] setLineBreakMode:lineBreakMode];
}

-(NSLineBreakMode)lineBreakMode{
    return [[self cell] lineBreakMode];
}

-(void)setText:(NSString *)text{
    [self setStringValue:text];
}

-(NSString *)text{
    return [self text];
}

-(void)setAttributedText:(NSAttributedString *)attributedText{
    [self setAttributedText:attributedText];
}

-(NSAttributedString *)attributedText{
    return self.attributedText;
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

@end
