//
//  TrainTest.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Train.h"

@interface TrainTest : XCTestCase

@end

@implementation TrainTest

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
//    Train *train = [[Train alloc] initWithCost:17 Capacity:42 AndEnd:[NSNumber numberWithInt:23]];
    Train *train = [[Train alloc] initWithTech:3 AndDiscount:NO];
    
    XCTAssertEqual(train.cost, 200, @"Train cost");
    XCTAssertEqual(train.capacity, 14, @"Train capacity");
    XCTAssertEqualObjects(train.rustsAt, [NSNumber numberWithInt:6], @"Train rust");
}

- (void) testCoding {
    Train *train = [[Train alloc] initWithTech:3 AndDiscount:NO];
    NSString *path = @"savetest-Train";
    XCTAssertTrue([NSKeyedArchiver archiveRootObject:train toFile:path], @"coding test");
    
    Train *copy = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    XCTAssertNotEqualObjects(train, copy, @"coding test");
    
    NSString *path2 = @"savetest-Train2";
    XCTAssertTrue([NSKeyedArchiver archiveRootObject:copy toFile:path2], @"coding test");
    
    Train *copy2 = [NSKeyedUnarchiver unarchiveObjectWithFile:path2];
    XCTAssertNotEqualObjects(train, copy2, @"coding test");
}


@end
