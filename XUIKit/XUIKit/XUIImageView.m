//
//  XUIImageView.m
//  XUIKit
//
//  Created by Jovi on 6/19/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIImageView.h"
#import <Quartz/Quartz.h>
#import "NSBezierPath+XUIAdditions.h"

@implementation XUIImageView{
    NSBezierPath        *_shapeAreaPath;
    CAShapeLayer        *_shapeLayer;
}

#pragma mark - Public Methods

-(void)setShapeAreaPath:(NSBezierPath *)shapeAreaPath{
    _shapeAreaPath = shapeAreaPath;
    [self __setShapePath:shapeAreaPath];
}

-(NSBezierPath *)shapeAreaPath{
    return _shapeAreaPath;
}

#pragma mark - Private Methods

-(void)__initializeXUIImageView{
    [(NSImageCell *)[self cell] setImageScaling:NSImageScaleProportionallyUpOrDown];
    _shapeLayer = [CAShapeLayer layer];
    [self __setShapePath:nil];
}

-(void)__setShapePath:(NSBezierPath *)path{
    if(nil == path){
        path = [NSBezierPath bezierPathWithRect:self.bounds];
    }
    CGPathRef pathRef = [path quartzPath];
    _shapeLayer.path = pathRef;
    CGPathRelease(pathRef);
    self.layer.mask = _shapeLayer;
}

#pragma mark - Override Methods

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeXUIImageView];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self __initializeXUIImageView];
    }
    return self;
}

@end
