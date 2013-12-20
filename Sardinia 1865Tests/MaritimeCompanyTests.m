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

- (void) testCoding {
    MaritimeCompany *mc = [[MaritimeCompany alloc] initWithIdentifier:3];
    mc.isConnected = YES;
    mc.isPrivate = YES;
    
    NSString *path = @"savetest-MaritimeCompany.plist";
    XCTAssertTrue([NSKeyedArchiver archiveRootObject:mc toFile:path], @"coding test");
    
    MaritimeCompany *copy = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    XCTAssertNotEqualObjects(mc, copy, @"coding test");
    
    NSString *path2 = @"savetest-MaritimeCompany2.plist";
    XCTAssertTrue([NSKeyedArchiver archiveRootObject:copy toFile:path2], @"coding test");
    
    MaritimeCompany *copy2 = [NSKeyedUnarchiver unarchiveObjectWithFile:path2];
    XCTAssertNotEqualObjects(mc, copy2, @"coding test");
    
    XCTAssertEqual(mc.isPrivate, copy2.isConnected, @"coding test");
    XCTAssertEqual(mc.isConnected, copy2.isPrivate, @"coding test");
    XCTAssertEqual(mc.identifier, copy2.identifier, @"coding test");
}


@end
