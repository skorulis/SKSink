//  Created by Alexander Skorulis on 2/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "SKBaseDBO.h"
#import "sqlite3.h"

@implementation SKBaseDBO

- (instancetype) initWithRow:(FMResultSetWrapper*)row {
    self = [super init];
    return self;
}

+ (SKBaseDBO*) dboWithRow:(FMResultSetWrapper*)row {
    SKBaseDBO* dbo = [[self class] alloc];
    return [dbo initWithRow:row];
}

+ (instancetype) readOptional:(FMResultSetWrapper*)row {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

+ (DBOIdType) nextRowId:(SKDatabase*)db {
    sqlite_int64 dbId = [db.idManager nextId:[self tableName]];
    return (DBOIdType)dbId;
}

+ (void) insert:(SKBaseDBO*)dbo table:(NSString*)table db:(SKDatabase*)db {
    NSArray* values = dbo.createValues;
    NSString* valueParams = [SKSQLStatement queryParamsString:values.count];
    
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES %@",table,valueParams];
    //NSLog(@"SQL %@",sql);
    [db.fmdb executeUpdate:sql withArgumentsInArray:dbo.createValues];
}

+ (NSString*) tableName {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return @"ERROR";
}

+ (instancetype) findById:(DBOIdType)dbId db:(SKDatabase*)db {
    if(dbId == 0) {
        return nil;
    }
    SKSQLStatement* statement = [self baseStatement];
    statement.where = @"id = ?";
    return [db readSingle:statement args:@[@(dbId)] resultClass:[self class]];
}

+ (NSArray*) findWithIds:(NSArray*)ids db:(SKDatabase*)db {
    return [self findWithField:@"id" inValues:ids db:db];
}

+ (NSArray*) findWithField:(NSString*)field inValues:(NSArray*)values db:(SKDatabase*)db {
    if (values.count == 0) {
        return @[];
    }
    SKSQLStatement* statement = [self statementWithField:field inValues:values];
    return [db readObjects:statement args:values resultClass:[self class]];
}

+ (SKSQLStatement*) statementWithField:(NSString*)field inValues:(NSArray*)values {
    SKSQLStatement* statement = [self baseStatement];
    [statement appendFilledInClause:field ids:values];
    return statement;
}

+ (NSArray*) findAll:(SKDatabase*)db {
    SKSQLStatement* statement = [self baseStatement];
    return [db readObjects:statement args:nil resultClass:[self class]];
}

+ (SKSQLStatement*) baseStatement {
    SKSQLStatement* statement = [[SKSQLStatement alloc] init];
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
