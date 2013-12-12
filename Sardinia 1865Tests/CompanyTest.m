//
//  CompanyTest.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Company.h"

@interface CompanyTest : XCTestCase

@end

@implementation CompanyTest

Company *compA;
Company *compB;
Company *compC;

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    compA = [[Company alloc] initWithName:@"FMS" AndPrice:80];
    compB = [[Company alloc] initWithName:@"FCS" AndPrice:90];
    compC = [[Company alloc] initWithName:@"SFS" AndPrice:100];   
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testInit {
    NSArray *names = [NSArray arrayWithObjects:@"FMS", @"RCSF", @"SFSS", @"FCS", @"SFS", @"FA", @"CFC", @"CFD", nil];
    NSMutableArray *companies = [[NSMutableArray alloc] initWithCapacity:8];
    int i = 40;
    for (NSString *name in names) {
        i += 20;
        [companies addObject:[[Company alloc] initWithName:name AndPrice:i]];
    }
    
    i = 0;
    NSDictionary *longNames = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Ferrovie Meridionali Sarde", @"FMS",
                               @"Regia Compagnia delle Ferrovie della Sardegna", @"RCSF",
                               @"Strade Ferrate Settentrionali Sarde", @"SFSS",
                               @"Ferrovie Complementari di Sardegna", @"FCS",
                               @"Societá Italiana Strade Ferrate Secondarie della Sardegna", @"SFS",
                               @"Ferrovia degli Aranci", @"FA",
                               @"Chemin de fer Corse", @"CFC",
                               @"Chemins de Fer Départementaux", @"CFD",
                               nil];
    for (Company *comp in companies) {
        XCTAssertEqual(comp.isOperating, NO, @"Init test");
        XCTAssertEqual(comp.isFloating, NO, @"Init test");
        XCTAssertEqual(comp.isMajor, NO, @"Init test");

        XCTAssertEqual(comp.numStationMarkers, 3, @"Init test");
        XCTAssertEqual(comp.builtStations, 1, @"Init test");
        XCTAssertEqual(comp.traffic, 0, @"Init test");
        XCTAssertEqual(comp.trainCapacity, 0, @"Init test");
        XCTAssertEqual(comp.stockPrice, i*20+60, @"Init test");
        
        XCTAssertEqualObjects(comp.name, longNames[names[i]], @"Init test");
        XCTAssertEqualObjects(comp.shortName, names[i], @"Init test");
        
        XCTAssertEqual([comp.trains count], (NSUInteger) 0, @"Init test");
        XCTAssertEqual([comp.maritimeCompanies count], (NSUInteger) 0, @"Init test");
        i++;
    }
}

- (void) testShareholderProtocol {
    XCTAssertEqual(compA.money,  0, @"Shareholder Protocol test");
    XCTAssertEqual(compB.money,  0, @"Shareholder Protocol test");
    XCTAssertEqual(compC.money,  0, @"Shareholder Protocol test");
    
    XCTAssertEqual([compA.certificates count], (NSUInteger) 0, @"Shareholder Protocol test");
    XCTAssertEqual([compB.certificates count], (NSUInteger) 0, @"Shareholder Protocol test");
    XCTAssertEqual([compC.certificates count], (NSUInteger) 0, @"Shareholder Protocol test");
    
    Certificate *certA = [[Certificate alloc] initWithType:@"President Minor"];
    Certificate *certB = [[Certificate alloc] initWithType:@"Minor"];
    Certificate *certC = [[Certificate alloc] initWithType:@"President Major"];
    Certificate *certD = [[Certificate alloc] initWithType:@"Major"];
    
    [compA equipCertificate:certA];
    [compB equipCertificate:certB];
    [compC equipCertificate:certC];
    [compA equipCertificate:certD];
    
    XCTAssertEqual(compA.money,  0, @"Shareholder Protocol test");
    XCTAssertEqual(compB.money,  0, @"Shareholder Protocol test");
    XCTAssertEqual(compC.money,  0, @"Shareholder Protocol test");
    
    XCTAssertEqual([compA.certificates count], (NSUInteger) 2, @"Shareholder Protocol test");
    XCTAssertEqual([compB.certificates count], (NSUInteger) 1, @"Shareholder Protocol test");
    XCTAssertEqual([compC.certificates count], (NSUInteger) 1, @"Shareholder Protocol test");

    [compA sellCertificate:certA];
    [compB sellCertificate:certB];
    [compC sellCertificate:certC];
    [compA sellCertificate:certD];

    XCTAssertEqual(compA.money,  3 *  80, @"Shareholder Protocol test");
    XCTAssertEqual(compB.money,  1 *  90, @"Shareholder Protocol test");
    XCTAssertEqual(compC.money,  2 * 100, @"Shareholder Protocol test");
    
    XCTAssertEqual([compA.certificates count], (NSUInteger) 0, @"Shareholder Protocol test");
    XCTAssertEqual([compB.certificates count], (NSUInteger) 0, @"Shareholder Protocol test");
    XCTAssertEqual([compC.certificates count], (NSUInteger) 0, @"Shareholder Protocol test");
}

- (void) testRank {
    XCTAssertEqual([compA rank], 1, @"Company rank test");
    XCTAssertEqual([compB rank], 1, @"Company rank test");
    XCTAssertEqual([compC rank], 1, @"Company rank test");
    
    Train *trainA = [[Train alloc] initWithTech:2 AndDiscount:NO];
    Train *trainB = [[Train alloc] initWithTech:4 AndDiscount:YES];
    
    [compA placeStationMarkerForCost:120];
    [compB buyTrain:trainA];
    [compC buyTrain:trainB];
    
    XCTAssertEqual([compA rank], 2, @"Company rank test");
    XCTAssertEqual([compB rank], 3, @"Company rank test");
    XCTAssertEqual([compC rank], 5, @"Company rank test");
}

