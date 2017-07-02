//
//  XUITextFieldCell.m
//  XUIKit
//
//  Created by Jovi on 6/28/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUITextFieldCell.h"
#import "XUITextField.h"

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
}

-(BOOL)isEditing{
    return _textfieldFlags.editing;
}

-(void)editWithFrame:(NSRect)rect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)delegate event:(NSEvent *)event{
    _textfieldFlags.editing = YES;
    if ([controlView isKindOfClass:[XUITextField class]]) {
        XUITextField *tf = (XUITextField *)controlView;
        rect = Rect4Text(rect,[tf textEdgeInsets]);
    }
    return [super editWithFrame:rect inView:controlView editor:textObj delegate:delegate event:event];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength{
    [super selectWithFrame:aRect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
    _textfieldFlags.editing = YES;
    if ([controlView isKindOfClass:[XUITextField class]]) {
        XUITextField *tf = (XUITextField *)controlView;
        aRect = Rect4Text(aRect,[tf textEdgeInsets]);
    }
    [super selectWithFrame:aRect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

- (void)endEditing:(NSText *)textObj{
    [super endEditing:textObj];
    _textfieldFlags.editing = NO;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{
    if ([controlView isKindOfClass:[XUITextField class]]) {
        XUITextField *tf = (XUITextField *)controlView;
        cellFrame = Rect4Text(cellFrame,[tf textEdgeInsets]);
    }
    [super drawInteriorWithFrame:cellFrame inView:controlView];
}

@end
