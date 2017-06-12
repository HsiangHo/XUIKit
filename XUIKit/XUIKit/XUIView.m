//
//  XUIView.m
//  XUIKit
//
//  Created by Jovi on 6/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIView.h"

@implementation XUIView{
    XUIViewDrawRect         _drawRect;
    NSColor                 *_backgroundColor;
    CGFloat                 _cornerRadius;
}

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(void)__initializeXUIView{
    _drawRect = nil;
    _backgroundColor = nil;
    _cornerRadius = 0;
}

- (void)insertSubview:(XUIView *)view atIndex:(NSInteger)index{
    
}

- (void)insertSubview:(XUIView *)view belowSubview:(XUIView *)siblingSubview{
    
}

- (void)insertSubview:(XUIView *)view aboveSubview:(XUIView *)siblingSubview{
    
}

- (void)bringSubviewToFront:(XUIView *)view{
    
}

- (void)sendSubviewToBack:(XUIView *)view{
    
}

- (void)didAddSubview:(XUIView *)subview{
    
}

- (void)willRemoveSubview:(XUIView *)subview{
    
}

@end
