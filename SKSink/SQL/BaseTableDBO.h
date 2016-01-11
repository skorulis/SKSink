//  Created by Alexander Skorulis on 2/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

@import Foundation;
#import "PixusDatabase.h"
#import "SQLStatement.h"
#import "FMResultSetWrapper.h"

@interface BaseTableDBO : NSObject

- (instancetype) initWithRow:(FMResultSetWrapper*)row;
+ (instancetype) dboWithRow:(FMResultSetWrapper*)row;
+ (instancetype) readOptional:(FMResultSetWrapper*)row;

+ (DBOIdType) nextRowId:(PixusDatabase*)db;

+ (NSString*) tableName;
+ (void) insert:(BaseTableDBO*)dbo table:(NSString*)table db:(PixusDatabase*)db;
+ (instancetype) findById:(DBOIdType)dbId db:(PixusDatabase*)db;
+ (NSArray*) findWithIds:(NSArray*)ids db:(PixusDatabase*)db;
+ (NSArray*) findWithField:(NSString*)field inValues:(NSArray*)values db:(PixusDatabase*)db;
+ (NSArray*) findAll:(PixusDatabase*)db;

+ (SQLStatement*) statementWithField:(NSString*)field inValues:(NSArray*)values;

+ (id) FK_VALUE:(DBOIdType)field;
+ (id) OPT_VALUE:(id)value;

- (id) fk:(DBOIdType)field;
- (id) opt:(id)value;

+ (SQLStatement*) baseStatement;

- (NSArray*) createValues;

- (DBOIdType) dbId;

@end
