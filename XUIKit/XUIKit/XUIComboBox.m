//
//  XUIComboBox.m
//  XUIKit
//
//  Created by Jovi on 7/17/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIComboBox.h"
#import "NSColor+XUIAdditions.h"

#define XUI_COMBOBOX_FIXED_HEIGHT           24

@implementation XUIComboBox{
    NSColor         *_arrowColor;
    NSColor         *_tileColor;
    NSColor         *_borderColor;
    NSColor         *_disableColor;
}

#pragma mark - Public methods

-(void)setArrowColor:(NSColor *)arrowColor{
    _arrowColor = arrowColor;
    [self setNeedsDisplay:YES];
}

-(void)setTileColor:(NSColor *)tileColor{
    _tileColor = tileColor;
    [self setNeedsDisplay:YES];
}

-(void)setBorderColor:(NSColor *)borderColor{
    _borderColor = borderColor;
    [self setNeedsDisplay:YES];
}

#pragma mark - Private methods

-(void)__initializeXUIComboBox{
    [self setFocusRingType:NSFocusRingTypeNone];
    [self setEditable:NO];
    [self setSelectable:NO];
    _arrowColor = [NSColor whiteColor];
    _tileColor =  [NSColor colorWithHex:@"#00a6ff" alpha:1.0];
    _borderColor = [NSColor colorWithHex:@"#00a6ff" alpha:1.0];
    _disableColor = [NSColor colorWithHex:@"#b4b5bd" alpha:1.0];
}

#pragma mark - Override methods

-(instancetype)init{
    self = [super init];
    if(self){
        [self __initializeXUIComboBox];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if(self){
        [self __initializeXUIComboBox];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    NSRect cellFrame = dirtyRect;
    cellFrame.size.width = NSWidth([self bounds]);
    cellFrame.origin.y = NSMaxY([self bounds]) - XUI_COMBOBOX_FIXED_HEIGHT;
    cellFrame.size.height = XUI_COMBOBOX_FIXED_HEIGHT;
    cellFrame.origin.x = 0;
    cellFrame = NSInsetRect(cellFrame, 0.5, 0.5);
    [self.backgroundColor set];
    NSRectFill(cellFrame);
    
    //Draw Border
    NSBezierPath *pathBorder = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:2.0 yRadius:2.0];
    [pathBorder setLineWidth:1.0];
    if(self.enabled){
        [_borderColor set];
    }else{
        [_disableColor set];
    }
    [pathBorder stroke];
    
    //Draw Tile
    NSRect bounds = NSMakeRect(cellFrame.origin.x + cellFrame.size.width - cellFrame.size.height, cellFrame.origin.y, cellFrame.size.height, cellFrame.size.height);
    NSBezierPath *pathBk = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(bounds, 0.5, 0.5) xRadius:0.0 yRadius:0.0];
    if(self.enabled){
        [_tileColor set];
    }else{
        [_disableColor set];
    }
    [pathBk fill];
    
    //Draw Arrow
    NSBezierPath *pathArrow = [NSBezierPath bezierPath];
    NSPoint pt1 = NSMakePoint(NSMidX(bounds) - 6, NSMidY(bounds) - 2);
    NSPoint pt2 = NSMakePoint(NSMidX(bounds) , NSMidY(bounds) + 4);
    NSPoint pt3 = NSMakePoint(NSMidX(bounds) + 6, NSMidY(bounds) - 2);
    [pathArrow moveToPoint:pt1];
    [pathArrow lineToPoint:pt2];
    [pathArrow lineToPoint:pt3];
    [pathArrow setLineWidth:1.5];
    
    [_arrowColor set];
    [pathArrow stroke];
    
    //Draw String
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc]initWithString: self.stringValue];
    [attrString beginEditing];
    
    if(self.enabled){
        [attrString addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, [attrString length])];
    }else{
        [attrString addAttribute:NSForegroundColorAttributeName value:_disableColor range:NSMakeRange(0, [attrString length])];
    }
    [attrString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [attrString length])];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setAlignment:self.alignment];
    if (nil != paragraphStyle) {
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,[attrString length])];
    }
    
    [attrString endEditing];
    NSRect rctString = cellFrame;
    rctString.origin.x += 5;
    rctString.origin.y += 2;
    rctString.size.width -= (NSHeight(cellFrame) + 5);
    [attrString drawInRect:rctString];
}

@end
