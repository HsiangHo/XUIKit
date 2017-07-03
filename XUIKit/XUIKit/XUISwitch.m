//
//  XUISwitch.m
//  XUIKit
//
//  Created by Jovi on 7/2/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUISwitch.h"
#import "NSColor+XUIAdditions.h"
#import <Quartz/Quartz.h>

@implementation XUISwitch{
    CALayer             *_backgroundLayer;
    CALayer             *_knobLayer;
    NSColor             *_onTintColor;
    NSColor             *_tintColor;
    NSColor             *_onBorderColor;
    NSColor             *_borderColor;
    NSColor             *_thumbTintColor;
    NSTrackingArea      *_trackingArea;
    id                  _target;
    SEL                 _action;
    
    struct{
        unsigned int isLeft:1;
        unsigned int isDragging:1;
        unsigned int isStatusChanged:1;
    }_switchFlags;
}

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeXUISwitch];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self __initializeXUISwitch];
    }
    return self;
}

#pragma mark - Private Methods

- (void)__initializeXUISwitch{
    _switchFlags.isLeft = YES;
    _switchFlags.isDragging = NO;
    _onTintColor = [NSColor colorWithHex:@"#00e459" alpha:1.0];
    _tintColor = [NSColor colorWithHex:@"#ffffff" alpha:1.0];
    _onBorderColor = _onTintColor;
    _borderColor = [NSColor colorWithHex:@"#cdcdcd" alpha:1.0];
    _thumbTintColor = [NSColor colorWithHex:@"#ffffff" alpha:1.0];
    
    [self updateTrackingAreas];
    [self setWantsLayer:YES];
    [self.layer setCornerRadius:(int)(NSHeight(self.frame)/2.0f)];
    
    _backgroundLayer = [CALayer layer];
    _backgroundLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    _backgroundLayer.bounds = self.layer.bounds;
    _backgroundLayer.backgroundColor = _tintColor.CGColor;
    _backgroundLayer.borderColor = _borderColor.CGColor;
    _backgroundLayer.borderWidth = 2.f;
    _backgroundLayer.anchorPoint = (CGPoint){ .x = 0.f, .y = 0.f };
    [_backgroundLayer setCornerRadius:_backgroundLayer.bounds.size.height / 2.f];
    [self.layer addSublayer:_backgroundLayer];
    
    _knobLayer = [CALayer layer];
    _knobLayer.backgroundColor = _thumbTintColor.CGColor;
    _knobLayer.borderColor = [_tintColor darkenColorByValue:0.1f].CGColor;
    _knobLayer.borderWidth = 1.f;
    _knobLayer.shadowColor = [NSColor blackColor].CGColor;
    _knobLayer.shadowOffset = (CGSize){ .width = 0.f, .height = -3.f };
    _knobLayer.shadowRadius = 3.f;
    _knobLayer.shadowOpacity = 0.3f;
    _knobLayer.frame = [self __rectForKnobLeft];
    [_knobLayer setCornerRadius:_knobLayer.bounds.size.height / 2.f];
    [self.layer addSublayer:_knobLayer];
}

- (void)__updateSwitch{
    BOOL isEnabled = [self isEnabled];
    if (_switchFlags.isLeft) {
        _backgroundLayer.backgroundColor = isEnabled ? _tintColor.CGColor : [_tintColor darkenColorByValue:0.05f].CGColor;
        _backgroundLayer.borderColor = isEnabled ? _borderColor.CGColor : [_borderColor lightenColorByValue:0.4f].CGColor;
        _knobLayer.borderColor = [_tintColor darkenColorByValue:0.1f].CGColor;
        _knobLayer.frame = [self __rectForKnobLeft];
    }else{
        _backgroundLayer.backgroundColor = isEnabled ? _onTintColor.CGColor : [_onTintColor lightenColorByValue:0.4f].CGColor;
        _backgroundLayer.borderColor = isEnabled ? _onBorderColor.CGColor : [_onBorderColor lightenColorByValue:0.4f].CGColor;
        _knobLayer.borderColor = [_onTintColor darkenColorByValue:0.1f].CGColor;
        _knobLayer.frame = [self __rectForKnobRight];
    }
    _knobLayer.backgroundColor = _thumbTintColor.CGColor;
}

