//  Created by Alexander Skorulis on 18/06/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

@import Foundation;
#import "CollapsingFutures.h"

@interface SKServiceActor : NSObject

@property (nonatomic, readonly) NSString* actorId;
@property (nonatomic, readonly) dispatch_queue_t serialQueue;

//Off by default, used for testing
@property (nonatomic) BOOL singleThreadMode;

- (NSString*) queueName;

- (void) performBlock:(void (^)(void))block;
- (TOCFuture*) performBlockWithResult:(id (^)(void))block;
- (void) performMainBlock:(void (^)(void))block;
- (void) future:(TOCFuture*)future thenDo:(void(^)(id value))block;
- (TOCFuture*) future:(TOCFuture *)future then:(id (^)(id))block;

- (void) startService;

@end
