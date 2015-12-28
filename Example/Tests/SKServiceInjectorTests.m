//  Created by Alexander Skorulis on 28/12/2015.
//  Copyright © 2015 Alexander Skorulis. All rights reserved.

#import <XCTest/XCTest.h>
#import "SKServiceInjector.h"

@interface SKServiceInjectorTests : XCTestCase

@end

@implementation SKServiceInjectorTests

- (void)testInjection {
    SKServiceInjector *injector = [[SKServiceInjector alloc] init];
    injector.locator = self;
    
    id created = [injector createService:@"test" backup:^id(id locator) {
        return @"TEST";
    }];
    XCTAssertEqualObjects(created, @"TEST");
    
    NSDictionary *overrides = @{@"test" :^id(id locator) {
        return @"OVERRIDE";
    }};
    
    injector = [[SKServiceInjector alloc] initWithOverrides:overrides];
    injector.locator = self;
    created = [injector createService:@"test" backup:^id(id locator) {
        return @"TEST";
    }];
    
    XCTAssertEqualObjects(created, @"OVERRIDE");
    
}

@end
