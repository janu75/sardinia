//
//  CertificateTest.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Certificate.h"

@interface CertificateTest : XCTestCase

@end

@implementation CertificateTest

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
    Certificate *certA = [[Certificate alloc] initWithType:@"President Minor"];
    Certificate *certB = [[Certificate alloc] initWithType:@"President Major"];
    Certificate *certC = [[Certificate alloc] initWithType:@"Minor"];
    Certificate *certD = [[Certificate alloc] initWithType:@"Major"];
    Certificate *certE = [[Certificate alloc] initWithType:@"Great Company"];
    
    XCTAssertEqual(certA.share, 40, @"President certificate of minor company has 40%% share");
    XCTAssertEqual(certB.share, 20, @"President certificate of major company has 20%% share");
    XCTAssertEqual(certC.share, 20, @"Standard certificate of minor company has 20%% share");
    XCTAssertEqual(certD.share, 10, @"Standard certificate of major company has 10%% share");
    
    XCTAssertEqualObjects(certA.type, @"President Minor", @"Expected type from init");
    XCTAssertEqualObjects(certB.type, @"President Major", @"Expected type from init");
    XCTAssertEqualObjects(certC.type, @"Minor", @"Expected type from init");
    XCTAssertEqualObjects(certD.type, @"Major", @"Expected type from init");
    
    XCTAssertNil(certE, @"Init with unknown string");
}

@end
