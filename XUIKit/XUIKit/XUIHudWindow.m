//
//  XUIHudWindow.m
//  XUIKit
//
//  Created by Jovi on 7/31/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIHudWindow.h"

#define XUI_HUD_WINDOW_STYLE_MASK               0x2011

@implementation XUIHudWindow

#pragma mark - Override Methods

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeXUIWindow:NSZeroRect];
    }
    return self;
}

-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag{
    if (style & NSWindowStyleMaskClosable) {
        style = XUI_HUD_WINDOW_STYLE_MASK | NSWindowStyleMaskClosable;
    }else{
        style = XUI_HUD_WINDOW_STYLE_MASK;
    }
    if (self = [super initWithContentRect:contentRect styleMask:style backing:bufferingType defer:flag]) {
        [self __initializeXUIWindow:contentRect];
    }
    return self;
}

-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen{
    if (style & NSWindowStyleMaskClosable) {
        style = XUI_HUD_WINDOW_STYLE_MASK | NSWindowStyleMaskClosable;
    }else{
        style = XUI_HUD_WINDOW_STYLE_MASK;
    }
    if (self = [super initWithContentRect:contentRect styleMask:style backing:bufferingType defer:flag screen:screen]) {
        [self __initializeXUIWindow:contentRect];
    }
    return self;
}

-(BOOL)canBecomeKeyWindow{
    return YES;
}

-(BOOL)canBecomeMainWindow {
    return YES;
}

#pragma mark - Private Methods

-(void)__initializeXUIWindow:(NSRect)contentRect{
    [self setTitle:@""];
    NSArray *arraySubviews = self.contentView.superview.subviews;
    if (!(self.styleMask & NSWindowStyleMaskClosable)) {
        for(NSView *view in arraySubviews){
            if([[view className] isEqualToString:@"NSTitlebarContainerView"]){
                [view setHidden:YES];
                break;
            }
        }
        [self setFrame:contentRect display:YES];
        [self.contentView setFrameSize:contentRect.size];
    }
}

@end
