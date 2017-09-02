//
//  XUIView.m
//  XUIKit
//
//  Created by Jovi on 6/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIView.h"
#import <Quartz/Quartz.h>

@implementation XUIView{
    XUIViewDrawRect         _drawRectBlock;
    XUIHyperFocusCompletion _hyperfocusBlock;
    
    XUIView                 *_hyperFocusView;
    XUIView                 *_hyperFadeView;
}

- (void)setDrawRectBlock:(XUIViewDrawRect)drawRectBlock{
    _drawRectBlock = drawRectBlock;
}

- (XUIViewDrawRect)drawRectBlock{
    return [_drawRectBlock copy];
}

- (void)hyperFocus:(XUIView *)focusView completion:(XUIHyperFocusCompletion)completion{
    if(nil != _hyperFadeView){
        if (nil != _hyperfocusBlock) {
            _hyperfocusBlock(YES);
        }
        _hyperfocusBlock = nil;
        [_hyperFadeView removeFromSuperview];
        _hyperFadeView = nil;
        _hyperFocusView = nil;
    }
    
    CGRect focusRect = [focusView frame];
    CGFloat startRadius = 1.0;
    CGFloat endRadius = MAX(self.bounds.size.width, self.bounds.size.height);
    CGPoint center = CGPointMake(focusRect.origin.x + focusRect.size.width * 0.5, focusRect.origin.y + focusRect.size.height * 0.5);
    
    XUIView *fade = [[XUIView alloc] initWithFrame:self.bounds];
    fade.userInteractionEnabled = NO;
    fade.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    fade.drawRectBlock = ^(XUIView *view, NSRect dirtyRect){
        CGContextRef ctx = (CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];;
        
        CGFloat locations[] = {0.0, 0.25, 1.0};
        CGFloat components[] = {
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.15,
            0.0, 0.0, 0.0, 0.55,
        };
        
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, 3);
        
        CGContextDrawRadialGradient(ctx, gradient, center, startRadius, center, endRadius, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(space);
    };
    
    fade.alpha = 0.0;
    [self addSubview:fade];
    
    [CATransaction begin];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setFromValue:[NSNumber numberWithFloat:0.0]];
    [animation setToValue:[NSNumber numberWithFloat:1.0]];
    [animation setDuration:0.2];
    [fade.layer addAnimation:animation forKey:@"alphaA"];
    [CATransaction flush];
    [CATransaction commit];
    
    fade.alpha = 1.0;
    _hyperFocusView = focusView;
    _hyperFadeView = fade;
    _hyperfocusBlock = [completion copy];
}

- (void)endHyperFocus:(BOOL)cancel{
    if(nil != _hyperFocusView) {
        if(nil != _hyperfocusBlock){
            _hyperfocusBlock(cancel);
        }
        _hyperfocusBlock = nil;
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [_hyperFadeView removeFromSuperview];
        }];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [animation setFromValue:[NSNumber numberWithFloat:1.0]];
        [animation setToValue:[NSNumber numberWithFloat:0.0]];
        [animation setDuration:0.3];
        [_hyperFadeView.layer addAnimation:animation forKey:@"alphaB"];
        _hyperFadeView.alpha = 0.0;
        [CATransaction commit];
        
        _hyperFadeView = nil;
        _hyperFocusView = nil;
    }
}

#pragma mark - Private Methods

-(void)__initializeXUIView{
    [self setWantsLayer:YES];
    _drawRectBlock = nil;
    _hyperfocusBlock = nil;
}

#pragma mark - Override Methods

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeXUIView];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self __initializeXUIView];
    }
    return self;
}

-(void)drawRect:(NSRect)dirtyRect{
    [super drawRect:dirtyRect];
    if (nil != _drawRectBlock) {
        _drawRectBlock(self,dirtyRect);
    }
}

@end