- (CGRect)__rectForKnobLeft {
    CGFloat height = _backgroundLayer.bounds.size.height - _backgroundLayer.borderWidth * 2.f + _knobLayer.borderWidth * 2.f;
    CGFloat width = height;
    return (CGRect) {
        .size.width = width,
        .size.height = height,
        .origin.x = _backgroundLayer.borderWidth - _knobLayer.borderWidth,
        .origin.y = _backgroundLayer.borderWidth - _knobLayer.borderWidth,
    };
}

- (CGRect)__rectForKnobRight {
    CGFloat height = _backgroundLayer.bounds.size.height - _backgroundLayer.borderWidth * 2.f + _knobLayer.borderWidth * 2.f;
    CGFloat width = height;
    return (CGRect) {
        .size.width = width,
        .size.height = height,
        .origin.x = _backgroundLayer.bounds.size.width - width - (_backgroundLayer.borderWidth - _knobLayer.borderWidth),
        .origin.y = _backgroundLayer.borderWidth - _knobLayer.borderWidth,
    };
}

- (BOOL)__pointIsLeft:(NSPoint) point{
    return (point.x < NSWidth(self.bounds)/4.f);
}

-(void)__moveleft{
    _switchFlags.isLeft = YES;
    [self __updateSwitch];
    [self sendAction:_action to:_target];
}

-(void)__moveright{
    _switchFlags.isLeft = NO;
    [self __updateSwitch];
    [self sendAction:_action to:_target];
}

#pragma mark - Override Methods

-(void)updateTrackingAreas
{
    if(_trackingArea != nil) {
        [self removeTrackingArea:_trackingArea];
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingMouseMoved | NSTrackingActiveWhenFirstResponder);
    _trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                  options:opts
                                                    owner:self
                                                 userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

-(void)mouseDown:(NSEvent *)theEvent{
}

-(void)mouseUp:(NSEvent *)theEvent{
    [super mouseUp:theEvent];
    if (![self isEnabled]) {
        return;
    }
    if (_switchFlags.isDragging) {
        _switchFlags.isDragging = NO;
        if(_switchFlags.isStatusChanged){
            _switchFlags.isStatusChanged = NO;
            return;
        }
    }
    
    if (_switchFlags.isLeft) {
        [self __moveright];
    }else{
        [self __moveleft];
    }
}

-(void)mouseDragged:(NSEvent *)theEvent{
    [super mouseDragged:theEvent];
    if (![self isEnabled]) {
        return;
    }
    NSPoint draggingPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    if(draggingPoint.x > NSWidth(self.bounds)/4.f * 3 && _switchFlags.isLeft){
        [self __moveright];
        _switchFlags.isStatusChanged = YES;
    }else if(draggingPoint.x < NSWidth(self.bounds)/4.f && !_switchFlags.isLeft){
        [self __moveleft];
        _switchFlags.isStatusChanged = YES;
    }
    _switchFlags.isDragging = YES;
}

-(void)mouseEntered:(NSEvent *)theEvent{
    if ([self isEnabled]) {
        [[NSCursor pointingHandCursor] set];
    }
}

-(void)mouseExited:(NSEvent *)theEvent{
    if ([self isEnabled]) {
        [[NSCursor arrowCursor] set];
    }
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self __updateSwitch];
}

-(void)setTarget:(id)target{
    _target = target;
}

-(id)target{
    return _target;
}

-(void)setAction:(SEL)action{
    _action = action;
}

-(SEL)action{
    return _action;
}

#pragma mark - Public Methods

-(void)setOnTintColor:(NSColor *)onTintColor{
    _onTintColor = onTintColor;
    [self __updateSwitch];
}

-(void)setTintColor:(NSColor *)tintColor{
    _tintColor = tintColor;
    [self __updateSwitch];
}

-(void)setBorderColor:(NSColor *)borderColor{
    _borderColor = borderColor;
    [self __updateSwitch];
}

-(void)setOnBorderColor:(NSColor *)onBorderColor{
    _onBorderColor = onBorderColor;
    [self __updateSwitch];
}

-(void)setThumbTintColor:(NSColor *)thumbTintColor{
    _thumbTintColor = thumbTintColor;
    [self __updateSwitch];
}

-(void)setOn:(BOOL)on animated:(BOOL)animated{
    _switchFlags.isLeft = !on;
    if (animated) {
        [self __updateSwitch];
    }else{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self __updateSwitch];
        [CATransaction commit];
    }
}

-(void)setOn:(BOOL)on{
    _switchFlags.isLeft = !on;
    [self __updateSwitch];
}

-(BOOL)isOn{
    return !_switchFlags.isLeft;
}

@end
