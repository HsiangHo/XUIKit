//
//  XUIWindow.m
//  XUIKit
//
//  Created by Jovi on 7/23/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIWindow.h"
#import "XUIView.h"
#import "XUIWindowSystemButtonView.h"
#import "XUILabel.h"
#import "NSColor+XUIAdditions.h"

@implementation XUIWindow{
    XUIWindowSystemButtonView           *_systemButtonView;
    XUIView                             *_headerView;
    XUIView                             *_mainView;
    XUILabel                            *_windowTitle;
    NSRect                              _titleFrame;
    NSSize                              _minimumSize;
    NSSize                              _maximumSize;

    __weak NSView                       *_titlebarContainerView;
}

#pragma mark - Override Methods

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeXUIWindow];
    }
    return self;
}

-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag{
    if (self = [super initWithContentRect:contentRect styleMask:style backing:bufferingType defer:flag]) {
        [self __initializeXUIWindow];
    }
    return self;
}

-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen{
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResizeNotification object:nil];
}

-(void)windowDidResize:(NSNotification *)notification{
    [self __adjustContentViewLayout];
}

-(void)setTitle:(NSString *)title{
//    [super setTitle:title];
    [_windowTitle setText:title];
    [self __adjustContentViewLayout];
}

-(NSString *)title{
    return [_windowTitle text];
}

-(NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize{
    NSSize size = frameSize;
    if (frameSize.height < _minimumSize.height) {
        size.height = _minimumSize.height;
    }else if(frameSize.height > _maximumSize.height) {
        size.height = _maximumSize.height;
    }
    
    if (frameSize.width < _minimumSize.width){
        size.width = _minimumSize.width;
    }else if(frameSize.width > _maximumSize.width) {
        size.width = _maximumSize.width;
    }
    return size;
}

#pragma mark - Private Methods

-(void)__initializeXUIWindow{
    NSArray *arraySubviews = self.contentView.superview.subviews;
    for(NSView *view in arraySubviews){
        if([[view className] isEqualToString:@"NSTitlebarContainerView"]){
            [view setHidden:YES];
            _titlebarContainerView = view;
            break;
        }else if([[view className] isEqualToString:@"_NSThemeCloseWidget"] ||
                 [[view className] isEqualToString:@"_NSThemeZoomWidget"] ||
                 [[view className] isEqualToString:@"_NSThemeWidget"]){
            [view setHidden:YES];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:nil];
    _headerView = [[XUIView alloc] initWithFrame:NSMakeRect(0, 0, 0, 40)];
    _mainView = [[XUIView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
    _systemButtonView = [[XUIWindowSystemButtonView alloc] initWithFrame:NSMakeRect(10, 10, 63, 18)];
    _titleFrame = NSMakeRect(0, 10, 0, 0);
    _windowTitle = [[XUILabel alloc] initWithFrame:_titleFrame];
    [_windowTitle setText:@"Window"];
    [_windowTitle setFont:[NSFont fontWithName:@"Helvetica Neue" size:15]];
    [_windowTitle setAlignment:NSCenterTextAlignment];
    [_windowTitle setTextColor:[NSColor colorWithHex:@"#34324a" alpha:1.0]];
    [_headerView addSubview:_systemButtonView];
    [_headerView addSubview:_windowTitle];
    [self.contentView addSubview:_headerView];
    [self.contentView addSubview:_mainView];
    _minimumSize = NSMakeSize(300, 200);
    _maximumSize = NSMakeSize(10000, 10000);
    [self __adjustContentViewLayout];
}

-(void)__adjustContentViewLayout{
    [self.contentView setFrame: self.contentView.superview.bounds];
    NSRect rctContent = self.contentView.bounds;
    NSRect rctHeaderView = _headerView.frame;
    NSRect rctMainView = _mainView.frame;
    
    rctHeaderView.size.width = NSWidth(rctContent);
    rctHeaderView.origin.x = 0;
    rctHeaderView.origin.y = NSHeight(rctContent) - NSHeight(rctHeaderView);
    [_headerView setFrame:rctHeaderView];
    
    _titleFrame.size.height = _windowTitle.heightOfText;
    _titleFrame.size.width = _windowTitle.widthOfText * 2;
    _titleFrame.origin.x = (int)((NSWidth(rctContent) - NSWidth(_titleFrame)) / 2);
    [_windowTitle setFrame:_titleFrame];
    
    rctMainView.size.height = (int)(NSHeight(rctContent) - NSHeight(rctHeaderView));
    rctMainView.size.width = NSWidth(rctContent);
    rctMainView.origin.x = 0;
    rctMainView.origin.y = 0;
    [_mainView setFrame:rctMainView];
}

#pragma mark - Public Methods

-(void)setTitleFont:(NSFont *)titleFont{
    _windowTitle.font = titleFont;
    [self __adjustContentViewLayout];
}

-(NSFont *)titleFont{
    return _windowTitle.font;
}

-(void)setTitleColor:(NSColor *)titleColor{
    _windowTitle.textColor = titleColor;
    [self __adjustContentViewLayout];
}

-(NSColor *)titleColor{
    return _windowTitle.textColor;
}

-(void)setResizable:(BOOL)resizable{
    NSInteger style = self.styleMask;
    style = resizable ? style|NSResizableWindowMask : style&~NSResizableWindowMask;
    [self setStyleMask:style];
    [[_systemButtonView maxButton] setEnabled:resizable];
}

-(BOOL)isResizable{
    return self.styleMask & NSResizableWindowMask;
}

-(void)setCloseable:(BOOL)closeable{
    NSInteger style = self.styleMask;
    style = closeable ? style|NSClosableWindowMask : style&~NSClosableWindowMask;
    [self setStyleMask:style];
    [[_systemButtonView closeButton] setEnabled:closeable];
}

-(BOOL)isCloseable{
    return self.styleMask & NSClosableWindowMask;
}

-(void)setMinimizable:(BOOL)minimizable{
    NSInteger style = self.styleMask;
    style = minimizable ? style|NSMiniaturizableWindowMask : style&~NSMiniaturizableWindowMask;
    [self setStyleMask:style];
    [[_systemButtonView minButton] setEnabled:minimizable];
}

-(BOOL)isMinimizable{
    return self.styleMask & NSMiniaturizableWindowMask;
}

@end
