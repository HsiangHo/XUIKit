//
//  XUITextField.m
//  XUIKit
//
//  Created by Jovi on 6/18/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUITextField.h"
#import "XUITextField+Private.h"
#import "XUIButton.h"
#import "XUITextFieldCell.h"
#import "NSImage+XUIAdditions.h"

#pragma mark - OnlyIntegerValueFormatter

@interface OnlyIntegerValueFormatter : NSNumberFormatter

@end

@implementation OnlyIntegerValueFormatter

- (BOOL)isPartialStringValid:(NSString*)partialString newEditingString:(NSString**)newString errorDescription:(NSString**)error
{
    if([partialString length] == 0) {
        return YES;
    }
    NSScanner* scanner = [NSScanner scannerWithString:partialString];
    if(!([scanner scanInt:0] && [scanner isAtEnd])) {
        NSBeep();
        return NO;
    }
    return YES;
}

@end

#pragma mark - XUITextField

@implementation XUITextField{
    NSImage                                 *_background;
    NSImage                                 *_disabledBackground;
    NSView                                  *_leftView;
    NSView                                  *_rightView;
    NSRect                                  _originalRectLeftView;
    NSRect                                  _originalRectRightView;
    XUIButton                               *_clearButton;
    struct{
        unsigned int clearButtonMode:8;
        unsigned int leftViewMode:8;
        unsigned int rightViewMode:8;
    }_textfieldFlags;
}

#pragma mark - Public Methods

-(XUIButton *)clearButton{
    return _clearButton;
}

- (void)setLeftView:(NSView *)leftView{
    if(nil != _leftView){
        [_leftView removeFromSuperview];
    }
    if(nil != leftView){
        [self addSubview:leftView];
    }
    _originalRectLeftView = [leftView frame];
    _leftView = leftView;
    [self setNeedsDisplay:YES];
}

- (NSView *)leftView{
    return _leftView;
}

- (void)setRightView:(NSView *)rightView{
    if(nil != _rightView){
        [_rightView removeFromSuperview];
    }
    if(nil != rightView){
        [self addSubview:rightView];
    }
    _originalRectRightView = [rightView frame];
    _rightView = rightView;
    [self setNeedsDisplay:YES];
}

- (NSView *)rightView{
    return _rightView;
}

- (void)setLeftViewMode:(XUITextFieldViewMode)leftViewMode{
    _textfieldFlags.leftViewMode = leftViewMode;
    [self setNeedsDisplay:YES];
}

- (XUITextFieldViewMode)leftViewMode{
    return _textfieldFlags.leftViewMode;
}

- (void)setRightViewMode:(XUITextFieldViewMode)rightViewMode{
    _textfieldFlags.rightViewMode = rightViewMode;
    [self setNeedsDisplay:YES];
}

- (XUITextFieldViewMode)rightViewMode{
    return _textfieldFlags.rightViewMode;
}

- (void)setClearButtonMode:(XUITextFieldViewMode)clearButtonMode{
    _textfieldFlags.clearButtonMode = clearButtonMode;
    [self setNeedsDisplay:YES];
}

- (XUITextFieldViewMode)clearButtonMode{
    return _textfieldFlags.clearButtonMode;
}

- (void)setBackground:(NSImage *)background{
    _background = background;
    [self setDrawsBackground:NO];
    [self setNeedsDisplay:YES];
}

- (NSImage *)background{
    return _background;
}

- (void)setDisabledBackground:(NSImage *)disabledBackground{
    _disabledBackground = disabledBackground;
    [self setDrawsBackground:NO];
    [self setNeedsDisplay:YES];
}

- (NSImage *)disabledBackground{
    return _disabledBackground;
}

-(BOOL)isEditing{
    return [[self cell] isEditing];
}

-(NSEdgeInsets)textEdgeInsets{
    return NSEdgeInsetsMake(0, NSMaxX([self __rectLeftView]), 0, NSWidth([self __rectClearButton]) + NSWidth([self __rectRightView]));
}

-(void)setOnlyIntegerValue:(BOOL)onlyIntegerValue{
    if (onlyIntegerValue) {
        [self setFormatter:[[OnlyIntegerValueFormatter alloc] init]];
    }else{
        [self setFormatter:nil];
    }
}

-(BOOL)isOnlyIntegerValue{
    NSFormatter *fm = [self formatter];
    return [fm isKindOfClass:[OnlyIntegerValueFormatter class]];
}

#pragma mark - Override Methods

+ (Class)cellClass{
    return [XUITextFieldCell class];
}

