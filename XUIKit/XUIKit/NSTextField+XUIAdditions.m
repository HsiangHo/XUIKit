//
//  NSTextField+XUIAdditions.m
//  XUIKit
//
//  Created by Jovi on 6/18/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "NSTextField+XUIAdditions.h"

@implementation NSTextField (XUIAdditions)

-(void)setLineBreakMode:(NSLineBreakMode)lineBreakMode{
    [[self cell] setLineBreakMode:lineBreakMode];
}

-(NSLineBreakMode)lineBreakMode{
    return [[self cell] lineBreakMode];
}

-(void)setText:(NSString *)text{
    [self setStringValue:text];
}

-(NSString *)text{
    return [self stringValue];
}

-(void)setAttributedText:(NSAttributedString *)attributedText{
    [self setAttributedStringValue:attributedText];
}

-(NSAttributedString *)attributedText{
    return self.attributedStringValue;
}

-(void)setPlaceholder:(NSString *)placeholder{
    [[self cell] setPlaceholderString:placeholder];
}

-(NSString *)placeholder{
    return [[self cell] placeholderString];
}

-(void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder{
    [[self cell] setPlaceholderAttributedString:attributedPlaceholder];
}

-(NSAttributedString *)attributedPlaceholder{
    return [[self cell] placeholderAttributedString];
}

@end
