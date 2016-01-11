//  Created by Alexander Skorulis on 2/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import <FMDB/FMDB.h>

@interface SQLIdManager : NSObject

- (instancetype) initWithDB:(FMDatabase*)db tables:(NSArray*)tables;

- (int32_t) nextId:(NSString*)table;

@end
