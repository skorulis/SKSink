//  Created by Alexander Skorulis on 27/12/2015.
//  Copyright © 2015 Alexander Skorulis. All rights reserved.

#import <Foundation/Foundation.h>

@interface SKObserverContainer : NSObject

- (instancetype)init:(Protocol*)protocol;

- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;
- (NSSet*)allObservers;
- (NSSet*)observersRespondingTo:(SEL)selector;


@end
