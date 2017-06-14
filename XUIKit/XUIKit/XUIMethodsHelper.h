//
//  XUIMethodsHelper.h
//  XUIKit
//
//  Created by Jovi on 6/14/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL XUISwizzleMethod(Class cls, char plusOrMinus, SEL selA, SEL selB);
BOOL XUIMakeAliasMethod(Class cls, char plusOrMinus, SEL originalSel, SEL aliasSel);
