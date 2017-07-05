//
//  XUIImageView.h
//  XUIKit
//
//  Created by Jovi on 6/19/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XUIImageView : NSImageView

// shapeAreaPath will affect the XUIImageView's display area.
@property (nullable, nonatomic, strong) NSBezierPath  *shapeAreaPath;

@end
