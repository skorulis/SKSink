//  Created by Alexander Skorulis on 2/04/2015.
//  Copyright (c) 2015 com.skorulis. All rights reserved.

@import Foundation;

typedef id (^ServiceCreateBlock)(id locator);

@interface SKServiceInjector : NSObject

@property (nonatomic, weak) id locator;
@property (nonatomic) NSArray* allowedBackups;
@property (nonatomic) NSArray* ignoredBackups;
@property (nonatomic) BOOL singleThreadMode;

- (instancetype)initWithOverrides:(NSDictionary*)overrides;
- (instancetype)initWithAllowedBackups:(NSArray*)allowedBackups;
- (instancetype)initWithAllowedBackups:(NSArray*)allowedBackups overrides:(NSDictionary*)overrides;

- (id)createService:(NSString*)name backup:(ServiceCreateBlock)backup;

- (void)addOverride:(NSString*)serviceName createBlock:(ServiceCreateBlock)createBlock;

@end
