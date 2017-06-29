//
//  XUITextFieldCell.h
//  XUIKit
//
//  Created by Jovi on 6/28/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XUITextFieldCell : NSTextFieldCell

@property(nonatomic,readonly,getter=isEditing)  BOOL            editing;
@property(nonatomic,assign)                     NSEdgeInsets    textEdgeInsets;

@end
