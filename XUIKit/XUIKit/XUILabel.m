//
//  XUILabel.m
//  XUIKit
//
//  Created by Jovi on 6/18/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUILabel.h"
#import "NSView+XUIAdditions.h"
@implementation XUILabel

-(instancetype)init{
    self = [super init];
    if (self) {
        [self __initializeXUILabel];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self __initializeXUILabel];
    }
    return self;
}

-(void)__initializeXUILabel{
    self.textColor = [NSColor blackColor];
    [self setBezeled:NO];
    [self setDrawsBackground:NO];
    [self setEditable:NO];
    [self setSelectable:NO];
    [[self cell]setLineBreakMode:NSLineBreakByTruncatingTail];
}
@end
