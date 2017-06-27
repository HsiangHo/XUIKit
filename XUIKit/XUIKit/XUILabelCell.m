//
//  XUILabelCell.m
//  XUIKit
//
//  Created by Jovi on 6/26/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUILabelCell.h"

@implementation XUILabelCell{
    BOOL                            _isMoving;
    NSInteger                       _deltaX;
    BOOL                            _leftToRight;
    NSSize                          _fontSize;
    CGFloat                         _movingSpeed;
}

#pragma mark - Override Method

-(instancetype)init{
    if(self = [super init]){
        [self __initializeXUILabelCell];
    }
    return self;
}

-(instancetype)initTextCell:(NSString *)string{
    if(self = [super initTextCell:string]){
        [self __initializeXUILabelCell];
    }
    return self;
}

-(void)startMoving{
    if (!_isMoving) {
        _fontSize = [self.stringValue sizeWithAttributes:@{NSFontAttributeName : self.font}];
        _isMoving = YES;
        [self __moveText];
    }
}

-(void)stopMoving{
    if (_isMoving) {
        _isMoving = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(__moveText) object:nil];
    }
}

-(void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{
    if (_isMoving) {
        cellFrame.origin.x += _deltaX;
        cellFrame.size.width = _fontSize.width * 1.5;
    }
    [super drawWithFrame:cellFrame inView:controlView];
}

#pragma mark - Private Method

-(void)__initializeXUILabelCell{
    _leftToRight = YES;
    _movingSpeed = 30;      //fps
}

-(void)__moveText{
    if (!_isMoving && [self.stringValue length] == 0) {
        return;
    }
    
    NSRect bounds = [[self controlView] bounds];
    NSInteger nRange = bounds.size.width - _fontSize.width;

    if(_leftToRight){
        if (nRange >= 0) {
            if(_deltaX >= nRange){
                _leftToRight = NO;
            }else{
                _leftToRight = YES;
            }
        }else{
            if(_deltaX >= 0){
                _leftToRight = NO;
            }else{
                _leftToRight = YES;
            }
        }
    }else{
        if (nRange >= 0) {
            if(_deltaX <= 0){
                _leftToRight = YES;
            }else{
                _leftToRight = NO;
            }
        }else{
            if(_deltaX <= nRange){
                _leftToRight = YES;
            }else{
                _leftToRight = NO;
            }
        }
    }
    
    if(_leftToRight){
        _deltaX += 1;
    }else{
        _deltaX -= 1;
    }
    [[self controlView] setNeedsDisplay:YES];
    [self performSelector:@selector(__moveText) withObject:nil afterDelay:1.0/_movingSpeed];
}

@end
