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
#import "Bank.h"
#import "GameSettings.h"

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
    GameSettings *settings = [[GameSettings alloc] init];
    compA = [[Company alloc] initWithName:@"FMS" IsMajor:NO AndSettings:settings];
    compB = [[Company alloc] initWithName:@"FCS" IsMajor:NO AndSettings:settings];
    compC = [[Company alloc] initWithName:@"SFS" IsMajor:YES AndSettings:settings];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testInit {
    NSArray *names = [NSArray arrayWithObjects:@"FMS", @"RCSF", @"SFSS", @"FCS", @"SFS", @"FA", @"CFC", @"CFD", nil];
    NSMutableArray *companies = [[NSMutableArray alloc] initWithCapacity:8];
    GameSettings *settings = [[GameSettings alloc] init];
    for (NSString *name in names) {
        [companies addObject:[[Company alloc] initWithName:name IsMajor:NO AndSettings:settings]];
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
        
        XCTAssertEqual([comp.certificates count], (NSUInteger) 4, @"Init test");
        for (Certificate *cert in comp.certificates) {
            XCTAssertEqual(cert.owner, comp, @"Init test");
        }
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

    Player *aPlayer = [[Player alloc] init];
    
    [compA sellCertificate:certA To:aPlayer];
    [compB sellCertificate:certB To:aPlayer];
    [compC sellCertificate:certC To:aPlayer];
    [compA sellCertificate:certD To:aPlayer];

    XCTAssertEqual(compA.money,  3 *  80, @"Shareholder Protocol test");
    XCTAssertEqual(compB.money,  1 *  90, @"Shareholder Protocol test");
    XCTAssertEqual(compC.money,  2 * 100, @"Shareholder Protocol test");
    
    XCTAssertEqual([compA.certificates count], (NSUInteger)  6, @"Shareholder Protocol test");
    XCTAssertEqual([compB.certificates count], (NSUInteger)  5, @"Shareholder Protocol test");
    XCTAssertEqual([compC.certificates count], (NSUInteger) 10, @"Shareholder Protocol test");
}

- (void) testRank {
    XCTAssertEqual([compA rank], 1, @"Company rank test");
    XCTAssertEqual([compB rank], 1, @"Company rank test");
    XCTAssertEqual([compC rank], 1, @"Company rank test");
    
    Train *trainA = [[Train alloc] initWithTech:2 AndDiscount:NO];
    Train *trainB = [[Train alloc] initWithTech:4 AndDiscount:YES];
    
    [compA placeStationMarkerForCost:120];
    [compB buyTrain:trainA];
    [compB.trains addObject:trainA];
    [compC buyTrain:trainB];
    [compC.trains addObject:trainB];
    
    XCTAssertEqual([compA rank], 2, @"Company rank test");
    XCTAssertEqual([compB rank], 3, @"Company rank test");
    XCTAssertEqual([compC rank], 5, @"Company rank test");
}

- (void) testPlaceStaceMarker {
    [compA setInitialStockPrice:80];
    [compB setInitialStockPrice:90];
    [compC setInitialStockPrice:100];

    Player *aPlayer = [[Player alloc] init];
    
    Certificate *certA = [[Certificate alloc] initWithType:@"President Minor"];
    Certificate *certB = [[Certificate alloc] initWithType:@"President Minor"];
    Certificate *certC = [[Certificate alloc] initWithType:@"President Minor"];
    [compA equipCertificate:certA];
    [compB equipCertificate:certB];
    [compC equipCertificate:certC];
    [compA sellCertificate:certA To:aPlayer];
    [compB sellCertificate:certB To:aPlayer];
    [compC sellCertificate:certC To:aPlayer];
    [compA cleanFlagsForOperatingRound];
    [compB cleanFlagsForOperatingRound];
    [compC cleanFlagsForOperatingRound];
    
    XCTAssertEqual(compA.builtStations, 1, @"Place station marker test");
    XCTAssertEqual(compB.builtStations, 1, @"Place station marker test");
    XCTAssertEqual(compC.builtStations, 1, @"Place station marker test");
    XCTAssertEqual(compA.money, 160, @"Place station marker test");
    XCTAssertEqual(compB.money, 180, @"Place station marker test");
    XCTAssertEqual(compC.money, 200, @"Place station marker test");
    XCTAssertTrue(compA.canBuildStation, @"Place station marker test");
    XCTAssertTrue(compB.canBuildStation, @"Place station marker test");
    XCTAssertTrue(compC.canBuildStation, @"Place station marker test");
    
    [compA placeStationMarkerForCost:110];
    [compB placeStationMarkerForCost:70];
    [compA placeStationMarkerForCost:50];
    
    XCTAssertEqual(compA.builtStations, 3, @"Place station marker test");
    XCTAssertEqual(compB.builtStations, 2, @"Place station marker test");
    XCTAssertEqual(compC.builtStations, 1, @"Place station marker test");
    XCTAssertEqual(compA.money, 0, @"Place station marker test");
    XCTAssertEqual(compB.money, 110, @"Place station marker test");
    XCTAssertEqual(compC.money, 200, @"Place station marker test");
    XCTAssertTrue(!compA.canBuildStation, @"Place station marker test");
    XCTAssertTrue(!compB.canBuildStation, @"Place station marker test");
    XCTAssertTrue(compC.canBuildStation, @"Place station marker test");
}
 
- (void) testLayTrack {
    [compA cleanFlagsForOperatingRound];
    XCTAssertEqual(compA.money, 0, @"lay track test");
    XCTAssertTrue(!compA.canLay2ndTrack, @"lay track test");
    compA.money += 180;
    [compA cleanFlagsForOperatingRound];
    XCTAssertEqual(compA.money, 180, @"lay track test");
    XCTAssertTrue(compA.canLay2ndTrack, @"lay track test");
    [compA layExtraTrack];
    XCTAssertEqual(compA.money, 160, @"lay track test");
    XCTAssertTrue(!compA.canLay2ndTrack, @"lay track test");
    [compA layExtraTrack];
    XCTAssertEqual(compA.money, 140, @"lay track test");
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
    for (Company *comp in @[compA, compB, compC]) {
        if (comp.traffic>0 && comp.lastIncome == 0) {
            [comp decreaseStockPrice];
        }
        if (comp.boughtBrandNewTrain) {
            [comp increaseStockPrice];
        }
        if (comp.paidDividend) {
            [comp increaseStockPrice];
        }
        [comp cleanFlagsForOperatingRound];
    }
    
    // No change in money, as companies don't have trains or traffic yet
    XCTAssertEqual(compA.money, moneyA, @"operate trains test");
    XCTAssertEqual(compB.money, moneyB, @"operate trains test");
    XCTAssertEqual(compC.money, moneyC, @"operate trains test");
    XCTAssertEqual(compA.stockPrice,  80, @"operate trains test");
    XCTAssertEqual(compB.stockPrice,  90, @"operate trains test");
    XCTAssertEqual(compC.stockPrice, 100, @"operate trains test");
    
    Train *trainA = [[Train alloc] initWithTech:2 AndDiscount:NO];
    Train *trainB = [[Train alloc] initWithTech:2 AndDiscount:NO];
    Train *trainC = [[Train alloc] initWithTech:2 AndDiscount:NO];
    Train *trainD = [[Train alloc] initWithTech:2 AndDiscount:NO];
    Train *trainE = [[Train alloc] initWithTech:2 AndDiscount:NO];
    
    [compA trafficUpgrade:5];
    [compB buyTrain:trainA];                    // moneyB -= 100;
    [compB.trains addObject:trainA];
    [compC buyTrain:trainB];                    // moneyC -= 100;
    [compC.trains addObject:trainB];
    [compA operateTrainsAndPayDividend:NO];
    [compB operateTrainsAndPayDividend:YES];
    [compC operateTrainsAndPayDividend:NO];
    for (Company *comp in @[compA, compB, compC]) {
        if (comp.traffic>0 && comp.lastIncome == 0) {
            [comp decreaseStockPrice];
        }
        if (comp.boughtBrandNewTrain) {
            [comp increaseStockPrice];
        }
        if (comp.paidDividend) {
            [comp increaseStockPrice];
        }
        [comp cleanFlagsForOperatingRound];
    }
    
    // Comp A now drops in stock price, as it does have traffic, but no train
    XCTAssertEqual(compA.money, moneyA, @"operate trains test");
    XCTAssertEqual(compB.money, moneyB, @"operate trains test");
    XCTAssertEqual(compC.money, moneyC, @"operate trains test");
    XCTAssertEqual(compA.stockPrice,  70, @"operate trains test");
    XCTAssertEqual(compB.stockPrice, 100, @"operate trains test");
    XCTAssertEqual(compC.stockPrice, 110, @"operate trains test");

    [compA trafficUpgrade:5];
    [compB trafficUpgrade:6];
    [compC trafficUpgrade:7];
    [compA buyTrain:trainC];                    // moneyA -= 100;
    [compA.trains addObject:trainC];
    [compB buyTrain:trainD];                    // moneyB -= 100;
    [compB.trains addObject:trainD];
    [compC buyTrain:trainE];                    // moneyC -= 100;
    [compC.trains addObject:trainE];
    
    [compA operateTrainsAndPayDividend:NO];     moneyA +=  80;
    [compB operateTrainsAndPayDividend:YES];    moneyB +=  60;
    [compC operateTrainsAndPayDividend:NO];     moneyC +=  70;
    for (Company *comp in @[compA, compB, compC]) {
        if (comp.traffic>0 && comp.lastIncome == 0) {
            [comp decreaseStockPrice];
        }
        if (comp.boughtBrandNewTrain) {
            [comp increaseStockPrice];
        }
        if (comp.paidDividend) {
            [comp increaseStockPrice];
        }
        [comp cleanFlagsForOperatingRound];
    }
    
    XCTAssertEqual(compA.money, moneyA, @"operate trains test");
    XCTAssertEqual(compB.money, moneyB, @"operate trains test");
    XCTAssertEqual(compC.money, moneyC, @"operate trains test");
    XCTAssertEqual(compA.stockPrice,  80, @"operate trains test");
    XCTAssertEqual(compB.stockPrice, 120, @"operate trains test");
    XCTAssertEqual(compC.stockPrice, 120, @"operate trains test");

    Player *aPlayer = [[Player alloc] initWithName:@"Paul" AndMoney:0];
    int moneyPlayer = 0;
    
    [compA sellCertificate:compA.certificates[0] To:aPlayer];  moneyA += 2*80;  moneyPlayer -= 2*80;
    [compA sellCertificate:compA.certificates[1] To:aPlayer];  moneyA += 80;    moneyPlayer -= 80;
    [compA operateTrainsAndPayDividend:YES];        moneyA += 80/5 * 2;         moneyPlayer += 80/5 * 3;
    [compB operateTrainsAndPayDividend:YES];        moneyB += 60;
    [compC operateTrainsAndPayDividend:NO];         moneyC += 70;
    for (Company *comp in @[compA, compB, compC]) {
        if (comp.traffic>0 && comp.lastIncome == 0) {
            [comp decreaseStockPrice];
        }
        if (comp.boughtBrandNewTrain) {
            [comp increaseStockPrice];
        }
        if (comp.paidDividend) {
            [comp increaseStockPrice];
        }
        [comp cleanFlagsForOperatingRound];
    }
    
    XCTAssertEqual(compA.money, moneyA, @"operate trains test");
    XCTAssertEqual(compB.money, moneyB, @"operate trains test");
    XCTAssertEqual(compC.money, moneyC, @"operate trains test");
    XCTAssertEqual(aPlayer.money, moneyPlayer, @"operate trains test");
    XCTAssertEqual(compA.stockPrice,  90, @"operate trains test");
    XCTAssertEqual(compB.stockPrice, 130, @"operate trains test");
    XCTAssertEqual(compC.stockPrice, 120, @"operate trains test");

    [compA sellCertificate:compA.certificates[2] To:aPlayer];  moneyA += 90;    moneyPlayer -= 90;
    [compA sellCertificate:compA.certificates[3] To:aPlayer];  moneyA += 90;    moneyPlayer -= 90;
    [compB sellCertificate:compB.certificates[0] To:aPlayer];  moneyB += 2*130; moneyPlayer -= 2*130;
    [compB sellCertificate:compB.certificates[1] To:aPlayer];  moneyB += 130;   moneyPlayer -= 130;
    [compC sellCertificate:compC.certificates[0] To:aPlayer];  moneyC += 2*120; moneyPlayer -= 2*120;
    [compC sellCertificate:compC.certificates[1] To:aPlayer];  moneyC += 120;   moneyPlayer -= 120;
    [compA operateTrainsAndPayDividend:YES];                                    moneyPlayer += 80;
    [compB operateTrainsAndPayDividend:NO];         moneyB += 60;
    [compC operateTrainsAndPayDividend:YES];        moneyC += 70/10 * 7;        moneyPlayer += 70/10 * 3;
    for (Company *comp in @[compA, compB, compC]) {
        if (comp.traffic>0 && comp.lastIncome == 0) {
            [comp decreaseStockPrice];
        }
        if (comp.boughtBrandNewTrain) {
            [comp increaseStockPrice];
        }
        if (comp.paidDividend) {
            [comp increaseStockPrice];
        }
        [comp cleanFlagsForOperatingRound];
    }
    
    XCTAssertEqual(compA.money, moneyA, @"operate trains test");
    XCTAssertEqual(compB.money, moneyB, @"operate trains test");
    XCTAssertEqual(compC.money, moneyC, @"operate trains test");
    XCTAssertEqual(aPlayer.money, moneyPlayer, @"operate trains test");
    XCTAssertEqual(compA.stockPrice, 100, @"operate trains test");
    XCTAssertEqual(compB.stockPrice, 130, @"operate trains test");
    XCTAssertEqual(compC.stockPrice, 130, @"operate trains test");
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

- (void) testFlags {
    XCTAssertEqual(compA.isOperating, NO, @"Flags test");
    XCTAssertEqual(compB.isOperating, NO, @"Flags test");
    XCTAssertEqual(compC.isOperating, NO, @"Flags test");
    XCTAssertEqual(compA.isFloating, NO, @"Flags test");
    XCTAssertEqual(compB.isFloating, NO, @"Flags test");
    XCTAssertEqual(compC.isFloating, NO, @"Flags test");
    XCTAssertEqual(compA.isMajor, NO, @"Flags test");
    XCTAssertEqual(compB.isMajor, NO, @"Flags test");
    XCTAssertEqual(compC.isMajor, YES, @"Flags test");
    
    [compA operateTrainsAndPayDividend:YES];
    [compB operateTrainsAndPayDividend:YES];
    [compC operateTrainsAndPayDividend:YES];

    XCTAssertEqual(compA.isOperating, YES, @"Flags test");
    XCTAssertEqual(compB.isOperating, YES, @"Flags test");
    XCTAssertEqual(compC.isOperating, YES, @"Flags test");
    XCTAssertEqual(compA.isFloating, NO, @"Flags test");
    XCTAssertEqual(compB.isFloating, NO, @"Flags test");
    XCTAssertEqual(compC.isFloating, NO, @"Flags test");
    XCTAssertEqual(compA.isMajor, NO, @"Flags test");
    XCTAssertEqual(compB.isMajor, NO, @"Flags test");
    XCTAssertEqual(compC.isMajor, YES, @"Flags test");
    
    Train *aTrain = [[Train alloc] initWithTech:3 AndDiscount:NO];
    [compA buyTrain:aTrain];
    [compA trafficUpgrade:5];

    [compA operateTrainsAndPayDividend:NO];
    [compB operateTrainsAndPayDividend:NO];
    [compC operateTrainsAndPayDividend:NO];
    
    XCTAssertEqual(compA.isOperating, YES, @"Flags test");
    XCTAssertEqual(compB.isOperating, YES, @"Flags test");
    XCTAssertEqual(compC.isOperating, YES, @"Flags test");
    XCTAssertEqual(compA.isFloating, NO, @"Flags test");
    XCTAssertEqual(compB.isFloating, NO, @"Flags test");
    XCTAssertEqual(compC.isFloating, NO, @"Flags test");
    XCTAssertEqual(compA.isMajor, NO, @"Flags test");
    XCTAssertEqual(compB.isMajor, NO, @"Flags test");
    XCTAssertEqual(compC.isMajor, YES, @"Flags test");

    Player *aPlayer = [[Player alloc] init];

    [compB sellCertificate:compB.certificates[0] To:aPlayer];
    [compB sellCertificate:compB.certificates[1] To:aPlayer];
    [compC sellCertificate:compB.certificates[0] To:aPlayer];
    [compC sellCertificate:compB.certificates[1] To:aPlayer];

    XCTAssertEqual(compA.isOperating, YES, @"Flags test");
    XCTAssertEqual(compB.isOperating, YES, @"Flags test");
    XCTAssertEqual(compC.isOperating, YES, @"Flags test");
    XCTAssertEqual(compA.isFloating, NO, @"Flags test");
    XCTAssertEqual(compB.isFloating, YES, @"Flags test");
    XCTAssertEqual(compC.isFloating, NO, @"Flags test");
    XCTAssertEqual(compA.isMajor, NO, @"Flags test");
    XCTAssertEqual(compB.isMajor, NO, @"Flags test");
    XCTAssertEqual(compC.isMajor, YES, @"Flags test");
    XCTAssertEqual(compA.numStationMarkers, 3, @"Flags test");
    XCTAssertEqual(compB.numStationMarkers, 3, @"Flags test");
    XCTAssertEqual(compC.numStationMarkers, 7, @"Flags test");
    
    [compA convertToMajorInPhase:3];
    [compB convertToMajorInPhase:4];
    
    XCTAssertEqual(compA.isOperating, YES, @"Flags test");
    XCTAssertEqual(compB.isOperating, YES, @"Flags test");
    XCTAssertEqual(compC.isOperating, YES, @"Flags test");
    XCTAssertEqual(compA.isFloating, NO, @"Flags test");
    XCTAssertEqual(compB.isFloating, YES, @"Flags test");
    XCTAssertEqual(compC.isFloating, NO, @"Flags test");
    XCTAssertEqual(compA.isMajor, YES, @"Flags test");
    XCTAssertEqual(compB.isMajor, YES, @"Flags test");
    XCTAssertEqual(compC.isMajor, YES, @"Flags test");
    XCTAssertEqual(compA.numStationMarkers, 5, @"Flags test");
    XCTAssertEqual(compB.numStationMarkers, 6, @"Flags test");
    XCTAssertEqual(compC.numStationMarkers, 7, @"Flags test");
}

- (void) testUpdatePresident {
    Player *playerA = [[Player alloc] initWithName:@"Peter" AndMoney:300];
    Player *playerB = [[Player alloc] initWithName:@"Paul" AndMoney:300];
    Player *playerC = [[Player alloc] initWithName:@"Günther" AndMoney:300];
    Player *playerD = [[Player alloc] initWithName:@"Rudi" AndMoney:300];
    
    XCTAssertNil(compA.president, @"update president test");
    XCTAssertNil(compB.president, @"update president test");
    XCTAssertNil(compC.president, @"update president test");
    
    [compA sellCertificate:compA.certificates[0] To:playerA];
    [compA sellCertificate:compA.certificates[1] To:playerB];
    [compA sellCertificate:compA.certificates[2] To:playerC];
    [compA sellCertificate:compA.certificates[3] To:playerD];
    [compA updatePresident];

    XCTAssertEqualObjects(compA.president, playerA, @"update president test");
    XCTAssertNil(compB.president, @"update president test");
    XCTAssertNil(compC.president, @"update president test");
    
    [compB sellCertificate:compB.certificates[0] To:playerD];
    [compB sellCertificate:compB.certificates[1] To:playerA];
    [compB sellCertificate:compB.certificates[2] To:playerB];
    [compB sellCertificate:compB.certificates[3] To:playerC];
    [compB updatePresident];
    
    XCTAssertEqualObjects(compA.president, playerA, @"update president test");
    XCTAssertEqualObjects(compB.president, playerD, @"update president test");
    XCTAssertNil(compC.president, @"update president test");

    Bank *bank = [[Bank alloc] initWithName:@"Bank"];
    [compB sellCertificate:compB.certificates[1] To:bank];
    [compB sellCertificate:compB.certificates[2] To:bank];

    [compB sellCertificate:compB.certificates[1] To:playerC];
    [compB sellCertificate:compB.certificates[2] To:playerC];
    [compB updatePresident];

    XCTAssertEqualObjects(compA.president, playerA, @"update president test");
    XCTAssertEqualObjects(compB.president, playerC, @"update president test");
    XCTAssertNil(compC.president, @"update president test");
}

- (void) testCleanFlagsForOperatingRound {
    compA.money = 180;
    [compA cleanFlagsForOperatingRound];
    XCTAssertFalse(compA.didOperateThisTurn, @"Clean flags test");
    XCTAssertTrue(compA.canLay2ndTrack, @"Clean flags test");
    XCTAssertTrue(compA.canBuildStation, @"Clean flags test");
    XCTAssertFalse(compA.boughtBrandNewTrain, @"Clean flags test");
    XCTAssertFalse(compA.paidDividend, @"Clean flags test");
    
    [compA operateTrainsAndPayDividend:NO];
    XCTAssertTrue(compA.didOperateThisTurn, @"Clean flags test");
    XCTAssertFalse(compA.canLay2ndTrack, @"Clean flags test");
    XCTAssertFalse(compA.canBuildStation, @"Clean flags test");
    XCTAssertFalse(compA.boughtBrandNewTrain, @"Clean flags test");
    XCTAssertFalse(compA.paidDividend, @"Clean flags test");

    [compA cleanFlagsForOperatingRound];
    compA.traffic = 5;
    [compA operateTrainsAndPayDividend:NO];
    XCTAssertTrue(compA.didOperateThisTurn, @"Clean flags test");
    XCTAssertFalse(compA.canLay2ndTrack, @"Clean flags test");
    XCTAssertFalse(compA.canBuildStation, @"Clean flags test");
    XCTAssertFalse(compA.boughtBrandNewTrain, @"Clean flags test");
    XCTAssertFalse(compA.paidDividend, @"Clean flags test");
    
    Train *train = [[Train alloc] initWithTech:2 AndDiscount:NO];
    [compA cleanFlagsForOperatingRound];
    [compA buyTrain:train];
    XCTAssertFalse(compA.didOperateThisTurn, @"Clean flags test");
    XCTAssertTrue(compA.canLay2ndTrack, @"Clean flags test");
    XCTAssertTrue(compA.canBuildStation, @"Clean flags test");
    XCTAssertTrue(compA.boughtBrandNewTrain, @"Clean flags test");
    XCTAssertFalse(compA.paidDividend, @"Clean flags test");

    [compA cleanFlagsForOperatingRound];
    [compA operateTrainsAndPayDividend:NO];
    XCTAssertTrue(compA.didOperateThisTurn, @"Clean flags test");
    XCTAssertFalse(compA.canLay2ndTrack, @"Clean flags test");
    XCTAssertFalse(compA.canBuildStation, @"Clean flags test");
    XCTAssertFalse(compA.boughtBrandNewTrain, @"Clean flags test");
    XCTAssertFalse(compA.paidDividend, @"Clean flags test");

    [compA cleanFlagsForOperatingRound];
    [compA operateTrainsAndPayDividend:YES];
    XCTAssertTrue(compA.didOperateThisTurn, @"Clean flags test");
    XCTAssertFalse(compA.canLay2ndTrack, @"Clean flags test");
    XCTAssertFalse(compA.canBuildStation, @"Clean flags test");
    XCTAssertFalse(compA.boughtBrandNewTrain, @"Clean flags test");
    XCTAssertTrue(compA.paidDividend, @"Clean flags test");

    [compA cleanFlagsForOperatingRound];
    [compA layExtraTrack];
    XCTAssertFalse(compA.didOperateThisTurn, @"Clean flags test");
    XCTAssertFalse(compA.canLay2ndTrack, @"Clean flags test");
    XCTAssertTrue(compA.canBuildStation, @"Clean flags test");
    XCTAssertFalse(compA.boughtBrandNewTrain, @"Clean flags test");
    XCTAssertFalse(compA.paidDividend, @"Clean flags test");
    
    [compA cleanFlagsForOperatingRound];
    [compA placeStationMarkerForCost:10];
    XCTAssertFalse(compA.didOperateThisTurn, @"Clean flags test");
    XCTAssertFalse(compA.canLay2ndTrack, @"Clean flags test");
    XCTAssertFalse(compA.canBuildStation, @"Clean flags test");
    XCTAssertFalse(compA.boughtBrandNewTrain, @"Clean flags test");
    XCTAssertFalse(compA.paidDividend, @"Clean flags test");
}

- (void) testCompanyActions {
    compA.money = 1000;
    Train *trainA = [[Train alloc] initWithTech:2 AndDiscount:NO];
    Train *trainB = [[Train alloc] initWithTech:2 AndDiscount:NO];
    Player *playerA = [[Player alloc] initWithName:@"Paul" AndMoney:330];
    int moneyA = compA.money;
    [compA setInitialStockPrice:100];
    [compA sellCertificate:compA.certificates[0] To:playerA];   moneyA += 2*100;
    [compA sellCertificate:compA.certificates[1] To:playerA];   moneyA += 100;
    [compA cleanFlagsForOperatingRound];
    
    XCTAssertEqual(compA.isOperating, NO, @"company action tests");
    XCTAssertEqual(compA.isFloating, YES, @"company action tests");
    XCTAssertEqual(compA.isMajor, NO, @"company action tests");
    XCTAssertEqual(compA.didOperateThisTurn, NO, @"company action tests");
    XCTAssertEqual(compA.canLay2ndTrack, YES, @"company action tests");
    XCTAssertEqual(compA.canBuildStation, YES, @"company action tests");
    XCTAssertEqual(compA.boughtBrandNewTrain, NO, @"company action tests");
    XCTAssertEqual(compA.paidDividend, NO, @"company action tests");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"company action tests");
    XCTAssertEqual(compA.numStationMarkers, 3, @"company action tests");
    XCTAssertEqual(compA.builtStations, 1, @"company action tests");
    XCTAssertEqual(compA.traffic, 0, @"company action tests");
    XCTAssertEqual(compA.trainCapacity, 0, @"company action tests");
    XCTAssertEqual(compA.money, moneyA, @"company action tests");
    XCTAssertEqual(compA.lastIncome, 0, @"company action tests");
    
    [compA layExtraTrack];      moneyA -= 20;

    XCTAssertEqual(compA.isOperating, NO, @"company action tests");
    XCTAssertEqual(compA.isFloating, YES, @"company action tests");
    XCTAssertEqual(compA.isMajor, NO, @"company action tests");
    XCTAssertEqual(compA.didOperateThisTurn, NO, @"company action tests");
    XCTAssertEqual(compA.canLay2ndTrack, NO, @"company action tests");
    XCTAssertEqual(compA.canBuildStation, YES, @"company action tests");
    XCTAssertEqual(compA.boughtBrandNewTrain, NO, @"company action tests");
    XCTAssertEqual(compA.paidDividend, NO, @"company action tests");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"company action tests");
    XCTAssertEqual(compA.numStationMarkers, 3, @"company action tests");
    XCTAssertEqual(compA.builtStations, 1, @"company action tests");
    XCTAssertEqual(compA.traffic, 0, @"company action tests");
    XCTAssertEqual(compA.trainCapacity, 0, @"company action tests");
    XCTAssertEqual(compA.money, moneyA, @"company action tests");
    XCTAssertEqual(compA.lastIncome, 0, @"company action tests");

    [compA placeStationMarkerForCost:110];      moneyA -= 110;

    XCTAssertEqual(compA.isOperating, NO, @"company action tests");
    XCTAssertEqual(compA.isFloating, YES, @"company action tests");
    XCTAssertEqual(compA.isMajor, NO, @"company action tests");
    XCTAssertEqual(compA.didOperateThisTurn, NO, @"company action tests");
    XCTAssertEqual(compA.canLay2ndTrack, NO, @"company action tests");
    XCTAssertEqual(compA.canBuildStation, NO, @"company action tests");
    XCTAssertEqual(compA.boughtBrandNewTrain, NO, @"company action tests");
    XCTAssertEqual(compA.paidDividend, NO, @"company action tests");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"company action tests");
    XCTAssertEqual(compA.numStationMarkers, 3, @"company action tests");
    XCTAssertEqual(compA.builtStations, 2, @"company action tests");
    XCTAssertEqual(compA.traffic, 0, @"company action tests");
    XCTAssertEqual(compA.trainCapacity, 0, @"company action tests");
    XCTAssertEqual(compA.money, moneyA, @"company action tests");
    XCTAssertEqual(compA.lastIncome, 0, @"company action tests");
    
    [compA trafficUpgrade:7];
    
    XCTAssertEqual(compA.isOperating, NO, @"company action tests");
    XCTAssertEqual(compA.isFloating, YES, @"company action tests");
    XCTAssertEqual(compA.isMajor, NO, @"company action tests");
    XCTAssertEqual(compA.didOperateThisTurn, NO, @"company action tests");
    XCTAssertEqual(compA.canLay2ndTrack, NO, @"company action tests");
    XCTAssertEqual(compA.canBuildStation, NO, @"company action tests");
    XCTAssertEqual(compA.boughtBrandNewTrain, NO, @"company action tests");
    XCTAssertEqual(compA.paidDividend, NO, @"company action tests");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"company action tests");
    XCTAssertEqual(compA.numStationMarkers, 3, @"company action tests");
    XCTAssertEqual(compA.builtStations, 2, @"company action tests");
    XCTAssertEqual(compA.traffic, 7, @"company action tests");
    XCTAssertEqual(compA.trainCapacity, 0, @"company action tests");
    XCTAssertEqual(compA.money, moneyA, @"company action tests");
    XCTAssertEqual(compA.lastIncome, 0, @"company action tests");
    
    [compA operateTrainsAndPayDividend:YES];
    
    XCTAssertEqual(compA.isOperating, YES, @"company action tests");
    XCTAssertEqual(compA.isFloating, YES, @"company action tests");
    XCTAssertEqual(compA.isMajor, NO, @"company action tests");
    XCTAssertEqual(compA.didOperateThisTurn, YES, @"company action tests");
    XCTAssertEqual(compA.canLay2ndTrack, NO, @"company action tests");
    XCTAssertEqual(compA.canBuildStation, NO, @"company action tests");
    XCTAssertEqual(compA.boughtBrandNewTrain, NO, @"company action tests");
    XCTAssertEqual(compA.paidDividend, NO, @"company action tests");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"company action tests");
    XCTAssertEqual(compA.numStationMarkers, 3, @"company action tests");
    XCTAssertEqual(compA.builtStations, 2, @"company action tests");
    XCTAssertEqual(compA.traffic, 7, @"company action tests");
    XCTAssertEqual(compA.trainCapacity, 0, @"company action tests");
    XCTAssertEqual(compA.money, moneyA, @"company action tests");
    XCTAssertEqual(compA.lastIncome, 0, @"company action tests");
    
    [compA buyTrain:trainA];            // moneyA -= 100;
    
    XCTAssertEqual(compA.isOperating, YES, @"company action tests");
    XCTAssertEqual(compA.isFloating, YES, @"company action tests");
    XCTAssertEqual(compA.isMajor, NO, @"company action tests");
    XCTAssertEqual(compA.didOperateThisTurn, YES, @"company action tests");
    XCTAssertEqual(compA.canLay2ndTrack, NO, @"company action tests");
    XCTAssertEqual(compA.canBuildStation, NO, @"company action tests");
    XCTAssertEqual(compA.boughtBrandNewTrain, YES, @"company action tests");
    XCTAssertEqual(compA.paidDividend, NO, @"company action tests");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"company action tests");
    XCTAssertEqual(compA.numStationMarkers, 3, @"company action tests");
    XCTAssertEqual(compA.builtStations, 2, @"company action tests");
    XCTAssertEqual(compA.traffic, 7, @"company action tests");
    XCTAssertEqual(compA.trainCapacity, 8, @"company action tests");
    XCTAssertEqual(compA.money, moneyA, @"company action tests");
    XCTAssertEqual(compA.lastIncome, 0, @"company action tests");
    
    // Now do the same in reverse order to check locking earlier actions
    [compA cleanFlagsForOperatingRound];
    XCTAssertEqual(compA.isOperating, YES, @"company action tests");
    XCTAssertEqual(compA.isFloating, YES, @"company action tests");
    XCTAssertEqual(compA.isMajor, NO, @"company action tests");
    XCTAssertEqual(compA.didOperateThisTurn, NO, @"company action tests");
    XCTAssertEqual(compA.canLay2ndTrack, YES, @"company action tests");
    XCTAssertEqual(compA.canBuildStation, YES, @"company action tests");
    XCTAssertEqual(compA.boughtBrandNewTrain, NO, @"company action tests");
    XCTAssertEqual(compA.paidDividend, NO, @"company action tests");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"company action tests");
    XCTAssertEqual(compA.numStationMarkers, 3, @"company action tests");
    XCTAssertEqual(compA.builtStations, 2, @"company action tests");
    XCTAssertEqual(compA.traffic, 7, @"company action tests");
    XCTAssertEqual(compA.trainCapacity, 8, @"company action tests");
    XCTAssertEqual(compA.money, moneyA, @"company action tests");
    XCTAssertEqual(compA.lastIncome, 0, @"company action tests");
    
    [compA buyTrain:trainB];            // moneyA -= 100;

    // Buying a train does not block earlier actions, 'Operate trains' does, which is required to enable the buy trains button
    XCTAssertEqual(compA.isOperating, YES, @"company action tests");
    XCTAssertEqual(compA.isFloating, YES, @"company action tests");
    XCTAssertEqual(compA.isMajor, NO, @"company action tests");
    XCTAssertEqual(compA.didOperateThisTurn, NO, @"company action tests");
    XCTAssertEqual(compA.canLay2ndTrack, YES, @"company action tests");
    XCTAssertEqual(compA.canBuildStation, YES, @"company action tests");
    XCTAssertEqual(compA.boughtBrandNewTrain, YES, @"company action tests");
    XCTAssertEqual(compA.paidDividend, NO, @"company action tests");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"company action tests");
    XCTAssertEqual(compA.numStationMarkers, 3, @"company action tests");
    XCTAssertEqual(compA.builtStations, 2, @"company action tests");
    XCTAssertEqual(compA.traffic, 7, @"company action tests");
    XCTAssertEqual(compA.trainCapacity, 16, @"company action tests");
    XCTAssertEqual(compA.money, moneyA, @"company action tests");
    XCTAssertEqual(compA.lastIncome, 0, @"company action tests");
    
    [compA cleanFlagsForOperatingRound];
    [compA operateTrainsAndPayDividend:YES];    moneyA += 4 * 7;
    XCTAssertEqual(compA.isOperating, YES, @"company action tests");
    XCTAssertEqual(compA.isFloating, YES, @"company action tests");
    XCTAssertEqual(compA.isMajor, NO, @"company action tests");
    XCTAssertEqual(compA.didOperateThisTurn, YES, @"company action tests");
    XCTAssertEqual(compA.canLay2ndTrack, NO, @"company action tests");
    XCTAssertEqual(compA.canBuildStation, NO, @"company action tests");
    XCTAssertEqual(compA.boughtBrandNewTrain, NO, @"company action tests");
    XCTAssertEqual(compA.paidDividend, YES, @"company action tests");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"company action tests");
    XCTAssertEqual(compA.numStationMarkers, 3, @"company action tests");
    XCTAssertEqual(compA.builtStations, 2, @"company action tests");
    XCTAssertEqual(compA.traffic, 7, @"company action tests");
    XCTAssertEqual(compA.trainCapacity, 16, @"company action tests");
    XCTAssertEqual(compA.money, moneyA, @"company action tests");
    XCTAssertEqual(compA.lastIncome, 70, @"company action tests");

    [compA cleanFlagsForOperatingRound];
    [compA trafficUpgrade:8];
    // Traffic upgrade does not block anything for convenience reasons
    XCTAssertEqual(compA.isOperating, YES, @"company action tests");
    XCTAssertEqual(compA.isFloating, YES, @"company action tests");
    XCTAssertEqual(compA.isMajor, NO, @"company action tests");
    XCTAssertEqual(compA.didOperateThisTurn, NO, @"company action tests");
    XCTAssertEqual(compA.canLay2ndTrack, YES, @"company action tests");
    XCTAssertEqual(compA.canBuildStation, YES, @"company action tests");
    XCTAssertEqual(compA.boughtBrandNewTrain, NO, @"company action tests");
    XCTAssertEqual(compA.paidDividend, NO, @"company action tests");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"company action tests");
    XCTAssertEqual(compA.numStationMarkers, 3, @"company action tests");
    XCTAssertEqual(compA.builtStations, 2, @"company action tests");
    XCTAssertEqual(compA.traffic, 15, @"company action tests");
    XCTAssertEqual(compA.trainCapacity, 16, @"company action tests");
    XCTAssertEqual(compA.money, moneyA, @"company action tests");
    XCTAssertEqual(compA.lastIncome, 70, @"company action tests");

    [compA cleanFlagsForOperatingRound];
    [compA placeStationMarkerForCost:40];       moneyA -= 40;
    XCTAssertEqual(compA.isOperating, YES, @"company action tests");
    XCTAssertEqual(compA.isFloating, YES, @"company action tests");
    XCTAssertEqual(compA.isMajor, NO, @"company action tests");
    XCTAssertEqual(compA.didOperateThisTurn, NO, @"company action tests");
    XCTAssertEqual(compA.canLay2ndTrack, NO, @"company action tests");
    XCTAssertEqual(compA.canBuildStation, NO, @"company action tests");
    XCTAssertEqual(compA.boughtBrandNewTrain, NO, @"company action tests");
    XCTAssertEqual(compA.paidDividend, NO, @"company action tests");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"company action tests");
    XCTAssertEqual(compA.numStationMarkers, 3, @"company action tests");
    XCTAssertEqual(compA.builtStations, 3, @"company action tests");
    XCTAssertEqual(compA.traffic, 15, @"company action tests");
    XCTAssertEqual(compA.trainCapacity, 16, @"company action tests");
    XCTAssertEqual(compA.money, moneyA, @"company action tests");
    XCTAssertEqual(compA.lastIncome, 70, @"company action tests");

    [compA cleanFlagsForOperatingRound];
    [compA layExtraTrack];                      moneyA -= 20;
    XCTAssertEqual(compA.isOperating, YES, @"company action tests");
    XCTAssertEqual(compA.isFloating, YES, @"company action tests");
    XCTAssertEqual(compA.isMajor, NO, @"company action tests");
    XCTAssertEqual(compA.didOperateThisTurn, NO, @"company action tests");
    XCTAssertEqual(compA.canLay2ndTrack, NO, @"company action tests");
    XCTAssertEqual(compA.canBuildStation, YES, @"company action tests");
    XCTAssertEqual(compA.boughtBrandNewTrain, NO, @"company action tests");
    XCTAssertEqual(compA.paidDividend, NO, @"company action tests");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"company action tests");
    XCTAssertEqual(compA.numStationMarkers, 3, @"company action tests");
    XCTAssertEqual(compA.builtStations, 3, @"company action tests");
    XCTAssertEqual(compA.traffic, 15, @"company action tests");
    XCTAssertEqual(compA.trainCapacity, 16, @"company action tests");
    XCTAssertEqual(compA.money, moneyA, @"company action tests");
    XCTAssertEqual(compA.lastIncome, 70, @"company action tests");
}

- (void) testOperateTrains {
}

- (void) testCoding {
    NSString *path = @"savetest-Company";
    XCTAssertTrue([NSKeyedArchiver archiveRootObject:compA toFile:path], @"coding test");
    
    Company *copyOfComp = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    XCTAssertNotEqualObjects(compA, copyOfComp, @"coding test");
    
    NSString *path2 = @"savetest-Company2";
    XCTAssertTrue([NSKeyedArchiver archiveRootObject:copyOfComp toFile:path2], @"coding test");
    
    Company *copy2 = [NSKeyedUnarchiver unarchiveObjectWithFile:path2];
    XCTAssertNotEqualObjects(compA, copy2, @"coding test");
}


@end
