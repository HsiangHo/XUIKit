//
//  XUIRadioButtonCell.m
//  XUIKit
//
//  Created by Jovi on 7/17/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIRadioButtonCell.h"

@implementation XUIRadioButtonCell{
    NSInteger       _detaY;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self __initializeXUIRadioButtonCell];
    }
    return self;
}

-(void)__initializeXUIRadioButtonCell{
    _detaY = 0;
    [self setButtonType:NSRadioButton];
}

-(NSRect)imageRectForBounds:(NSRect)theRect{
    NSRect imageFrame = [super imageRectForBounds:theRect];
    imageFrame.origin.y = (int)(NSHeight(theRect) - NSHeight(imageFrame) - _detaY);
    return imageFrame;
}

@end
