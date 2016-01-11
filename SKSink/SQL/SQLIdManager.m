//  Created by Alexander Skorulis on 2/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "SQLIdManager.h"

@interface SQLIdManager ()

@property (nonatomic, readonly) NSMutableDictionary* idMap;

@end

@implementation SQLIdManager

- (instancetype) initWithDB:(FMDatabase*)db tables:(NSArray*)tables {
    self = [super init];
    _idMap = [[NSMutableDictionary alloc] init];
    [self loadIds:db tables:tables];
    return self;
}

- (void) loadIds:(FMDatabase*)db tables:(NSArray*)tables {
    for(NSString* s in tables) {
        NSString* sql = [NSString stringWithFormat:@"SELECT MAX(id) from %@",s];
        FMResultSet* result = [db executeQuery:sql];
        [result next];
        _idMap[s] = @([result intForColumnIndex:0]);
        [result close];
    }
}

- (int32_t) nextId:(NSString*)table {
    NSNumber* n = _idMap[table];
    NSParameterAssert(n);
    int32_t val = n.intValue + 1;
    _idMap[table] = @(val);
    return val;
}


@end
