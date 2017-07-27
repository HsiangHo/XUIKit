//
//  XUIWindowSystemButtonView.m
//  XUIKit
//
//  Created by Jovi on 7/27/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIWindowSystemButtonView.h"

@implementation XUIWindowSystemButtonView{
    BOOL                _mouseInside;
    
    __weak NSButton     *_closeButton;
    __weak NSButton     *_maxButton;
    __weak NSButton     *_minButton;
    
    NSPoint             _pointOfCloseButton;
    NSPoint             _pointOfMaxButton;
    NSPoint             _pointOfMinButton;
}

#pragma mark - Override methods

-(instancetype)init{
    if(self = [super init]){
        [self __initializeXUIWindowSystemButtonView];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    if(self = [super initWithFrame:frameRect]){
        [self __initializeXUIWindowSystemButtonView];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationWillBecomeActiveNotification object:NSApp];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidResignActiveNotification object:NSApp];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeMainNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidMiniaturizeNotification object:nil];
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    NSTrackingArea *const trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingActiveWhenFirstResponder) owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

//Undocument API
- (BOOL)_mouseInGroup:(NSButton *)button {
    return _mouseInside;
}

- (void)mouseEntered:(NSEvent *)event {
    [super mouseEntered:event];
    _mouseInside = YES;
    [self __updateStandardWindowButtons];
}

- (void)mouseExited:(NSEvent *)event {
    [super mouseExited:event];
    _mouseInside = NO;
    [self __updateStandardWindowButtons];
}

#pragma mark - Public methods

-(void)setPointOfCloseButton:(NSPoint)pointOfCloseButton{
    _pointOfCloseButton = pointOfCloseButton;
    [self __updateStandardWindowButtons];
}

-(void)setPointOfMaxButton:(NSPoint)pointOfMaxButton{
    _pointOfMaxButton = pointOfMaxButton;
    [self __updateStandardWindowButtons];
}

-(void)setPointOfMinButton:(NSPoint)pointOfMinButton{
    _pointOfMinButton = pointOfMinButton;
    [self __updateStandardWindowButtons];
}

#pragma mark - Notifications

- (void)applicationWillBecomeActive:(NSNotification *)notification {
    _mouseInside = NO;
    [self __updateStandardWindowButtons];
}

- (void)applicationDidResignActive:(NSNotification *)notification {
    _mouseInside = NO;
    [self __updateStandardWindowButtons];
}

- (void)windowActiveChanged:(NSNotification *)notification {
    
    _mouseInside = NO;
    [self __updateStandardWindowButtons];
}

- (void)windowDidMiniaturize:(NSNotification *)notification
{
    _mouseInside = NO;
    [self __updateStandardWindowButtons];
}

#pragma mark - Private methods

-(void)__initializeXUIWindowSystemButtonView{
    _closeButton = [NSWindow standardWindowButton:NSWindowCloseButton forStyleMask:self.window.styleMask];
    _minButton = [NSWindow standardWindowButton:NSWindowMiniaturizeButton forStyleMask:self.window.styleMask];
    _maxButton = [NSWindow standardWindowButton:NSWindowZoomButton forStyleMask:self.window.styleMask];
    [self addSubview:_closeButton];
    [self addSubview:_minButton];
    [self addSubview:_maxButton];
    
    _pointOfCloseButton = NSMakePoint(0,1);
    _pointOfMaxButton = NSMakePoint(20,1);
    _pointOfMinButton = NSMakePoint(40,1);
    
    [self __updateStandardWindowButtons];
    
    [self updateTrackingAreas];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(applicationWillBecomeActive:)
                          name:NSApplicationWillBecomeActiveNotification object:NSApp];
    [defaultCenter addObserver:self selector:@selector(applicationDidResignActive:)
                          name:NSApplicationDidResignActiveNotification object:NSApp];
    [defaultCenter addObserver:self selector:@selector(windowActiveChanged:)
                          name:NSWindowDidBecomeMainNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(windowDidMiniaturize:)
                          name:NSWindowDidMiniaturizeNotification object:nil];
}

- (void)__updateStandardWindowButtons {
    [_closeButton setNeedsDisplay];
    [_minButton setNeedsDisplay];
    [_maxButton setNeedsDisplay];
    
    [_closeButton setFrameOrigin:_pointOfCloseButton];
    [_minButton setFrameOrigin:_pointOfMaxButton];
    [_maxButton setFrameOrigin:_pointOfMinButton];
}

@end
