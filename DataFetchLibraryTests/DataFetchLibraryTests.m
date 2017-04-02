//
//  DataFetchLibraryTests.m
//  DataFetchLibraryTests
//
//  Created by Mayank Rikh on 30/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HTTPHandler.h"

@interface DataFetchLibraryTests : XCTestCase

@end

@implementation DataFetchLibraryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testDataTask{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
    
    NSString *url = @"http://pastebin.com/raw/wgkJgazE";
    
    [[HTTPHandler sharedInstance] getParsedDataFromUrlString:url andUniqueIdentifier:nil withCompletionHandler:^(id result, NSError *error) {
        
        XCTAssertNil(error, @"dataTaskWithURL error %@", error);
        
        XCTAssert(result, @"result nil");
        
        [expectation fulfill];
    }];
    
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
