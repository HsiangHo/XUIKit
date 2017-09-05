//
//  XUIProperty.m
//  XUIKit
//
//  Created by Jovi on 6/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "XUIProperty.h"
#import <objc/runtime.h>

@interface XUIParasiteObject : NSObject

-(void)setProperty:(id)obj withKey:(NSString *)key;
-(id)propertyForKey:(NSString *)key;

@end

@implementation XUIParasiteObject{
    NSMutableDictionary     *_dictProperty;
}

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeXUIParasiteObject];
    }
    return self;
}

-(void)__initializeXUIParasiteObject{
    _dictProperty = [[NSMutableDictionary alloc] init];
}

-(void)setProperty:(id)obj withKey:(NSString *)key{
    if (nil == obj || nil == key) {
        return;
    }
    [_dictProperty setObject:obj forKey:key];
}
-(id)propertyForKey:(NSString *)key{
    id rtn = nil;
    if (nil != key) {
        rtn = [_dictProperty objectForKey:key];
    }
    return rtn;
}

@end

#define kProperty       "parasiteKey"

#pragma mark - Property Fuctions

void set_parasiteObj(NSObject *parasitifer,XUIParasiteObject *obj){
    objc_setAssociatedObject(parasitifer, kProperty, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

XUIParasiteObject *get_parasiteObj(NSObject *parasitifer){
    return objc_getAssociatedObject(parasitifer, kProperty);
}

void set_property(NSObject *parasitifer, id value, NSString *key){
    XUIParasiteObject *obj = get_parasiteObj(parasitifer);
    if(nil == obj){
        obj = [[XUIParasiteObject alloc] init];
        set_parasiteObj(parasitifer,obj);
    }
    [obj setProperty:value withKey:key];
}

id get_property(NSObject *parasitifer, NSString *key){
    id rtn = nil;
    XUIParasiteObject *obj = get_parasiteObj(parasitifer);
    if(nil != obj){
        rtn = [obj propertyForKey:key];
    }
    return rtn;
}
