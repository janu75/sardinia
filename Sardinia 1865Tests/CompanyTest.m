//
//  CompanyTest.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Company.h"
#import "Certificate.h"
#import "Player.h"

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
    compA = [[Company alloc] initWithName:@"FMS" IsMajor:NO];
    compB = [[Company alloc] initWithName:@"FCS" IsMajor:NO];
    compC = [[Company alloc] initWithName:@"SFS" IsMajor:YES];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testInit {
    NSArray *names = [NSArray arrayWithObjects:@"FMS", @"RCSF", @"SFSS", @"FCS", @"SFS", @"FA", @"CFC", @"CFD", nil];
    NSMutableArray *companies = [[NSMutableArray alloc] initWithCapacity:8];
    for (NSString *name in names) {
        [companies addObject:[[Company alloc] initWithName:name IsMajor:NO]];
    }
    
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
    int i=0;
    for (Company *comp in companies) {
        XCTAssertEqual(comp.isOperating, NO, @"Init test");
        XCTAssertEqual(comp.isFloating, NO, @"Init test");
        XCTAssertEqual(comp.isMajor, NO, @"Init test");

        XCTAssertEqual(comp.numStationMarkers, 3, @"Init test");
        XCTAssertEqual(comp.builtStations, 1, @"Init test");
        XCTAssertEqual(comp.traffic, 0, @"Init test");
        XCTAssertEqual(comp.trainCapacity, 0, @"Init test");
        XCTAssertEqual(comp.stockPrice, 0, @"Init test");
        
        XCTAssertEqualObjects(comp.name, longNames[names[i]], @"Init test");
        XCTAssertEqualObjects(comp.shortName, names[i], @"Init test");
        
        XCTAssertEqual([comp.trains count], (NSUInteger) 0, @"Init test");
        XCTAssertEqual([comp.maritimeCompanies count], (NSUInteger) 0, @"Init test");
        i++;
    }
}

