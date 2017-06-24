//
//  XUIButton.h
//  XUIKit
//
//  Created by Jovi on 6/19/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XUIType.h"

@class XUILabel;
@class XUIImageView;
typedef enum : NSUInteger {
    XUIButtonTypeCustom = 0,
} XUIButtonType;

@interface XUIButton : NSButton

+ (id)buttonWithType:(XUIButtonType)buttonType;
+ (id)button; // custom

@property(nonatomic,assign)             NSEdgeInsets                titleEdgeInsets;
@property(nonatomic,assign)             NSEdgeInsets                imageEdgeInsets;
@property(nonatomic,assign)             BOOL                        dimsInBackground;
@property(nonatomic,readonly)           XUIButtonType               buttonType;
@property(nonatomic,readonly,strong)    XUILabel                    *titleLabel;
@property(nonatomic,readonly,strong)    XUIImageView                *imageView;

-(void)setTitle:(NSString *)title   XUI_UNAVAILABLE;
-(void)setAttributedStringValue:(NSAttributedString *)attributedStringValue XUI_UNAVAILABLE;
-(void)setImage:(NSImage *)image XUI_UNAVAILABLE;
-(void)setFont:(NSFont *)font XUI_UNAVAILABLE;

- (NSRect)backgroundRectForBounds:(NSRect)bounds;
- (NSRect)contentRectForBounds:(NSRect)bounds;
- (NSRect)titleRectForContentRect:(NSRect)contentRect;
- (NSRect)imageRectForContentRect:(NSRect)contentRect;

- (void)setTitle:(NSString *)title forState:(XUIControlState)state;
- (void)setAttributedTitle:(NSAttributedString *)attributedTitle forState:(XUIControlState)state;
- (void)setTitleColor:(NSColor *)color forState:(XUIControlState)state;
- (void)setBackgroundImage:(NSImage *)image forState:(XUIControlState)state;
- (void)setImage:(NSImage *)image forState:(XUIControlState)state;
- (void)setFont:(NSFont *)font forState:(XUIControlState)state;
- (void)setUnderLined:(BOOL)bUnderlined forState:(XUIControlState)state;
- (void)setBackgroundColor:(NSColor *)color forState:(XUIControlState)state;
- (void)setCornerRadius:(CGFloat)radius forState:(XUIControlState)state;

- (NSString *)titleForState:(XUIControlState)state;
- (NSAttributedString *)attributedTitleForState:(XUIControlState)state;
- (NSColor *)titleColorForState:(XUIControlState)state;
- (NSImage *)backgroundImageForState:(XUIControlState)state;
- (NSImage *)imageForState:(XUIControlState)state;
- (NSFont *)FontForState:(XUIControlState)state;
- (BOOL)isUnderlinedForState:(XUIControlState)state;
- (NSColor *)backgroundColorForState:(XUIControlState)state;
- (CGFloat)cornerRadiusForState:(XUIControlState)state;

@property(nonatomic,readonly,strong) NSString               *currentTitle;
@property(nonatomic,readonly,strong) NSAttributedString     *currentAttributedTitle;
@property(nonatomic,readonly,strong) NSColor                *currentTitleColor;
@property(nonatomic,readonly,strong) NSImage                *currentBackgroundImage;
@property(nonatomic,readonly,strong) NSImage                *currentImage;
@property(nonatomic,readonly,strong) NSFont                 *currentFont;
@property(nonatomic,readonly,assign) BOOL                   currentUnderLined;
@property(nonatomic,readonly,strong) NSColor                *currentBackgroundColor;
@property(nonatomic,readonly,assign) CGFloat                currentcornerRadius;

@end
