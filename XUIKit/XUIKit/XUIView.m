//
//  XUIView.m
//  XUIKit
//
//  Created by Jovi on 6/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIView.h"

@implementation XUIView{
    XUIViewDrawRect         _drawRectBlock;
}

- (void)setDrawRectBlock:(XUIViewDrawRect)drawRectBlock{
    _drawRectBlock = drawRectBlock;
}

- (XUIViewDrawRect)drawRectBlock{
    return [_drawRectBlock copy];
}

#pragma mark - Private Methods

-(void)__initializeXUIView{
    _drawRectBlock = nil;
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


