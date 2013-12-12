//
//  MaritimeCompanyTests.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MaritimeCompany.h"

@interface MaritimeCompanyTests : XCTestCase

@end

@implementation MaritimeCompanyTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testInit {
    NSMutableArray *companies = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i=0; i<10; i++) {
        [companies addObject:[[MaritimeCompany alloc] initWithIdentifier:i]];
    }
    
    for (int i=0; i<10; i++) {
        MaritimeCompany *mc = companies[i];
        XCTAssertEqual(mc.identifier, i, @"Mismatch in identifier, got %d, expected %d", mc.identifier, i);
        XCTAssertEqual(mc.isPrivate, NO, @"New maritime company is not private");
        XCTAssertEqual(mc.isConnected, NO, @"New maritime company is connected");
    }
}

@end
