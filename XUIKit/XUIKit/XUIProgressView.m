//
//  XUIProgressView.m
//  XUIKit
//
//  Created by Jovi on 7/4/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIProgressView.h"
#import "NSColor+XUIAdditions.h"
#import <Quartz/Quartz.h>

#define DefaultTrackColor           [NSColor colorWithHex:@"#b5b5b5" alpha:1.0]
#define DefaultProgressColor        [NSColor colorWithHex:@"#007ef3" alpha:1.0]

#define INSETS_TO_FRAME(EdgeInsets,Frame)\
NSMakeRect(EdgeInsets.left, EdgeInsets.bottom, NSWidth(Frame) - EdgeInsets.right - EdgeInsets.left, NSHeight(Frame) - EdgeInsets.top - EdgeInsets.bottom)


@implementation XUIProgressView{
    float                           _progress;
    NSColor                         *_progressTintColor;
    NSColor                         *_trackTintColor;
    NSImage                         *_progressImage;
    NSImage                         *_trackImage;
    CALayer                         *_progressTintLayer;
    CALayer                         *_trackTintLayer;
    NSEdgeInsets                    _progressEdgeInsets;
    NSEdgeInsets                    _trackEdgeInsets;
    
    struct{
        unsigned int showTrackImage:1;
        unsigned int showProgressImage:1;
    }_progressViewFlags;
}

#pragma mark - Override Methods

- (instancetype)init{
    if(self = [super init]){
        [self __initializeXUIProgressView];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self __initializeXUIProgressView];
    }
    return self;
}

#pragma mark - Private Methods

-(void)__initializeXUIProgressView{
    [self setWantsLayer:YES];
    _progressEdgeInsets = NSEdgeInsetsMake(0, 0, 0, 0);
    _trackEdgeInsets = NSEdgeInsetsMake(0, 0, 0, 0);
    
    _trackTintColor = DefaultTrackColor;
    _progressTintColor = DefaultProgressColor;
    _progress = 0;
    _progressViewFlags.showTrackImage = NO;
    _progressViewFlags.showProgressImage = NO;
    _trackTintLayer = [CALayer layer];
    [self.layer addSublayer:_trackTintLayer];
    
    _progressTintLayer = [CALayer layer];
    [self.layer addSublayer:_progressTintLayer];
    
    [self __updateLookup];
}

-(void)__updateLookup{
    NSColor *trackTintColor = _trackTintColor;
    NSColor *progressTintColor = _progressTintColor;
    if(_progressViewFlags.showTrackImage && nil != _trackImage){
        trackTintColor = [NSColor colorWithPatternImage:_trackImage];
    }
    if (_progressViewFlags.showProgressImage && nil != _progressImage) {
        progressTintColor = [NSColor colorWithPatternImage:_progressImage];
    }
    
    [_trackTintLayer setFrame:INSETS_TO_FRAME(_trackEdgeInsets, [self.layer bounds])];
    [_trackTintLayer setBackgroundColor:(nil == trackTintColor) ? DefaultTrackColor.CGColor :  trackTintColor.CGColor];
    
    NSRect rctProgress = INSETS_TO_FRAME(_progressEdgeInsets, [self.layer bounds]);
    rctProgress.size.width *= (_progress > 1.0 ? 1.0 : _progress);
    [_progressTintLayer setFrame:rctProgress];
    [_progressTintLayer setBackgroundColor:(nil == _progressTintColor) ? DefaultProgressColor.CGColor : progressTintColor.CGColor];
}

#pragma mark - Public Methods

-(void)setTrackTintColor:(NSColor *)trackTintColor{
    _progressViewFlags.showTrackImage = NO;
    _trackTintColor = trackTintColor;
    [self __updateLookup];
}

-(void)setProgressTintColor:(NSColor *)progressTintColor{
    _progressViewFlags.showProgressImage = NO;
    _progressTintColor = progressTintColor;
    [self __updateLookup];
}

-(void)setTrackImage:(NSImage *)trackImage{
    _progressViewFlags.showTrackImage = YES;
    _trackImage = trackImage;
    [self __updateLookup];
}

-(void)setProgressImage:(NSImage *)progressImage{
    _progressViewFlags.showProgressImage = YES;
    _progressImage = progressImage;
    [self __updateLookup];
}

-(void)setProgress:(float)progress{
    _progress = (progress >= 1.0) ? 1.0 : progress;
    [self __updateLookup];
}

- (void)setProgress:(float)progress animated:(BOOL)animated{
    _progress = (progress >= 1.0) ? 1.0 : progress;
    if (animated) {
        [self __updateLookup];
    }else{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self __updateLookup];
        [CATransaction commit];
    }
}

-(void)setProgressEdgeInsets:(NSEdgeInsets)progressEdgeInsets{
    _progressEdgeInsets = progressEdgeInsets;
    [self __updateLookup];
}

-(NSEdgeInsets)progressEdgeInsets{
    return _progressEdgeInsets;
}

-(void)setTrackEdgeInsets:(NSEdgeInsets)trackEdgeInsets{
    _trackEdgeInsets = trackEdgeInsets;
    [self __updateLookup];
}

-(NSEdgeInsets)trackEdgeInsets{
    return _trackEdgeInsets;
}

-(void)setProgressCornerRadius:(CGFloat)progressCornerRadius{
    _progressTintLayer.cornerRadius = progressCornerRadius;
    [self __updateLookup];
}

-(CGFloat)progressCornerRadius{
    return _progressTintLayer.cornerRadius;
}

-(void)setTrackCornerRadius:(CGFloat)trackCornerRadius{
    _trackTintLayer.cornerRadius = trackCornerRadius;
    [self __updateLookup];
}

-(CGFloat)trackCornerRadius{
    return _trackTintLayer.cornerRadius;
}

@end
