//
//  XUICheckbox.m
//  XUIKit
//
//  Created by Jovi on 7/16/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUICheckbox.h"
#import "XUICheckboxCell.h"

@implementation XUICheckbox

#pragma mark - Override Methods

+(Class)cellClass{
    return [XUICheckboxCell class];
}

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeXUICheckbox];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self __initializeXUICheckbox];
    }
    return self;
}

#pragma mark - Public Methods

-(NSInteger)detaY{
    XUICheckbox *cell = [self cell];
    return [cell detaY];
}

-(void)setDetaY:(NSInteger)nValue{
    XUICheckbox *cell = [self cell];
    [cell setDetaY:nValue];
    [self setNeedsDisplay:YES];
}

#pragma mark - Private Methods

-(void)__initializeXUICheckbox{
}

@end
