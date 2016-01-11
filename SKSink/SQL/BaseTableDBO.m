//  Created by Alexander Skorulis on 2/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "BaseTableDBO.h"
#import "sqlite3.h"

@implementation BaseTableDBO

- (instancetype) initWithRow:(FMResultSetWrapper*)row {
    self = [super init];
    return self;
}

+ (BaseTableDBO*) dboWithRow:(FMResultSetWrapper*)row {
    BaseTableDBO* dbo = [[self class] alloc];
    return [dbo initWithRow:row];
}

+ (instancetype) readOptional:(FMResultSetWrapper*)row {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

+ (DBOIdType) nextRowId:(PixusDatabase*)db {
    sqlite_int64 dbId = [db.idManager nextId:[self tableName]];
    return (DBOIdType)dbId;
}

+ (void) insert:(BaseTableDBO*)dbo table:(NSString*)table db:(PixusDatabase*)db {
    NSArray* values = dbo.createValues;
    NSString* valueParams = [SQLStatement queryParamsString:values.count];
    
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES %@",table,valueParams];
    //NSLog(@"SQL %@",sql);
    [db.fmdb executeUpdate:sql withArgumentsInArray:dbo.createValues];
}

+ (NSString*) tableName {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return @"ERROR";
}

+ (instancetype) findById:(DBOIdType)dbId db:(PixusDatabase*)db {
    if(dbId == 0) {
        return nil;
    }
    SQLStatement* statement = [self baseStatement];
    statement.where = @"id = ?";
    return [db readSingle:statement args:@[@(dbId)] resultClass:[self class]];
}

+ (NSArray*) findWithIds:(NSArray*)ids db:(PixusDatabase*)db {
    return [self findWithField:@"id" inValues:ids db:db];
}

+ (NSArray*) findWithField:(NSString*)field inValues:(NSArray*)values db:(PixusDatabase*)db {
    SQLStatement* statement = [self statementWithField:field inValues:values];
    return [db readObjects:statement args:values resultClass:[self class]];
}

+ (SQLStatement*) statementWithField:(NSString*)field inValues:(NSArray*)values {
    SQLStatement* statement = [self baseStatement];
    statement.where = [NSString stringWithFormat:@"%@ IN %@",field, [SQLStatement queryParamsString:values.count]];
    return statement;
}

+ (NSArray*) findAll:(PixusDatabase*)db {
    SQLStatement* statement = [self baseStatement];
    return [db readObjects:statement args:nil resultClass:[self class]];
}

+ (SQLStatement*) baseStatement {
    SQLStatement* statement = [[SQLStatement alloc] init];
    statement.fields = @"*";
    statement.from = [self tableName];
    statement.resultClass = [self class];
    return statement;
}

- (NSArray*) createValues {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

- (DBOIdType) dbId {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0;
}

+ (id) FK_VALUE:(DBOIdType)field {
    if(field == 0) {
        return [NSNull null];
    }
    return @(field);
}

+ (id) OPT_VALUE:(id)value {
    if(value == nil) {
        return [NSNull null];
    }
    return value;
}

- (id) opt:(id)value {
    if(value == nil) {
        return [NSNull null];
    }
    return value;
}

- (id) fk:(DBOIdType)field {
    if(field == 0) {
        return [NSNull null];
    }
    return @(field);
}

@end