- (void) testPlaceStaceMarker {
    Certificate *cert = [[Certificate alloc] initWithType:@"President Minor"];
    [compA sellCertificate:cert];
    [compB sellCertificate:cert];
    [compC sellCertificate:cert];
    
    XCTAssertEqual(compA.builtStations, 1, @"Place station marker test");
    XCTAssertEqual(compB.builtStations, 1, @"Place station marker test");
    XCTAssertEqual(compC.builtStations, 1, @"Place station marker test");
    XCTAssertEqual(compA.money, 160, @"Place station marker test");
    XCTAssertEqual(compB.money, 180, @"Place station marker test");
    XCTAssertEqual(compC.money, 200, @"Place station marker test");
    
    [compA placeStationMarkerForCost:110];
    [compB placeStationMarkerForCost:70];
    [compA placeStationMarkerForCost:50];
    
    XCTAssertEqual(compA.builtStations, 3, @"Place station marker test");
    XCTAssertEqual(compB.builtStations, 2, @"Place station marker test");
    XCTAssertEqual(compC.builtStations, 1, @"Place station marker test");
    XCTAssertEqual(compA.money, 0, @"Place station marker test");
    XCTAssertEqual(compB.money, 110, @"Place station marker test");
    XCTAssertEqual(compC.money, 200, @"Place station marker test");
}

- (void) testBuyAndSellTrain {
    Certificate *cert = [[Certificate alloc] initWithType:@"President Minor"];
    [compA sellCertificate:cert];
    [compB sellCertificate:cert];
    [compC sellCertificate:cert];
    
    XCTAssertEqual([compA.trains count], (NSUInteger) 0, @"Buy train test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 0, @"Buy train test");
    XCTAssertEqual([compC.trains count], (NSUInteger) 0, @"Buy train test");
    XCTAssertEqual(compA.money, 160, @"Buy train test");
    XCTAssertEqual(compB.money, 180, @"Buy train test");
    XCTAssertEqual(compC.money, 200, @"Buy train test");
    
    Train *trainA = [[Train alloc] initWithTech:2 AndDiscount:NO];
    Train *trainB = [[Train alloc] initWithTech:3 AndDiscount:NO];
    Train *trainC = [[Train alloc] initWithTech:4 AndDiscount:YES];

    [compA buyTrain:trainA];
    [compB buyTrain:trainB];
    [compC buyTrain:trainC];
    
    XCTAssertEqual([compA.trains count], (NSUInteger) 1, @"Buy train test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 1, @"Buy train test");
    XCTAssertEqual([compC.trains count], (NSUInteger) 1, @"Buy train test");
    XCTAssertEqual(compA.money,   60, @"Buy train test");
    XCTAssertEqual(compB.money, - 20, @"Buy train test");
    XCTAssertEqual(compC.money, -100, @"Buy train test");
    
    [compA sellTrain:trainA];
    [compB sellTrain:trainB ForMoney:70];
    [compC buyTrain:trainB ForMoney:70];
    
    XCTAssertEqual([compA.trains count], (NSUInteger) 0, @"Buy train test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 0, @"Buy train test");
    XCTAssertEqual([compC.trains count], (NSUInteger) 2, @"Buy train test");
    XCTAssertEqual(compA.money,  160, @"Buy train test");
    XCTAssertEqual(compB.money,   50, @"Buy train test");
    XCTAssertEqual(compC.money, -170, @"Buy train test");
}

- (void) testLayTrack {
    XCTAssertEqual(compA.money, 0, @"lay track test");
    [compA layExtraTrack];
    XCTAssertEqual(compA.money, -20, @"lay track test");
    [compA layExtraTrack];
    XCTAssertEqual(compA.money, -40, @"lay track test");
}

- (void) testOperateMines {
    // operate Mines is a no op
}

- (void) testTrafficUpgrade {
    XCTAssertEqual(compA.traffic, 0, @"Traffic upgrade test");
    XCTAssertEqual(compB.traffic, 0, @"Traffic upgrade test");
    XCTAssertEqual(compC.traffic, 0, @"Traffic upgrade test");

    [compA trafficUpgrade:5];
    [compB trafficUpgrade:7];
    [compC trafficUpgrade:12];

    XCTAssertEqual(compA.traffic,  5, @"Traffic upgrade test");
    XCTAssertEqual(compB.traffic,  7, @"Traffic upgrade test");
    XCTAssertEqual(compC.traffic, 12, @"Traffic upgrade test");
}

- (void) testIncreaseStockPrice {
    XCTAssertEqual(compA.stockPrice,  80, @"increase stock price test");
    XCTAssertEqual(compB.stockPrice,  90, @"increase stock price test");
    XCTAssertEqual(compC.stockPrice, 100, @"increase stock price test");
    
    [compA increaseStockPrice];
    [compB increaseStockPrice];
    [compC increaseStockPrice];

    XCTAssertEqual(compA.stockPrice,  90, @"increase stock price test");
    XCTAssertEqual(compB.stockPrice, 100, @"increase stock price test");
    XCTAssertEqual(compC.stockPrice, 110, @"increase stock price test");
}

@end
