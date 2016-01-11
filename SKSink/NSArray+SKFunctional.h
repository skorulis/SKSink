//  Created by Alexander Skorulis on 3/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

@import Foundation;

@interface NSArray (SKFunctional)

- (NSMutableDictionary*) sk_groupBySingle:(id (^)(id obj))block;
- (NSMutableDictionary*) sk_groupBy:(id (^)(id obj))block;

@end
