//
//  XUIRadioButton.m
//  XUIKit
//
//  Created by Jovi on 7/17/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIRadioButton.h"
#import "XUIRadioButtonCell.h"

@implementation XUIRadioButton

#pragma mark - Public Methods

-(void)setDetaY:(NSInteger)detaY{
    XUIRadioButtonCell *cell = [self cell];
    [cell setDetaY:detaY];
    [self setNeedsDisplay:YES];
}

-(NSInteger)detaY{
    XUIRadioButtonCell *cell = [self cell];
    return [cell detaY];
}

#pragma mark - Override Methods

+(Class)cellClass{
    return [XUIRadioButtonCell class];
}

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeXUIRadioButton];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self __initializeXUIRadioButton];
    }
    return self;
}

#pragma mark - Private Methods

-(void)__initializeXUIRadioButton{
}

@end
