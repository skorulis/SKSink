//  Created by Alexander Skorulis on 3/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

@import Foundation;

@interface SQLStatement : NSObject

@property (nonatomic, copy) NSString* fields;
@property (nonatomic, copy) NSString* from;
@property (nonatomic, copy) NSString* where;
@property (nonatomic, copy) NSString* groupBy;
@property (nonatomic, copy) NSString* orderBy;
@property (nonatomic) int limit;
@property (nonatomic) int offset;
@property (nonatomic) Class resultClass;
@property (nonatomic, readonly) NSMutableDictionary* args;

- (NSString*) selectSql;
- (NSString*) countSql;
- (NSString*) updateSql;
- (NSString*) deleteSql;

+ (NSString*) queryParamsString:(NSInteger)count;

- (void) appendJoin:(NSString*)join;
- (void) appendInClause:(NSString*)field count:(NSInteger)count;
- (void) appendFilledInClause:(NSString*)field ids:(NSArray*)ids;
- (void) appendFromPart:(NSString*)from;
- (void) appendWherePart:(NSString*)filter;
- (void) appendOrderBy:(NSString*)orderBy;

- (void) replaceInClause:(NSArray*)ids;

- (void) addValue:(id)value forParam:(NSString*)param;
- (void) setInt:(int)value forParam:(NSString*)param;

- (NSSet*) namedParameters;

@end
