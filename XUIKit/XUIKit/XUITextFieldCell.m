//
//  XUITextFieldCell.m
//  XUIKit
//
//  Created by Jovi on 6/28/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUITextFieldCell.h"

NSRect Rect4Text(NSRect rect,NSEdgeInsets textEdgeInsets){
    rect.origin.x = textEdgeInsets.left;
    rect.origin.y = textEdgeInsets.bottom;
    rect.size.width = rect.size.width - textEdgeInsets.left - textEdgeInsets.right;
    rect.size.height = rect.size.height - textEdgeInsets.top - textEdgeInsets.bottom;
    return rect;
}

@implementation XUITextFieldCell{
    struct{
        unsigned int editing:1;
    }_textfieldFlags;
    NSEdgeInsets                      _textEdgeInsets;
}

-(BOOL)isEditing{
    return _textfieldFlags.editing;
}

-(void)setTextEdgeInsets:(NSEdgeInsets)textEdgeInsets{
    _textEdgeInsets = textEdgeInsets;
}

-(NSEdgeInsets)textEdgeInsets{
    return _textEdgeInsets;
}

-(void)editWithFrame:(NSRect)rect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)delegate event:(NSEvent *)event{
    _textfieldFlags.editing = YES;
    return [super editWithFrame:Rect4Text(rect,_textEdgeInsets) inView:controlView editor:textObj delegate:delegate event:event];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength{
    _textfieldFlags.editing = YES;
    [super selectWithFrame:Rect4Text(aRect,_textEdgeInsets) inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

- (void)endEditing:(NSText *)textObj{
    [super endEditing:textObj];
    _textfieldFlags.editing = NO;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{
    [super drawInteriorWithFrame:Rect4Text(cellFrame,_textEdgeInsets) inView:controlView];
}

@end
