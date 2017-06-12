//
//  XUIProperty.h
//  XUIKit
//
//  Created by Jovi on 6/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>

void set_property(NSObject *parasitifer, id value, NSString *key);
id get_property(NSObject *parasitifer, NSString *key);

#define XUI_SET_PROPERTY(value,key)\
set_property(self,value,key);

#define XUI_GET_PROPERTY(key)\
get_property(self,key)
