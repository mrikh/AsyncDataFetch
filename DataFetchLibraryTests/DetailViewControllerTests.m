//
//  DetailViewControllerTests.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 02/04/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "DetailViewController.h"
#import <XCTest/XCTest.h>

@interface DetailViewControllerTests : XCTestCase{
    
    DetailViewController *_detailViewController;
}
@end

@implementation DetailViewControllerTests

- (void)setUp {
    
    [super setUp];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    _detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
}

- (void)tearDown {
    
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testMoreButtonAction{
    
    XCTAssert([_detailViewController respondsToSelector:@selector(showButton:)]);
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
