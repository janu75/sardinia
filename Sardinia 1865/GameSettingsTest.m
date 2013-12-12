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


@end
