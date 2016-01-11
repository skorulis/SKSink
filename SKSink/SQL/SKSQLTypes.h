//  Created by Alexander Skorulis on 19/06/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

@import Foundation;
#import "FMResultSetWrapper.h"

@interface SQLIntType : NSObject

@property (nonatomic,readonly) int value;

- (instancetype) initWithRow:(FMResultSetWrapper*)row;

- (NSNumber*) number;

- (int) intValue;

@end

@interface SQLDoubleType : NSObject

@property (nonatomic, readonly) double value;

- (instancetype) initWithRow:(FMResultSetWrapper*)row;

@end
