//  Created by Alexander Skorulis on 18/06/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "SKServiceActor.h"

@implementation SKServiceActor

- (instancetype) init {
    self = [super init];
    _actorId = [[NSUUID UUID] UUIDString];
    _serialQueue = dispatch_queue_create(self.queueName.UTF8String, DISPATCH_QUEUE_SERIAL);
    return self;
}

- (NSString*) queueName {
    return [NSString stringWithFormat:@"%@-%@",NSStringFromClass(self.class),_actorId];
}

- (void) performBlock:(void (^)(void))block {
    if(_singleThreadMode) {
        block();
    } else {
        NSParameterAssert(_serialQueue != NULL);
        dispatch_async(_serialQueue, block);
    }
}

- (TOCFuture*) performBlockWithResult:(id (^)(void))block {
    if(_singleThreadMode) {
        return [TOCFuture futureWithResult:block()];
    } else {
        NSParameterAssert(_serialQueue != NULL);
        return [TOCFuture futureFromOperation:block dispatchedOnQueue:_serialQueue];
    }
}

- (void) performMainBlock:(void (^)(void))block {
    if(_singleThreadMode) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

- (void) future:(TOCFuture*)future thenDo:(void(^)(id value))block {
    NSParameterAssert(_serialQueue != NULL);
    __weak typeof(self) weakSelf = self;
    [future thenDo:^(id value) {
        if(weakSelf.singleThreadMode) {
            block(value);
        } else {
            dispatch_async(weakSelf.serialQueue, ^{
                block(value);
            });
        }
    }];
}

- (TOCFuture*) future:(TOCFuture *)future then:(id (^)(id))block {
    NSParameterAssert(_serialQueue != NULL);
    __weak typeof(self) weakSelf = self;
    return [future then:^id(id value) {
        if(weakSelf.singleThreadMode) {
            return [TOCFuture futureWithResult:block(value)];
        } else {
            return [TOCFuture futureFromOperation:^{
                return block(value);
            }dispatchedOnQueue:weakSelf.serialQueue];
        }
    }];
}

- (void) startService {/*Implemented as required*/}

@end
