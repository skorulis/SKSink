//  Created by Alexander Skorulis on 27/12/2015.
//  Copyright © 2015 Alexander Skorulis. All rights reserved.

#import <XCTest/XCTest.h>
#import "SKObserverContainer.h"

@protocol TestProtocol <NSObject>

@optional

- (void)method1;
- (void)method2;

@end

@interface TestImplementation1 : NSObject <TestProtocol>
@property (nonatomic) NSInteger method1Count;
@end

@implementation TestImplementation1
- (void)method1  {_method1Count++;}
@end

@interface TestImplementation2 : NSObject <TestProtocol>

@property (nonatomic) NSInteger method1Count;
@property (nonatomic) NSInteger method2Count;

@end

@implementation TestImplementation2
- (void)method1  {_method1Count++;}
- (void)method2  {_method2Count++;}
@end


@interface SKObserverContainerTests : XCTestCase

@end

@implementation SKObserverContainerTests

- (void)testObserverCounts {
    SKObserverContainer *container = [[SKObserverContainer alloc] init:@protocol(TestProtocol)];
    XCTAssertEqual(container.allObservers.count,0);
    @autoreleasepool {
        TestImplementation1 *t1 = [[TestImplementation1 alloc] init];
        [container addObserver:t1];
        XCTAssertEqual(container.allObservers.count,1);
        XCTAssertEqual([container observersRespondingTo:@selector(method1)].count, 1);
        XCTAssertEqual([container observersRespondingTo:@selector(method2)].count, 0);
        t1 = nil;
    }
    
    XCTAssertEqual(container.allObservers.count,0);
    XCTAssertEqual([container observersRespondingTo:@selector(method1)].count, 0);
}

- (void)testCalls {
    SKObserverContainer<TestProtocol> *container = (id) [[SKObserverContainer alloc] init:@protocol(TestProtocol)];

    TestImplementation1 *t1 = [[TestImplementation1 alloc] init];
    TestImplementation2 *t2 = [[TestImplementation2 alloc] init];
    
    [container addObserver:t1];
    [container addObserver:t2];
    
    [container method1];
    XCTAssertEqual(t1.method1Count, 1);
    XCTAssertEqual(t2.method1Count, 1);
    [container method2];
    [container method2];
    XCTAssertEqual(t2.method2Count, 2);
}

@end
