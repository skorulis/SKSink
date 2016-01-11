//  Created by Alexander Skorulis on 2/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import <FMDB/FMDatabase.h>
#import "SQLIdManager.h"
#import "SQLStatement.h"
#import "FMResultSetWrapper.h"

@class BaseTableDBO;

@interface PixusDatabase : NSObject

@property (nonatomic, readonly) FMDatabase* fmdb;
@property (nonatomic, readonly) SQLIdManager* idManager;
@property (nonatomic) BOOL debugLog;

- (instancetype) initWithFMDB:(FMDatabase*)fmdb idManager:(SQLIdManager*)idManager debugLog:(BOOL)debugLog;

- (void) deleteObject:(DBOIdType)dbId table:(NSString*)table;
- (void) deleteObject:(BaseTableDBO*)dbo;

- (void) executeDelete:(SQLStatement*)statement;
- (BOOL) executeUpdate:(SQLStatement*)statement args:(NSArray*)args;
- (FMResultSet*) executeQuery:(SQLStatement*)statement;

- (int) count:(SQLStatement*)statement;
- (int) count:(SQLStatement *)statement args:(NSArray*)args;
- (int) count:(SQLStatement *)statement argsDict:(NSDictionary*)argsDict;

- (NSArray*) readObjects:(SQLStatement *)statement;
- (NSArray*) readObjects:(SQLStatement *)statement argsDict:(NSDictionary*)argsDic;
- (NSArray*) readObjects:(SQLStatement *)statement args:(NSArray*)args;
- (NSArray*) readObjects:(SQLStatement *)statement args:(NSArray*)args resultClass:(Class)resultClass;

- (NSDictionary*) readMap:(SQLStatement*)statement keyFunc:(id (^)(id obj))block;

- (id) readSingle:(SQLStatement *)statement args:(NSArray*)args resultClass:(Class)resultClass;
- (id) readSingle:(SQLStatement *)statement;

@end
