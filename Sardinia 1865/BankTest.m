//
//  BankTest.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Bank.h"

@interface BankTest : XCTestCase

@end

@implementation BankTest

Bank *bank;

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    bank = [[Bank alloc] initWithMoney:8000];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testInit {
    Bank *bank = [[Bank alloc] initWithMoney:8000];
    
    XCTAssertEqual(bank.money, 8000, @"Starting Money");
    XCTAssertEqual([bank.trains count], (NSUInteger) 0, @"No trains at start");
    XCTAssertEqual([bank.certificates count], (NSUInteger) 0, @"No certificates at start");
    XCTAssertEqual(bank.ranOutOfMoney, NO, @"Bank does not start being bankcrupt");
}

- (void) testShareholderProtocol {
    XCTAssertEqual(bank.money,  8000, @"Shareholder Protocol test");
    XCTAssertEqual([bank.certificates count], (NSUInteger) 0, @"Shareholder Protocol test");
    
    Certificate *certA = [[Certificate alloc] initWithType:@"President Minor"];
    Certificate *certB = [[Certificate alloc] initWithType:@"Minor"];
    Certificate *certC = [[Certificate alloc] initWithType:@"President Major"];
    Certificate *certD = [[Certificate alloc] initWithType:@"Major"];
    
    XCTAssertNil(certA.owner, @"Shareholder protocol test");
    XCTAssertNil(certB.owner, @"Shareholder protocol test");
    XCTAssertNil(certC.owner, @"Shareholder protocol test");
    XCTAssertNil(certD.owner, @"Shareholder protocol test");
    
    // Removed buy & sell methods from Shareholder class
//    [bank buyCertificate:certA atPrice:100];
//    XCTAssertEqual(bank.money,  7900, @"Shareholder Protocol test");
//    XCTAssertEqual([bank.certificates count], (NSUInteger) 1, @"Shareholder Protocol test");
//    
//    XCTAssertEqualObjects(certA.owner, bank, @"Shareholder protocol test");
//    XCTAssertNil(certB.owner, @"Shareholder protocol test");
//    XCTAssertNil(certC.owner, @"Shareholder protocol test");
//    XCTAssertNil(certD.owner, @"Shareholder protocol test");
//    
//    [bank buyCertificate:certB atPrice:120];
//    XCTAssertEqual(bank.money,  7780, @"Shareholder Protocol test");
//    XCTAssertEqual([bank.certificates count], (NSUInteger) 2, @"Shareholder Protocol test");
//    
//    XCTAssertEqualObjects(certA.owner, bank, @"Shareholder protocol test");
//    XCTAssertEqualObjects(certB.owner, bank, @"Shareholder protocol test");
//    XCTAssertNil(certC.owner, @"Shareholder protocol test");
//    XCTAssertNil(certD.owner, @"Shareholder protocol test");
//    
//    [bank buyCertificate:certC atPrice:195];
//    XCTAssertEqual(bank.money,  7585, @"Shareholder Protocol test");
//    XCTAssertEqual([bank.certificates count], (NSUInteger) 3, @"Shareholder Protocol test");
//    
//    XCTAssertEqualObjects(certA.owner, bank, @"Shareholder protocol test");
//    XCTAssertEqualObjects(certB.owner, bank, @"Shareholder protocol test");
//    XCTAssertEqualObjects(certC.owner, bank, @"Shareholder protocol test");
//    XCTAssertNil(certD.owner, @"Shareholder protocol test");
//    
//    [bank buyCertificate:certD atPrice:290];
//    XCTAssertEqual(bank.money,  7295, @"Shareholder Protocol test");
//    XCTAssertEqual([bank.certificates count], (NSUInteger) 4, @"Shareholder Protocol test");
//    
//    XCTAssertEqualObjects(certA.owner, bank, @"Shareholder protocol test");
//    XCTAssertEqualObjects(certB.owner, bank, @"Shareholder protocol test");
//    XCTAssertEqualObjects(certC.owner, bank, @"Shareholder protocol test");
//    XCTAssertEqualObjects(certD.owner, bank, @"Shareholder protocol test");
//    
//    [bank sellCertificate:certA atPrice:120];
//    XCTAssertEqual(bank.money,  7415, @"Shareholder Protocol test");
//    XCTAssertEqual([bank.certificates count], (NSUInteger) 3, @"Shareholder Protocol test");
//    [bank sellCertificate:certB atPrice:90];
//    XCTAssertEqual(bank.money,  7505, @"Shareholder Protocol test");
//    XCTAssertEqual([bank.certificates count], (NSUInteger) 2, @"Shareholder Protocol test");
//    [bank sellCertificate:certC atPrice:100];
//    XCTAssertEqual(bank.money,  7605, @"Shareholder Protocol test");
//    XCTAssertEqual([bank.certificates count], (NSUInteger) 1, @"Shareholder Protocol test");
//    [bank sellCertificate:certD atPrice:180];
//    XCTAssertEqual(bank.money,  7785, @"Shareholder Protocol test");
//    XCTAssertEqual([bank.certificates count], (NSUInteger) 0, @"Shareholder Protocol test");
}

@end
