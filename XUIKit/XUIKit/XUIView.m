//
//  XUIView.m
//  XUIKit
//
//  Created by Jovi on 6/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIView.h"
#import "NSColor+XUIAdditions.h"

@implementation XUIView{
    XUIViewDrawRect         _drawRect;
    NSColor                 *_backgroundColor;
    CGFloat                 _cornerRadius;
}

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

-(void)__initializeXUIView{
    _drawRect = nil;
    _backgroundColor = nil;
    _cornerRadius = 0;
    [self setWantsLayer:YES];
    [self.layer setBackgroundColor:_backgroundColor.CGColor];
}

- (void)insertSubview:(NSView *)view atIndex:(NSUInteger)index{
    NSArray *arraySubviews = [self subviews];
    NSUInteger nCount = [arraySubviews count];
    if (0 == nCount){
        [self addSubview:view];
    }else{
        index = (index >= nCount) ? nCount - 1 : index;
        NSView *relativeView = [arraySubviews objectAtIndex:index];
        [self addSubview:view positioned:NSWindowAbove relativeTo:relativeView];
        [self.layer insertSublayer:view.layer atIndex:(unsigned int)index + 1];
    }
}

- (void)insertSubview:(NSView *)view belowSubview:(NSView *)siblingSubview{
    NSUInteger siblingIndex = [self.subviews indexOfObject:siblingSubview];
    if (siblingIndex == NSNotFound)
        return;
    [self addSubview:view positioned:NSWindowBelow relativeTo:siblingSubview];
    [self.layer insertSublayer:view.layer below:siblingSubview.layer];
}

- (void)insertSubview:(NSView *)view aboveSubview:(NSView *)siblingSubview{
    NSUInteger siblingIndex = [self.subviews indexOfObject:siblingSubview];
    if (siblingIndex == NSNotFound)
        return;
    [self addSubview:view positioned:NSWindowAbove relativeTo:siblingSubview];
    [self.layer insertSublayer:view.layer above:siblingSubview.layer];
}

- (void)bringSubviewToFront:(NSView *)view{
    if([self.subviews containsObject:view]) {
        [view removeFromSuperview];
        NSView *top = [self __topSubview];
        if(top)
            [self insertSubview:view aboveSubview:top];
        else
            [self addSubview:view];
    }
}

- (void)sendSubviewToBack:(NSView *)view{
    if([self.subviews containsObject:view]) {
        [view removeFromSuperview];
        NSView *bottom = [self __bottomSubview];
        if(bottom)
            [self insertSubview:view belowSubview:bottom];
        else
            [self addSubview:view];
    }
}

- (void)didAddSubview:(NSView *)subview{ }

- (void)willRemoveSubview:(NSView *)subview{ }

- (void)setDrawRect:(XUIViewDrawRect)drawRect{
    _drawRect = drawRect;
}

- (XUIViewDrawRect)drawRect{
    return _drawRect;
}

-(void)setBackgroundColor:(NSColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    [self.layer setBackgroundColor:_backgroundColor.CGColor];
}

-(NSColor *)backgroundColor{
    return [_backgroundColor copy];
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}

-(CGFloat)cornerRadius{
    return [self.layer cornerRadius];
}

- (void)setAlpha:(CGFloat)alpha{
    [[self layer] setOpacity:alpha];
}

- (CGFloat)alpha{
    return [[self layer] opacity];
}

#pragma mark - Private Functions

- (NSView *)__topSubview
{
    return [self.subviews lastObject];
}

- (NSView *)__bottomSubview
{
    NSArray *s = self.subviews;
    if([s count] > 0)
        return [self.subviews objectAtIndex:0];
    return nil;
}

#pragma mark - Override

-(void)addSubview:(NSView *)view{
    [super addSubview:view];
    [self.superview didAddSubview:view];
}

-(void)removeFromSuperview{
    [self.layer removeFromSuperlayer];
    [self.superview willRemoveSubview:self];
    [super removeFromSuperview];
}

-(void)drawRect:(NSRect)dirtyRect{
    [super drawRect:dirtyRect];
    if(nil != _drawRect){
        _drawRect(self, dirtyRect);
    }
}

@end
