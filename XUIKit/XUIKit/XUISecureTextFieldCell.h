//
//  XUISecureTextFieldCell.h
//  XUIKit
//
//  Created by Jovi on 7/18/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XUISecureTextFieldCell : NSSecureTextFieldCell

@property(nonatomic,readonly,getter=isEditing)  BOOL            editing;

@end
