//  Created by Alexander Skorulis on 2/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "SKDatabase.h"
#import "SKBaseDBO.h"
#import "NSArray+SKFunctional.h"

@interface SKDatabase ()

@property (nonatomic) NSTimeInterval queryWarnTime;

@end

@implementation SKDatabase

- (instancetype) initWithFMDB:(FMDatabase*)fmdb idManager:(SKSQLIdManager*)idManager debugLog:(BOOL)debugLog {
    self = [super init];
    _debugLog = debugLog;
    _fmdb = fmdb;
    _idManager = idManager;
    _queryWarnTime = 0.5;
    return self;
}

- (FMResultSet*) executeQuery:(SKSQLStatement*)statement {
    return [_fmdb executeQuery:statement.selectSql];
}

- (NSArray*) readObjects:(SKSQLStatement *)statement {
    return [self readObjects:statement argsDict:statement.args];
}

- (NSArray*) readObjects:(SKSQLStatement *)statement argsDict:(NSDictionary*)argsDic {
    FMResultSet* resultSet = [self executeSQLQuery:statement.selectSql args:argsDic];
    return [self readResultSet:resultSet statement:statement resultClass:statement.resultClass];
}

- (NSArray*) readObjects:(SKSQLStatement *)statement args:(NSArray*)args {
    NSParameterAssert(statement.resultClass != nil);
    return [self readObjects:statement args:args resultClass:statement.resultClass];
}

- (NSArray*) readObjects:(SKSQLStatement *)statement args:(NSArray*)args resultClass:(Class)resultClass {
    FMResultSet* resultSet = [self executeSQLQuery:statement.selectSql args:args];
    return [self readResultSet:resultSet statement:statement resultClass:resultClass];
}

- (NSDictionary*) readMap:(SKSQLStatement*)statement keyFunc:(id (^)(id obj))block {
    NSArray* items = [self readObjects:statement];
    return [items sk_groupBySingle:block];
}

- (NSArray*) readResultSet:(FMResultSet*)resultSet statement:(SKSQLStatement*)statement resultClass:(Class)resultClass {
    NSTimeInterval start = [NSDate date].timeIntervalSince1970;
    if(!resultSet) {
        NSError* error = [_fmdb lastError];
        NSLog(@"Error performing query %@",error);
    }
    NSAssert(resultSet,@"No results for query %@",statement.selectSql);
    FMResultSetWrapper* resultWrapper = [[FMResultSetWrapper alloc] initWithResultSet:resultSet];
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    while([resultWrapper nextRow]) {
        SKBaseDBO* obj = [resultClass alloc];
        obj = [obj initWithRow:resultWrapper];
        [ret addObject:obj];
    }
    [resultSet close];
    NSTimeInterval diff = [NSDate date].timeIntervalSince1970 - start;
    if(self.debugLog || diff > self.queryWarnTime) {
        NSLog(@"QUERY: %@ ARGS %@",statement.selectSql,statement.args);
        NSLog(@"READ %d items of type %@ in %f seconds",(int)ret.count,NSStringFromClass(resultClass),diff);
    }
    return ret;
}

- (id) readSingle:(SKSQLStatement *)statement args:(NSArray*)args resultClass:(Class)resultClass {
    NSArray* all = [self readObjects:statement args:args resultClass:resultClass];
    NSParameterAssert(all.count <= 1);
    return all.firstObject;
}

- (id) readSingle:(SKSQLStatement *)statement {
    NSArray* all = [self readObjects:statement];
    NSParameterAssert(all.count <= 1);
    return all.firstObject;
}

- (FMResultSet*) executeSQLQuery:(NSString*)sql args:(id)args {
    FMResultSet* results;
    if([args isKindOfClass:[NSDictionary class]]) {
        results = [_fmdb executeQuery:sql withParameterDictionary:args];
    } else if([args isKindOfClass:[NSArray class]]) {
        results = [_fmdb executeQuery:sql withArgumentsInArray:args];
    } else {
        results = [_fmdb executeQuery:sql];
    }
    
    return results;
}

- (int) count:(SKSQLStatement*)statement {
    return [self count:statement argsDict:statement.args];
}

- (int) count:(SKSQLStatement *)statement args:(NSArray*)args {
    FMResultSet* resultSet = [_fmdb executeQuery:statement.countSql withArgumentsInArray:args];
    return [self getCount:resultSet statement:statement];
}

- (int) count:(SKSQLStatement *)statement argsDict:(NSDictionary*)argsDict {
    FMResultSet* resultSet = [self executeSQLQuery:statement.countSql args:argsDict];
    return [self getCount:resultSet statement:statement];
}

- (int) getCount:(FMResultSet*)resultSet statement:(SKSQLStatement*)statement {
    if(!resultSet) {
        NSError* error = [_fmdb lastError];
        NSLog(@"Error performing query %@",error);
    }
    NSAssert(resultSet,@"No results for query %@",statement.countSql);
    NSAssert(resultSet.columnCount == 1,@"Column count for count query is not 1 %@",statement.countSql);
    
    int value = 0;
    if(resultSet.next) {
        value = [resultSet intForColumnIndex:0];
    }
    NSAssert(!resultSet.next,@"Count query has more than 1 row: %@",statement.countSql);
    [resultSet close];
    return value;
}

- (BOOL) executeUpdate:(SKSQLStatement*)statement args:(NSArray*)args {
    return [_fmdb executeUpdate:statement.updateSql withArgumentsInArray:args];
}

- (void) deleteObject:(DBOIdType)dbId table:(NSString*)table {
    NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = ?",table];
    [_fmdb executeUpdate:sql withArgumentsInArray:@[@(dbId)]];
}

- (void) deleteObject:(SKBaseDBO*)dbo {
    NSString* tableName = [dbo.class performSelector:@selector(tableName)];
    [self deleteObject:dbo.dbId table:tableName];
}

- (void) executeDelete:(SKSQLStatement*)statement {
    NSString* sql = statement.deleteSql;
    [_fmdb executeUpdate:sql withParameterDictionary:statement.args];
}

@end
