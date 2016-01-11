// Class to help find deadlocks caused by serial queues.

//  Created by Alexander Skorulis on 18/08/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import <Foundation/Foundation.h>

@interface SKQueueDeadlockDetector : NSObject

- (void) takeLock:(NSThread*)thread;
- (void) releaseLock:(NSThread*)thread;


@end
