//
//  XUILabelCell.h
//  XUIKit
//
//  Created by Jovi on 6/26/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XUILabelCell : NSTextFieldCell

@property (nonatomic,assign)        CGFloat      movingSpeed;

-(void)startMoving;
-(void)stopMoving;

@end
