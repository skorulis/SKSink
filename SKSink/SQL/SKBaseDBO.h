//  Created by Alexander Skorulis on 2/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

@import Foundation;
#import "SKDatabase.h"
#import "SKSQLStatement.h"
#import "FMResultSetWrapper.h"

@interface SKBaseDBO : NSObject

- (instancetype) initWithRow:(FMResultSetWrapper*)row;
+ (instancetype) dboWithRow:(FMResultSetWrapper*)row;
+ (instancetype) readOptional:(FMResultSetWrapper*)row;

+ (DBOIdType) nextRowId:(SKDatabase*)db;

+ (NSString*) tableName;
+ (void) insert:(SKBaseDBO*)dbo table:(NSString*)table db:(SKDatabase*)db;
+ (instancetype) findById:(DBOIdType)dbId db:(SKDatabase*)db;
+ (NSArray*) findWithIds:(NSArray*)ids db:(SKDatabase*)db;
+ (NSArray*) findWithField:(NSString*)field inValues:(NSArray*)values db:(SKDatabase*)db;
+ (NSArray*) findAll:(SKDatabase*)db;

+ (SKSQLStatement*) statementWithField:(NSString*)field inValues:(NSArray*)values;

+ (id) FK_VALUE:(DBOIdType)field;
+ (id) OPT_VALUE:(id)value;

- (id) fk:(DBOIdType)field;
- (id) opt:(id)value;

+ (SKSQLStatement*) baseStatement;

- (NSArray*) createValues;

- (DBOIdType) dbId;

@end
