//
//  XUICheckbox.m
//  XUIKit
//
//  Created by Jovi on 7/16/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUICheckbox.h"
#import "XUICheckboxCell.h"

@implementation XUICheckbox{
    NSColor             *_titleColor;
    NSFont              *_font;
    NSAttributedString  *_attributedTitle;
    struct {
        unsigned int isNormalStringValue:1;
        unsigned int isUnderLined:1;
    } _buttonFlags;
}

#pragma mark - Override Methods

+(Class)cellClass{
    return [XUICheckboxCell class];
}

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeXUICheckbox];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self __initializeXUICheckbox];
    }
    return self;
}

#pragma mark - Public Methods

-(NSInteger)detaY{
    XUICheckbox *cell = [self cell];
    return [cell detaY];
}

-(void)setDetaY:(NSInteger)nValue{
    XUICheckbox *cell = [self cell];
    [cell setDetaY:nValue];
    [self setNeedsDisplay:YES];
}

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    _buttonFlags.isNormalStringValue = YES;
    _attributedTitle = nil;
    [self __updateLookup];
}

-(NSString *)title{
    return [super title];
}

-(void)setTitleColor:(NSColor *)titleColor{
    _titleColor = titleColor;
    _buttonFlags.isNormalStringValue = YES;
    [self __updateLookup];
}

-(NSColor *)titleColor{
    return _titleColor;
}

-(void)setFont:(NSFont *)font{
    _font = font;
    _buttonFlags.isNormalStringValue = YES;
    [self __updateLookup];
}

-(NSFont *)font{
    return _font;
}

-(void)setUnderLined:(BOOL)underLined{
    _buttonFlags.isUnderLined = underLined;
    _buttonFlags.isNormalStringValue = YES;
    [self __updateLookup];
}

-(BOOL)isUnderLined{
    return _buttonFlags.isUnderLined;
}

-(void)setAttributedTitle:(NSAttributedString *)attributedTitle{
    _attributedTitle = attributedTitle;
    _buttonFlags.isNormalStringValue = NO;
    [super setTitle:@""];
    [self __updateLookup];
}

-(NSAttributedString *)attributedTitle{
    return [super attributedTitle];
}

#pragma mark - Private Methods

-(void)__initializeXUICheckbox{
    _buttonFlags.isNormalStringValue = YES;
    _buttonFlags.isUnderLined = NO;
    _titleColor = [NSColor blackColor];
    _font = [NSFont fontWithName:@"Helvetica Neue" size:14];
}

-(void)__updateLookup{
    if (_buttonFlags.isNormalStringValue) {
        [super setAttributedTitle:[self __createLookUpAttributeString]];
    }else{
        [super setAttributedTitle:_attributedTitle];
    }
    [self setNeedsDisplay];
}

-(NSAttributedString *)__createLookUpAttributeString{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc]initWithString: super.title];
    [attrString beginEditing];
    
    NSUInteger nLen = [attrString length];
    NSColor *stringColor = _titleColor;
    [attrString addAttribute:NSForegroundColorAttributeName value:stringColor range:NSMakeRange(0, nLen)];
    [attrString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, nLen)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.alignment];
    if (nil != paragraphStyle) {
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,nLen)];
    }
    
    [attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:(_buttonFlags.isUnderLined  ? NSUnderlineStyleSingle : NSUnderlineStyleNone)] range:NSMakeRange(0, nLen)];
    
    [attrString endEditing];
    return attrString;
}

@end
