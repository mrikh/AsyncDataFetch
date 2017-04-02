//
//  HomeViewControllerTests.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 02/04/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "HomeViewController.h"
#import <XCTest/XCTest.h>

@interface HomeViewControllerTests : XCTestCase{
    
    HomeViewController *_homeViewController;
}

@end

@implementation HomeViewControllerTests

- (void)setUp {
    
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    _homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
}

- (void)testDataTask
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous request"];
    
    NSURL *url = [NSURL URLWithString:@"http://www.apple.com"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error, @"dataTaskWithURL error %@", error);
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *) response statusCode];
            XCTAssertEqual(statusCode, 200, @"status code was not 200; was %d", statusCode);
        }
        
        XCTAssert(data, @"data nil");
        
        [expectation fulfill];
    }];
    [task resume];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
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
