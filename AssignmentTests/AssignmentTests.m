//
//  AssignmentTests.m
//  AssignmentTests
//
//  Created by Apple on 16/05/18.
//  Copyright © 2018 Wipro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WebserviceRequest.h"

@interface AssignmentTests : XCTestCase

@end

@implementation AssignmentTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFactsServiceCall {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call Facts WS"];
    [[WebserviceRequest shared] callFacts:^(NSString *title, NSArray *rows, NSError *err) {
                            XCTAssert(TRUE);
                            [expectation fulfill];
                        } errorHandler:^(NSError *err) {
                            XCTAssertNil(err);
                        }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