- (void) testShareholderProtocol {
    [compA setInitialStockPrice:80];
    [compB setInitialStockPrice:90];
    [compC setInitialStockPrice:100];
    
    XCTAssertEqual(compA.money,  0, @"Shareholder Protocol test");
    XCTAssertEqual(compB.money,  0, @"Shareholder Protocol test");
    XCTAssertEqual(compC.money,  0, @"Shareholder Protocol test");
    
    XCTAssertEqual([compA.certificates count], (NSUInteger) 4, @"Shareholder Protocol test");
    XCTAssertEqual([compB.certificates count], (NSUInteger) 4, @"Shareholder Protocol test");
    XCTAssertEqual([compC.certificates count], (NSUInteger) 9, @"Shareholder Protocol test");
    
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
    
    XCTAssertEqual([compA.certificates count], (NSUInteger)  6, @"Shareholder Protocol test");
    XCTAssertEqual([compB.certificates count], (NSUInteger)  5, @"Shareholder Protocol test");
    XCTAssertEqual([compC.certificates count], (NSUInteger) 10, @"Shareholder Protocol test");

    [compA sellCertificate:certA];
    [compB sellCertificate:certB];
    [compC sellCertificate:certC];
    [compA sellCertificate:certD];

    XCTAssertEqual(compA.money,  3 *  80, @"Shareholder Protocol test");
    XCTAssertEqual(compB.money,  1 *  90, @"Shareholder Protocol test");
    XCTAssertEqual(compC.money,  2 * 100, @"Shareholder Protocol test");
    
    XCTAssertEqual([compA.certificates count], (NSUInteger) 4, @"Shareholder Protocol test");
    XCTAssertEqual([compB.certificates count], (NSUInteger) 4, @"Shareholder Protocol test");
    XCTAssertEqual([compC.certificates count], (NSUInteger) 9, @"Shareholder Protocol test");
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
    [compA setInitialStockPrice:80];
    [compB setInitialStockPrice:90];
    [compC setInitialStockPrice:100];

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
    [compA setInitialStockPrice:80];
    [compB setInitialStockPrice:90];
    [compC setInitialStockPrice:100];

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
    XCTAssertEqual(compA.trainCapacity, 0, @"Buy train test");
    XCTAssertEqual(compB.trainCapacity, 0, @"Buy train test");
    XCTAssertEqual(compC.trainCapacity, 0, @"Buy train test");
    
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
    XCTAssertEqual(compA.trainCapacity,  8, @"Buy train test");
    XCTAssertEqual(compB.trainCapacity, 14, @"Buy train test");
    XCTAssertEqual(compC.trainCapacity, 20, @"Buy train test");
    
    [compA sellTrain:trainA];
    [compB sellTrain:trainB ForMoney:70];
    [compC buyTrain:trainB ForMoney:70];
    
    XCTAssertEqual([compA.trains count], (NSUInteger) 0, @"Buy train test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 0, @"Buy train test");
    XCTAssertEqual([compC.trains count], (NSUInteger) 2, @"Buy train test");
    XCTAssertEqual(compA.money,  160, @"Buy train test");
    XCTAssertEqual(compB.money,   50, @"Buy train test");
    XCTAssertEqual(compC.money, -170, @"Buy train test");
    XCTAssertEqual(compA.trainCapacity,  0, @"Buy train test");
    XCTAssertEqual(compB.trainCapacity,  0, @"Buy train test");
    XCTAssertEqual(compC.trainCapacity, 34, @"Buy train test");
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
    [compA setInitialStockPrice:80];
    [compB setInitialStockPrice:90];
    [compC setInitialStockPrice:100];

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

- (void) testDecreaseStockPrice {
    [compA setInitialStockPrice:80];
    [compB setInitialStockPrice:90];
    [compC setInitialStockPrice:100];

    XCTAssertEqual(compA.stockPrice,  80, @"decrease stock price test");
    XCTAssertEqual(compB.stockPrice,  90, @"decrease stock price test");
    XCTAssertEqual(compC.stockPrice, 100, @"decrease stock price test");
    
    [compA decreaseStockPrice];
    [compB decreaseStockPrice];
    [compC decreaseStockPrice];
    
    XCTAssertEqual(compA.stockPrice,  70, @"decrease stock price test");
    XCTAssertEqual(compB.stockPrice,  80, @"decrease stock price test");
    XCTAssertEqual(compC.stockPrice,  90, @"decrease stock price test");
}

- (void) testOperateTrainsWithIncome {
    int moneyA=0;
    int moneyB=0;
    int moneyC=0;
    
    [compA setInitialStockPrice:80];
    [compB setInitialStockPrice:90];
    [compC setInitialStockPrice:100];

    XCTAssertEqual(compA.money, moneyA, @"operate trains test");
    XCTAssertEqual(compB.money, moneyB, @"operate trains test");
    XCTAssertEqual(compC.money, moneyC, @"operate trains test");
    XCTAssertEqual(compA.stockPrice,  80, @"operate trains test");
    XCTAssertEqual(compB.stockPrice,  90, @"operate trains test");
    XCTAssertEqual(compC.stockPrice, 100, @"operate trains test");

    [compA operateTrainsAndPayDividend:NO];
    [compB operateTrainsAndPayDividend:YES];
    [compC operateTrainsAndPayDividend:NO];
    
    // No change in money, as companies don't have trains or traffic yet
    XCTAssertEqual(compA.money, moneyA, @"operate trains test");
    XCTAssertEqual(compB.money, moneyB, @"operate trains test");
    XCTAssertEqual(compC.money, moneyC, @"operate trains test");
    XCTAssertEqual(compA.stockPrice,  80, @"operate trains test");
    XCTAssertEqual(compB.stockPrice,  90, @"operate trains test");
    XCTAssertEqual(compC.stockPrice, 100, @"operate trains test");
    
    Train *aTrain = [[Train alloc] initWithTech:2 AndDiscount:NO];
    
    [compA trafficUpgrade:5];
    [compB buyTrain:aTrain];                    moneyB -= 100;
    [compC buyTrain:aTrain];                    moneyC -= 100;
    [compA operateTrainsAndPayDividend:NO];
    [compB operateTrainsAndPayDividend:YES];
    [compC operateTrainsAndPayDividend:NO];
    
    // Comp A now drops in stock price, as it does have traffic, but no train
    XCTAssertEqual(compA.money, moneyA, @"operate trains test");
    XCTAssertEqual(compB.money, moneyB, @"operate trains test");
    XCTAssertEqual(compC.money, moneyC, @"operate trains test");
    XCTAssertEqual(compA.stockPrice,  70, @"operate trains test");
    XCTAssertEqual(compB.stockPrice,  90, @"operate trains test");
    XCTAssertEqual(compC.stockPrice, 100, @"operate trains test");

    [compA trafficUpgrade:5];
    [compB trafficUpgrade:6];
    [compC trafficUpgrade:7];
    [compA buyTrain:aTrain];                    moneyA -= 100;
    [compB buyTrain:aTrain];                    moneyB -= 100;
    [compC buyTrain:aTrain];                    moneyC -= 100;
    
    [compA operateTrainsAndPayDividend:NO];     moneyA +=  80;
    [compB operateTrainsAndPayDividend:YES];    moneyB +=  60;
    [compC operateTrainsAndPayDividend:NO];     moneyC +=  70;
    
    XCTAssertEqual(compA.money, moneyA, @"operate trains test");
    XCTAssertEqual(compB.money, moneyB, @"operate trains test");
    XCTAssertEqual(compC.money, moneyC, @"operate trains test");
    XCTAssertEqual(compA.stockPrice,  70, @"operate trains test");
    XCTAssertEqual(compB.stockPrice, 100, @"operate trains test");
    XCTAssertEqual(compC.stockPrice, 100, @"operate trains test");

    [compA sellCertificate:compA.certificates[0]];  moneyA += 2*70;
    [compA sellCertificate:compA.certificates[0]];  moneyA += 70;
    [compA operateTrainsAndPayDividend:YES];        moneyA += 80/5 * 2;
    [compB operateTrainsAndPayDividend:YES];        moneyB += 60;
    [compC operateTrainsAndPayDividend:NO];         moneyC += 70;
    
    XCTAssertEqual(compA.money, moneyA, @"operate trains test");
    XCTAssertEqual(compB.money, moneyB, @"operate trains test");
    XCTAssertEqual(compC.money, moneyC, @"operate trains test");
    XCTAssertEqual(compA.stockPrice,  80, @"operate trains test");
    XCTAssertEqual(compB.stockPrice, 110, @"operate trains test");
    XCTAssertEqual(compC.stockPrice, 100, @"operate trains test");

    [compA sellCertificate:compA.certificates[0]];  moneyA += 80;
    [compA sellCertificate:compA.certificates[0]];  moneyA += 80;
    [compB sellCertificate:compB.certificates[0]];  moneyB += 2*110;
    [compB sellCertificate:compB.certificates[0]];  moneyB += 110;
    [compC sellCertificate:compC.certificates[0]];  moneyC += 2*100;
    [compC sellCertificate:compC.certificates[0]];  moneyC += 100;
    [compA operateTrainsAndPayDividend:YES];
    [compB operateTrainsAndPayDividend:NO];         moneyB += 60;
    [compC operateTrainsAndPayDividend:YES];        moneyC += 70/10 * 7;
    
    XCTAssertEqual(compA.money, moneyA, @"operate trains test");
    XCTAssertEqual(compB.money, moneyB, @"operate trains test");
    XCTAssertEqual(compC.money, moneyC, @"operate trains test");
    XCTAssertEqual(compA.stockPrice,  90, @"operate trains test");
    XCTAssertEqual(compB.stockPrice, 110, @"operate trains test");
    XCTAssertEqual(compC.stockPrice, 110, @"operate trains test");
}

- (void) testCertificates {
    int count = 0;
    int countPresident = 0;
    int countMajor = 0;
    int countMinor = 0;
    for (Certificate *cert in compA.certificates) {
        count++;
        if ([cert.type rangeOfString:@"President"].location != NSNotFound) {
            countPresident++;
        }
        if ([cert.type rangeOfString:@"Minor"].location != NSNotFound) {
            countMinor++;
        }
        if ([cert.type rangeOfString:@"Major"].location != NSNotFound) {
            countMajor++;
        }
    }
    XCTAssertEqual(count, 4, @"Certificate test");
    XCTAssertEqual(countPresident, 1, @"Certificate test");
    XCTAssertEqual(countMajor, 0, @"Certificate test");
    XCTAssertEqual(countMinor, 4, @"Certificate test");
    
    [compA convertToMajorInPhase:6];
    
    count = 0;
    countPresident = 0;
    countMajor = 0;
    countMinor = 0;
    for (Certificate *cert in compA.certificates) {
        count++;
        if ([cert.type rangeOfString:@"President"].location != NSNotFound) {
            countPresident++;
        }
        if ([cert.type rangeOfString:@"Minor"].location != NSNotFound) {
            countMinor++;
        }
        if ([cert.type rangeOfString:@"Major"].location != NSNotFound) {
            countMajor++;
        }
    }
    XCTAssertEqual(count, 9, @"Certificate test");
    XCTAssertEqual(countPresident, 1, @"Certificate test");
    XCTAssertEqual(countMajor, 9, @"Certificate test");
    XCTAssertEqual(countMinor, 0, @"Certificate test");
}

@end
