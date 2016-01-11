//  Created by Alexander Skorulis on 19/06/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "SKSQLTypes.h"

@implementation SQLIntType

- (instancetype) initWithRow:(FMResultSetWrapper*)row {
    self = [super init];
    _value = [row nextInt];
    return self;
}

- (int) intValue {
    return _value;
}

- (NSNumber*) number {
    return @(_value);
}

@end

@implementation SQLDoubleType

- (instancetype) initWithRow:(FMResultSetWrapper*)row {
    self = [super init];
    _value = [row nextDouble];
    return self;
}

@end