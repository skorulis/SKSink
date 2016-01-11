//  Created by Alexander Skorulis on 3/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "NSArray+SKFunctional.h"

@implementation NSArray (SKFunctional)

- (NSMutableDictionary*) sk_groupBySingle:(id (^)(id obj))block {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    for(id obj in self) {
        id key = block(obj);
        NSParameterAssert(dic[key] == nil);
        dic[key] = obj;
    }
    
    return dic;
}

- (NSMutableDictionary*) sk_groupBy:(id (^)(id obj))block {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithCapacity:self.count];
    for(id obj in self) {
        id key = block(obj);
        NSMutableArray* a = dic[key];
        if(!a) {
            a = [[NSMutableArray alloc] init];
            dic[key] = a;
        }
        [a addObject:obj];
    }
    return dic;
}

@end