- (instancetype)init{
    if(self = [super init]){
        [self __initializeXUITextField];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self __initializeXUITextField];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [self __updateLookup];
}

- (void)setBackgroundColor:(NSColor *)backgroundColor{
    [self setDrawsBackground:YES];
    [super setBackgroundColor:backgroundColor];
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
    [self setDrawsBackground:NO];
    _textfieldFlags.clearButtonMode = XUITextFieldViewModeNever;
    _textfieldFlags.leftViewMode = XUITextFieldViewModeNever;
    _textfieldFlags.rightViewMode = XUITextFieldViewModeNever;
    _clearButton = [[XUIButton alloc] initWithFrame:NSZeroRect];
    [_clearButton setBackgroundImage:[NSImage XUI_clearButtonImageNormal] forState:XUIControlStateNormal];
    [_clearButton setBackgroundImage:[NSImage XUI_clearButtonImageDown] forState:XUIControlStateDown];
    [_clearButton setAction:@selector(clearText_click:)];
    [_clearButton setTarget:self];
    [self addSubview:_clearButton];
}

#pragma mark - Actions
- (IBAction)clearText_click:(id)sender{
    [self setStringValue:@""];
}

@end

@implementation XUITextField (Private)

-(NSRect)__rectLeftView{
    NSRect rectLeftView = NSZeroRect;
    if(nil != _leftView){
        rectLeftView = [_leftView frame];
        rectLeftView.origin = NSMakePoint(1, 1);
        rectLeftView.size.height = NSHeight(self.frame) - 2;
        rectLeftView.size.width = _originalRectLeftView.size.width;
    }
    
    if(XUITextFieldViewModeNever == _textfieldFlags.leftViewMode){
        rectLeftView = NSZeroRect;
    }else if(XUITextFieldViewModeWhileEditing == _textfieldFlags.leftViewMode){
        rectLeftView = [self.cell isEditing] ? rectLeftView : NSZeroRect;
    }else if(XUITextFieldViewModeUnlessEditing == _textfieldFlags.leftViewMode){
        rectLeftView = ![self.cell isEditing] ? rectLeftView : NSZeroRect;
    }else{
    }
    return rectLeftView;
}

-(NSRect)__rectRightView{
    NSRect rectRightView = NSZeroRect;
    if (nil != _rightView) {
        rectRightView = [_rightView frame];
        rectRightView.origin = NSMakePoint(NSWidth(self.frame) - NSWidth(rectRightView) - 1, 1);
        rectRightView.size.height = NSHeight(self.frame) - 2;
        rectRightView.size.width = _originalRectRightView.size.width;
    }
    
    if(XUITextFieldViewModeNever == _textfieldFlags.rightViewMode){
        rectRightView = NSZeroRect;
    }else if(XUITextFieldViewModeWhileEditing == _textfieldFlags.rightViewMode){
        rectRightView = [self.cell isEditing] ? rectRightView : NSZeroRect;
    }else if(XUITextFieldViewModeUnlessEditing == _textfieldFlags.rightViewMode){
        rectRightView = ![self.cell isEditing] ? rectRightView : NSZeroRect;
    }else{
    }
    return rectRightView;
}

-(NSRect)__rectClearButton{
    NSRect rectClearButton = NSZeroRect;
    NSRect rectRightView = [self __rectRightView];
    rectClearButton = [_clearButton frame];
    rectClearButton.size = NSMakeSize(16, 16);
    rectClearButton.origin = NSMakePoint(NSWidth(self.frame) - NSWidth(rectRightView) - NSWidth(rectClearButton) - 2,(int)((NSHeight(self.frame) - NSHeight(rectClearButton))/2));
    
    if(XUITextFieldViewModeNever == _textfieldFlags.clearButtonMode){
        rectClearButton = NSZeroRect;
    }else if(XUITextFieldViewModeWhileEditing == _textfieldFlags.clearButtonMode){
        rectClearButton = [self.cell isEditing] ? rectClearButton : NSZeroRect;
    }else if(XUITextFieldViewModeUnlessEditing == _textfieldFlags.clearButtonMode){
        rectClearButton = ![self.cell isEditing] ? rectClearButton : NSZeroRect;
    }else{
    }
    return rectClearButton;
}

- (void)__updateLookup{
    //Draw background
    if(self.enabled){
        if(nil != _background){
            [_background drawInRect:self.bounds fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
    }else{
        if(nil != _disabledBackground){
            [_disabledBackground drawInRect:self.bounds fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
    }
    [_leftView setFrame:[self __rectLeftView]];
    [_rightView setFrame:[self __rectRightView]];
    [_clearButton setFrame:[self __rectClearButton]];
}

@end

