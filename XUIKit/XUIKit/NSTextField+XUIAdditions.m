//
//  NSTextField+XUIAdditions.m
//  XUIKit
//
//  Created by Jovi on 6/18/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "NSTextField+XUIAdditions.h"
#import <Quartz/Quartz.h>

@implementation NSTextField (XUIAdditions)

-(void)setLineBreakMode:(NSLineBreakMode)lineBreakMode{
    [[self cell] setLineBreakMode:lineBreakMode];
}

-(NSLineBreakMode)lineBreakMode{
    return [[self cell] lineBreakMode];
}

-(void)setUsesSingleLineMode:(BOOL)usesSingleLineMode{
    [[self cell] setUsesSingleLineMode:usesSingleLineMode];
}

-(BOOL)usesSingleLineMode{
    return [[self cell] usesSingleLineMode];
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

-(void)shakeWithCompletion:(nullable void (^)(void))block{
    [self setWantsLayer:YES];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @10, @-10, @10, @-10, @10, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(2 / 6.0), @(3 / 6.0), @(4 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.6;
    animation.additive = YES;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if(NULL != block){
            block();
        }
    }];
    [self.layer addAnimation:animation forKey:@"xuikit_shake"];
    [CATransaction commit];
}

@end
