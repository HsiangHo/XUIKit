//
//  XUICheckbox.h
//  XUIKit
//
//  Created by Jovi on 7/16/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XUICheckbox : NSButton

//detaY means the offset of Y axis relative to the bottom, default value is 0
@property (nonatomic,assign)                            NSInteger   detaY;

@property (nonatomic,copy)                              NSColor     *titleColor;
@property (nonatomic,copy)                              NSFont      *font;
@property (nonatomic,assign,getter=isUnerLined)         BOOL        underLined;

@end
