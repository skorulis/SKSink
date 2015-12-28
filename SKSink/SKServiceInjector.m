//  Created by Alexander Skorulis on 2/04/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

#import "SKServiceInjector.h"
#import "SKServiceActor.h"

@interface SKServiceInjector () {
    
}

@property (nonatomic, readonly) NSMutableDictionary* overrides;

@end

@implementation SKServiceInjector

- (instancetype) init {
    self = [super init];
    _overrides = [[NSMutableDictionary alloc] init];
    return self;
}

- (instancetype) initWithOverrides:(NSDictionary*)overrides {
    self = [self init];
    if(overrides) {
        _overrides = overrides.mutableCopy;
    }
    return self;
}

- (instancetype) initWithAllowedBackups:(NSArray*)allowedBackups {
    self = [self init];
    _allowedBackups = allowedBackups;
    return self;
}

- (instancetype) initWithAllowedBackups:(NSArray*)allowedBackups overrides:(NSDictionary*)overrides {
    self = [self initWithOverrides:overrides];
    _allowedBackups = allowedBackups;
    return self;
}

- (id) createService:(NSString*)name backup:(ServiceCreateBlock)backup {
    NSParameterAssert(_locator);
    NSParameterAssert(backup);
    
    if([_ignoredBackups containsObject:name]) {
        return nil;
    }
    
    ServiceCreateBlock createBlock = _overrides[name];
    id service;
    if(createBlock) {
        service = createBlock(_locator);
    } else if(!_allowedBackups || [_allowedBackups containsObject:name]) {
        service = backup(_locator);
    }
    if([service respondsToSelector:@selector(setSingleThreadMode:)]) {
        ((SKServiceActor*)service).singleThreadMode = self.singleThreadMode;
        [((SKServiceActor*)service) startService];
    }
    
    return service;
}

- (void) addOverride:(NSString*)serviceName createBlock:(ServiceCreateBlock)createBlock {
    _overrides[serviceName] = createBlock;
}

@end
