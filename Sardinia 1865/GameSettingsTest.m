//
//  GameSettingsTest.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 12/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GameSettings.h"

@interface GameSettingsTest : XCTestCase

@end

@implementation GameSettingsTest

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
    GameSettings *settings = [[GameSettings alloc] init];
    
    XCTAssertNotNil(settings, @"Init test");
}

- (void) testInitialStockValues {
    GameSettings *settings = [[GameSettings alloc] init];
    NSDictionary *dict = @{@"2": @"100",
                           @"3": @"130",
                           @"4": @"130",
                           @"5": @"150",
                           @"6": @"150",
                           @"7": @"150"
                           };
    for (NSString* key in dict) {
        [settings enterNewPhase:[key intValue]];
        XCTAssertEqual([settings maxInitialStockValue], [dict[key]intValue], @"Initial stock value test");
    }
    [settings enterNewPhase:3];
    NSArray *list = [settings getInitialValuesForMoney:300];
    NSArray *correctList = @[@"60", @"70", @"80", @"90", @"100", @"110", @"120", @"130"];
    XCTAssertEqualObjects(list, correctList, @"Initial stock value test");

    [settings enterNewPhase:5];
    list = [settings getInitialValuesForMoney:290];
    correctList = @[@"60", @"70", @"80", @"90", @"100", @"110", @"120", @"130", @"140"];
    XCTAssertEqualObjects(list, correctList, @"Initial stock value test");
}

@end
