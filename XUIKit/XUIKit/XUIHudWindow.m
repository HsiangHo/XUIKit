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
        [self __initializeXUIWindow];
    }
    return self;
}

-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag{
    style = XUI_HUD_WINDOW_STYLE_MASK;
    if (self = [super initWithContentRect:contentRect styleMask:style backing:bufferingType defer:flag]) {
        [self __initializeXUIWindow];
    }
    return self;
}

-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen{
    style = XUI_HUD_WINDOW_STYLE_MASK;
    if (self = [super initWithContentRect:contentRect styleMask:style backing:bufferingType defer:flag screen:screen]) {
        [self __initializeXUIWindow];
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

-(void)__initializeXUIWindow{
    [self setTitle:@""];
    NSArray *arraySubviews = self.contentView.superview.subviews;
    for(NSView *view in arraySubviews){
        if([[view className] isEqualToString:@"NSTitlebarContainerView"]){
            [view setHidden:YES];
            break;
        }
    }
    [self.contentView setFrame: self.contentView.superview.bounds];
}

@end
