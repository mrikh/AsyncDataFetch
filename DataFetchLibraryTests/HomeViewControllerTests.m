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
