//
//  XUILabel.m
//  XUIKit
//
//  Created by Jovi on 6/18/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUILabel.h"
#import "NSView+XUIAdditions.h"


@implementation XUILabel{
    NSAttributedString              *_attributedString;
    BOOL                            _underlined;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self __initializeXUILabel];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self __initializeXUILabel];
    }
    return self;
}

-(void)__initializeXUILabel{
    [self setBezeled:NO];
    [self setDrawsBackground:NO];
    [self setEditable:NO];
    [self setSelectable:NO];
    [[self cell]setLineBreakMode:NSLineBreakByTruncatingTail];
    _attributedString = nil;
    _underlined = NO;
}

-(void)setText:(NSString *)text{
    [super setStringValue:text];
    [super setAttributedStringValue:[self __createLookUpAttributeString]];
}

-(NSString *)text{
    return [super stringValue];
}

-(void)setUnderlined:(BOOL)underlined{
    _underlined = underlined;
    [super setAttributedStringValue:[self __createLookUpAttributeString]];
}

-(BOOL)isUnderLined{
    return _underlined;
}

-(void)setLineBreakMode:(NSLineBreakMode)lineBreakMode{
    [[self cell] setLineBreakMode:lineBreakMode];
    [super setAttributedStringValue:[self __createLookUpAttributeString]];
}

-(NSLineBreakMode)lineBreakMode{
    return [[self cell] lineBreakMode];
}

#pragma - mark Override Method

-(void)setAttributedStringValue:(NSAttributedString *)attributedStringValue{
    _attributedString = attributedStringValue;
    [super setAttributedStringValue:_attributedString];
}

-(NSAttributedString *)attributedStringValue{
    return _attributedString;
}

-(void)setFont:(NSFont *)font{
    [super setFont:font];
    [super setAttributedStringValue:[self __createLookUpAttributeString]];
}

-(void)setTextColor:(NSColor *)textColor{
    [super setTextColor:textColor];
    [super setAttributedStringValue:[self __createLookUpAttributeString]];
}

-(void)setAlignment:(NSTextAlignment)alignment{
    [super setAlignment:alignment];
    [super setAttributedStringValue:[self __createLookUpAttributeString]];
}

#pragma - mark Private Method

-(NSAttributedString *)__createLookUpAttributeString{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc]initWithString: super.stringValue];
    [attrString beginEditing];
    
    NSUInteger nLen = [attrString length];
    NSColor *stringColor = self.textColor;
    [attrString addAttribute:NSForegroundColorAttributeName value:stringColor range:NSMakeRange(0, nLen)];
    [attrString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, nLen)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.alignment];
    if (nil != paragraphStyle) {
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,nLen)];
    }
    
    [attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:(self.isUnderLined  ? NSUnderlineStyleSingle : NSUnderlineStyleNone)] range:NSMakeRange(0, nLen)];
    
    [attrString endEditing];
    return attrString;
}

@end
