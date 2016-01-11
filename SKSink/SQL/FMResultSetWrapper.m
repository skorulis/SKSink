//  Created by Alexander Skorulis on 4/05/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "FMResultSetWrapper.h"

@interface FMResultSetWrapper () {
    int _columnIndex;
}


@end

@implementation FMResultSetWrapper

- (instancetype) initWithResultSet:(FMResultSet*)resultSet {
    self = [super init];
    _resultSet = resultSet;
    return self;
}

- (NSString*) nextString {
    return [_resultSet stringForColumnIndex:_columnIndex++];
}

- (DBOIdType) nextId {
    return [self nextInt];
}

- (BOOL) nextBool {
    return [_resultSet boolForColumnIndex:_columnIndex++];
}

- (int) nextInt {
    return [_resultSet intForColumnIndex:_columnIndex++];
}

- (long) nextLong {
    return [_resultSet longForColumnIndex:_columnIndex++];
}

- (double) nextDouble {
    return [_resultSet doubleForColumnIndex:_columnIndex++];
}

- (NSData*) nextData {
    return [_resultSet dataForColumnIndex:_columnIndex++];
}

- (void) skipNext {
    _columnIndex ++;
}

- (BOOL) nextRow {
    _columnIndex = 0;
    return [_resultSet next];
}

- (void) close {
    [_resultSet close];
}

@end
