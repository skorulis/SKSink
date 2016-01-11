//  Created by Alexander Skorulis on 18/08/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "SKQueueDeadlockDetector.h"

@interface SKQueueDeadlockDetector ()

@property (nonatomic, readonly) NSMutableSet* locked;

@end

@implementation SKQueueDeadlockDetector

- (instancetype) init {
    self = [super init];
    _locked = [[NSMutableSet alloc] init];
    return self;
}

- (void) takeLock:(NSThread*)thread {
    @synchronized(self) {
        NSAssert(![_locked containsObject:thread],@"Attempt to perform a serial operation on a queue which would result in a deadlock");
        [_locked addObject:thread];
    }
}

- (void) releaseLock:(NSThread*)thread {
    @synchronized(self) {
        [_locked removeObject:thread];
    }
}

@end
