//
//  XUIMethodsHelper.m
//  XUIKit
//
//  Created by Jovi on 6/14/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIMethodsHelper.h"
#import <objc/runtime.h>

BOOL XUISwizzleMethod(Class cls, char plusOrMinus, SEL selA, SEL selB){
    if (plusOrMinus == '+') {
        const char *clsName = class_getName(cls);
        cls = objc_getMetaClass(clsName);
    }
    Method methodA = class_getInstanceMethod(cls, selA);
    if (!methodA) return NO;
    Method methodB = class_getInstanceMethod(cls, selB);
    if (!methodB) return NO;
    
    class_addMethod(cls, selA, class_getMethodImplementation(cls, selA), method_getTypeEncoding(methodA));
    class_addMethod(cls, selB, class_getMethodImplementation(cls, selB), method_getTypeEncoding(methodB));
    
    method_exchangeImplementations(class_getInstanceMethod(cls, selA), class_getInstanceMethod(cls, selB));
    
    return YES;
}

BOOL XUIMakeAliasMethod(Class cls, char plusOrMinus, SEL originalSel, SEL aliasSel){
    BOOL result = NO;
    if (plusOrMinus == '+') {
        const char *clsName = class_getName(cls);
        cls = objc_getMetaClass(clsName);
    }
    Method method = class_getInstanceMethod(cls, originalSel);
    if (method) {
        IMP         imp    = method_getImplementation(method);
        const char *types  = method_getTypeEncoding(method);
        result = class_addMethod(cls, aliasSel, imp, types);
    }
    return result;
}
