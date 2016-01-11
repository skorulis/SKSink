//  Created by Alexander Skorulis on 4/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import <FMDB/FMDB.h>

typedef int32_t DBOIdType;

@interface FMResultSetWrapper : NSObject

@property (nonatomic, readonly) FMResultSet* resultSet;

- (instancetype) initWithResultSet:(FMResultSet*)resultSet;

- (BOOL) nextRow;
- (void) close;

- (NSString*) nextString;
- (DBOIdType) nextId;
- (BOOL) nextBool;
- (int) nextInt;
- (long) nextLong;
- (double) nextDouble;
- (NSData*) nextData;
- (void) skipNext;

@end
