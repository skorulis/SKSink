//  Created by Alexander Skorulis on 3/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "SKSQLStatement.h"
#import "SKBaseDBO.h"

static NSString* const kRegexString = @":.+?\\b";

@implementation SKSQLStatement

- (instancetype) init {
    self = [super init];
    _args = [[NSMutableDictionary alloc] init];
    return self;
}

- (NSString*) selectSql {
    return [self sql:false];
}

- (NSString*) countSql {
    return [self sql:true];
}

- (NSString*) deleteSql {
    NSMutableString* sql = [[NSMutableString alloc] init];
    NSString* table = [self.resultClass performSelector:@selector(tableName)];
    [sql appendFormat:@"DELETE FROM %@",table];
    if(_where.length > 0) {
        [sql appendFormat:@" WHERE %@",_where];
    }
    return sql;
}

- (NSString*) sql:(BOOL)count {
    NSString* fields = count ? [NSString stringWithFormat:@"COUNT(%@)",_fields] : _fields;
    NSMutableString* sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"SELECT %@ FROM %@",fields,_from];
    if(_where.length > 0) {
        [sql appendFormat:@" WHERE %@",_where];
    }
    if(_groupBy.length > 0) {
        [sql appendFormat:@" GROUP BY %@",_groupBy];
    }
    if(_orderBy.length > 0) {
        [sql appendFormat:@" ORDER BY %@",_orderBy];
    }
    if(_limit > 0) {
        [sql appendFormat:@" LIMIT %d",_limit];
    }
    if(self.offset > 0) {
        [sql appendFormat:@" OFFSET %d",self.offset];
    }
    return sql;
}

- (NSString*) updateSql {
    NSMutableString* sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"UPDATE %@ SET %@",_from,_fields];
    if(_where.length > 0) {
        [sql appendFormat:@" WHERE %@",_where];
    }
    
    return sql;
}

+ (NSString*) queryParamsString:(NSInteger)count {
    NSParameterAssert(count > 0);
    NSMutableString* valueParams = [[NSMutableString alloc] initWithString:@"("];
    for(int i = 0; i < count; ++i) {
        if(i == count - 1) {
            [valueParams appendString:@"?)"];
        } else {
            [valueParams appendString:@"?, "];
        }
    }
    return valueParams;
}

+ (NSString*) filledParamsString:(NSArray*)ids {
    NSParameterAssert(ids.count > 0);
    NSMutableString* valueParams = [[NSMutableString alloc] initWithString:@"("];
    for(int i = 0; i < ids.count; ++i) {
        NSNumber* n = ids[i];
        if(i == ids.count - 1) {
            [valueParams appendFormat:@"%d)",n.intValue];
        } else {
            [valueParams appendFormat:@"%d, ",n.intValue];
        }
    }
    return valueParams;
}

- (void) appendJoin:(NSString*)join {
    if(self.from.length > 0) {
        self.from = [NSString stringWithFormat:@"%@ %@",self.from, join];
    } else {
        self.from = join;
    }
}

- (void) appendInClause:(NSString*)field count:(NSInteger)count {
    if(count == 0) {
        return;
    }
    NSString* filter = [NSString stringWithFormat:@"%@ IN %@",field,[SKSQLStatement queryParamsString:count]];
    [self appendWherePart:filter];
}

- (void) appendFilledInClause:(NSString*)field ids:(NSArray*)ids {
    NSString* params = [SKSQLStatement filledParamsString:ids];
    NSString* filter = [NSString stringWithFormat:@"%@ IN %@",field,params];
    [self appendWherePart:filter];
}

- (void) replaceInClause:(NSArray*)ids {
    NSString* params = [SKSQLStatement filledParamsString:ids];
    _where = [_where stringByReplacingOccurrencesOfString:@"???" withString:params];
}

- (void) appendFromPart:(NSString*)from {
    if(self.from.length > 0) {
        self.from = [NSString stringWithFormat:@"%@ %@",self.from,from];
    } else {
        self.from = from;
    }
}

- (void) appendWherePart:(NSString*)filter {
    if(self.where.length > 0) {
        self.where = [NSString stringWithFormat:@"%@ AND %@",self.where,filter];
    } else {
        self.where = filter;
    }
}

- (void) appendOrderBy:(NSString*)orderBy {
    if(self.orderBy.length > 0) {
        self.orderBy = [NSString stringWithFormat:@"%@, %@",self.orderBy,orderBy];
    } else {
        self.orderBy = orderBy;
    }
}

- (void) addValue:(id)value forParam:(NSString*)param {
    NSAssert([[self namedParameters] containsObject:param],@"No parameter called %@",param);
    if([value isKindOfClass:[SKBaseDBO class]]) {
        SKBaseDBO* dbo = value;
        self.args[param] = @([dbo dbId]);
    } else {
        self.args[param] = value;
    }
}

- (void) setInt:(int)value forParam:(NSString*)param {
    [self addValue:@(value) forParam:param];
}

- (NSSet*) namedParameters {
    NSError* error;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:kRegexString options:0
                                                                             error:&error];
    NSParameterAssert(!error);
    NSParameterAssert(regex);
    
    NSArray* texts = @[self.from?:@"",self.where?:@"",self.groupBy?:@"",self.orderBy?:@""];
    
    NSMutableSet* params = [[NSMutableSet alloc] init];
    for(NSString* s in texts) {
        NSArray* matches = [regex matchesInString:s options:0 range:NSMakeRange(0, s.length)];
        for(NSTextCheckingResult* result in matches) {
            NSString* param = [s substringWithRange:NSMakeRange(result.range.location+1, result.range.length-1)];
            [params addObject:param];
        }
    }
    
    return params;
}

@end
