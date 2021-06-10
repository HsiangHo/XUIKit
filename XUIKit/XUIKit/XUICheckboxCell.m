//
//  XUICheckboxCell.m
//  XUIKit
//
//  Created by Jovi on 7/16/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUICheckboxCell.h"

#define     XUI_BORDER_COLOR        [NSColor colorWithCalibratedRed: 0.722 green: 0.722 blue: 0.722 alpha: 1]
#define     XUI_TILE_COLOR          [NSColor colorWithCalibratedRed: 0.231 green: 0.42 blue: 1 alpha: 1]

@implementation XUICheckboxCell{
    NSInteger       _detaY;
}

#pragma mark - Override Methods

-(instancetype)init{
    self = [super init];
    if (self) {
        [self __initializeXUICheckboxCell];
    }
    return self;
}

- (void)setNextState{
    if([self state] == NSOffState){
        [super setNextState];
    }
    [super setNextState];
}

- (void)drawImage:(NSImage*)image withFrame:(NSRect)frame inView:(NSView*)controlView{
    frame.origin.y += _detaY;
    [super drawImage:[self __drawStatusImage:frame.size] withFrame:frame inView:controlView];
}

#pragma mark - Private methods

-(void)__initializeXUICheckboxCell{
    _detaY = 0;
    [self setButtonType:NSSwitchButton];
    [self setAllowsMixedState:YES];
}

-(NSImage *)__drawStatusImage:(NSSize)size {
    if (@available(macOS 11, *)) {
    } else {
        size.height -= 4;
        size.width -= 4;
    }
    NSImage *image = [[NSImage alloc] initWithSize:size];
    NSRect rctBorder = NSMakeRect(0, 0, image.size.width,image.size.height);
    NSRect rctTile= NSInsetRect(rctBorder, 2.0, 2.0);
    
    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(rctBorder, 0.5, 0.5)  xRadius:2.0 yRadius:2.0];
    NSBezierPath *tilePath = [NSBezierPath bezierPathWithRoundedRect:rctTile xRadius:2.0 yRadius:2.0];
    NSBezierPath *checkPath = [NSBezierPath bezierPath];
    [checkPath moveToPoint: NSMakePoint(2, 7)];
    [checkPath curveToPoint: NSMakePoint(6, 3) controlPoint1: NSMakePoint(6, 3) controlPoint2: NSMakePoint(6, 3)];
    [checkPath lineToPoint: NSMakePoint(12, 11.5)];
    
    [image lockFocus];
    [NSGraphicsContext saveGraphicsState];
    
    [[NSColor whiteColor] set];
    [borderPath fill];
    
    [XUI_BORDER_COLOR setStroke];
    borderPath.lineWidth = 1;
    borderPath.lineJoinStyle = NSBevelLineJoinStyle;
    [borderPath stroke];
    
    int status = [((NSNumber *)self.objectValue) intValue];
    if(-1 == status){
        [XUI_TILE_COLOR setFill];
        [tilePath fill];
    }else if(1 == status){
        [XUI_TILE_COLOR setStroke];
        [checkPath setLineWidth:2.0];
        checkPath.lineCapStyle = NSRoundLineCapStyle;
        checkPath.lineJoinStyle = NSRoundLineJoinStyle;
        [checkPath stroke];
    }
    
    [NSGraphicsContext restoreGraphicsState];
    [image unlockFocus];
    return image;
}

@end
