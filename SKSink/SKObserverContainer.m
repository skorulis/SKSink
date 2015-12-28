//  Created by Alexander Skorulis on 27/12/2015.
//  Copyright © 2015 Alexander Skorulis. All rights reserved.

#import <objc/runtime.h>
#import "SKObserverContainer.h"

@implementation SKObserverContainer {
    NSHashTable *_observers;
    Protocol *_protocol;
    NSMutableDictionary* _methodSignatures;
}

- (instancetype)init:(Protocol*)protocol {
    self = [super init];
    _protocol = protocol;
    _observers = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:2];
    _methodSignatures = [[NSMutableDictionary alloc] init];
    [self createMethodLookupTableForProtocol:_protocol];
    return self;
}

- (void)createMethodLookupTableForProtocol:(Protocol *)protocol {
    for(int b = 0; b < 4; ++b) {
        @autoreleasepool {
            BOOL isRequired       = b & 1;
            BOOL isInstanceMethod = b & 2;
            
            unsigned int count = 0;
            struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, isRequired, isInstanceMethod, &count);
            for(int i = 0; i < count; i++) {
                struct objc_method_description methodDescription = methods[i];
                SEL selector = methodDescription.name;
                NSString *selectorName = NSStringFromSelector(selector);
                NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
                _methodSignatures[selectorName] = signature;
                
            }
            free(methods);
        }
    }
}

- (void)addObserver:(id)observer {
    NSParameterAssert([observer conformsToProtocol:_protocol]);
    [_observers addObject:observer];
}

- (void)removeObserver:(id)observer {
    [_observers removeObject:observer];
}

- (NSSet*)allObservers {
    [self clean];
    NSMutableSet* ret = [[NSMutableSet alloc] init];
    for(id obj in _observers) {
        if(![[NSNull null] isEqual:obj]) {
            [ret addObject:obj];
        }
    }
    return ret;
}

- (void)clean {
    [_observers removeObject:[NSNull null]];
}

- (NSSet*)observersRespondingTo:(SEL)selector {
    NSMutableSet* ret = [[NSMutableSet alloc] init];
    for(NSObject* o in _observers) {
        if([o respondsToSelector:selector]) {
            [ret addObject:o];
        }
    }
    
    return ret;
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSParameterAssert([NSThread currentThread].isMainThread);
    [self forwardInvocationPrivate:anInvocation];
}

- (void)forwardInvocationPrivate:(NSInvocation *)anInvocation {
    NSSet* s = [self observersRespondingTo:anInvocation.selector];
    for(NSObject* o in s) {
        [anInvocation invokeWithTarget:o];
    }
}

- (BOOL)conformsToProtocol:(Protocol *)protocol {
    if (protocol_isEqual(protocol, _protocol)) {
        return YES;
    }
    return [super conformsToProtocol:protocol];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    NSString *selectorName = NSStringFromSelector(aSelector);
    if(_methodSignatures[selectorName] != nil) {
        return YES;
    }
    return [SKObserverContainer instancesRespondToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectorName = NSStringFromSelector(aSelector);
    NSMethodSignature *methodSignature = _methodSignatures[selectorName];
    if(methodSignature != nil) {
        return methodSignature;
    }
    
    return [super methodSignatureForSelector:aSelector];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Observer (%@) %d signatures %d listeners",NSStringFromProtocol(_protocol),(int)_methodSignatures.count, (int)_observers.count];
}


@end
