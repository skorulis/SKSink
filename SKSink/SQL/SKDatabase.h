//  Created by Alexander Skorulis on 2/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import <FMDB/FMDatabase.h>
#import "SKSQLIdManager.h"
#import "SKSQLStatement.h"
#import "FMResultSetWrapper.h"

@class SKBaseDBO;

@interface SKDatabase : NSObject

@property (nonatomic, readonly) FMDatabase* fmdb;
@property (nonatomic, readonly) SKSQLIdManager* idManager;
@property (nonatomic) BOOL debugLog;

- (instancetype) initWithFMDB:(FMDatabase*)fmdb idManager:(SKSQLIdManager*)idManager debugLog:(BOOL)debugLog;

- (void) deleteObject:(DBOIdType)dbId table:(NSString*)table;
- (void) deleteObject:(SKBaseDBO*)dbo;

- (void) executeDelete:(SKSQLStatement*)statement;
- (BOOL) executeUpdate:(SKSQLStatement*)statement args:(NSArray*)args;
- (FMResultSet*) executeQuery:(SKSQLStatement*)statement;

- (int) count:(SKSQLStatement*)statement;
- (int) count:(SKSQLStatement *)statement args:(NSArray*)args;
- (int) count:(SKSQLStatement *)statement argsDict:(NSDictionary*)argsDict;

- (NSArray*) readObjects:(SKSQLStatement *)statement;
- (NSArray*) readObjects:(SKSQLStatement *)statement argsDict:(NSDictionary*)argsDic;
- (NSArray*) readObjects:(SKSQLStatement *)statement args:(NSArray*)args;
- (NSArray*) readObjects:(SKSQLStatement *)statement args:(NSArray*)args resultClass:(Class)resultClass;

- (NSDictionary*) readMap:(SKSQLStatement*)statement keyFunc:(id (^)(id obj))block;

- (id) readSingle:(SKSQLStatement *)statement args:(NSArray*)args resultClass:(Class)resultClass;
- (id) readSingle:(SKSQLStatement *)statement;

@end
