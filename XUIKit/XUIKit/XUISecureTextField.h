//
//  XUISecureTextField.h
//  XUIKit
//
//  Created by Jovi on 7/18/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XUIType.h"

@class XUIButton;
@interface XUISecureTextField : NSSecureTextField

@property(nullable, nonatomic,strong) NSImage               *background;           // default is nil. draw in border rect. image should be stretchable
@property(nullable, nonatomic,strong) NSImage               *disabledBackground;   // default is nil. ignored if background not set. image should be stretchable

@property(nonnull, nonatomic, strong, readonly)  XUIButton  *clearButton;
@property(nonatomic)        XUITextFieldViewMode            clearButtonMode; // sets when the clear button shows up. default is XUITextFieldViewModeNever

@property(nullable, nonatomic,strong) NSView                *leftView;        // e.g. magnifying glass
@property(nonatomic)        XUITextFieldViewMode            leftViewMode;    // sets when the left view shows up. default is XUITextFieldViewModeNever

@property(nullable, nonatomic,strong) NSView                *rightView;       // e.g. bookmarks button
@property(nonatomic)        XUITextFieldViewMode            rightViewMode;   // sets when the right view shows up. default is XUITextFieldViewModeNever

@property(nonatomic,readonly,getter=isEditing) BOOL         editing;

@property(nonatomic,assign,readonly)    NSEdgeInsets        textEdgeInsets;  // default is {0,0,0,0}

@end
