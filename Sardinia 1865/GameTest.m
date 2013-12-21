//
//  GameTest.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 14/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Game.h"
#import "Bank.h"
#import "Dragon.h"
#import "Company.h"

@interface GameTest : XCTestCase

@end

@implementation GameTest

Game *game;

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    game = [[Game alloc] initWithPlayers:@[@"Piet", @"Hein", @"Günther", @"Paul"] AndShortMode:NO];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testInit {
    Game *gameA = [[Game alloc] initWithPlayers:@[@"PlayerA", @"PlayerB"] AndShortMode:YES];
    
    XCTAssertEqual([gameA.companies count],  (NSUInteger)6, @"Init test");
    for (Company *comp in gameA.companies) {
        XCTAssertFalse([comp.shortName isEqualToString:@"CFC"], @"Init test");
        XCTAssertFalse([comp.shortName isEqualToString:@"CFD"], @"Init test");
    }
    XCTAssertEqual([gameA.player count],     (NSUInteger)2, @"Init test");
    XCTAssertEqual([gameA.trains count], (NSUInteger)30, @"Init test");
    XCTAssertEqual(gameA.settings.numPlayers, 2, @"Init test");
    XCTAssertEqual(gameA.settings.isShortGame, YES, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"PlayerA" InPhase:2], 27, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"PlayerB" InPhase:2], 27, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Bank" InPhase:2], 1000, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:2], 6, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:3], 10, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:4], 10, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:5], 16, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:6], 16, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:7], 16, @"Init test");
    XCTAssertEqual(gameA.bank.name, @"Bank", @"Init test");
    XCTAssertEqual(gameA.bank.money, 6000 - 2*360, @"Init test");
    XCTAssertEqual(gameA.dragon.name, @"Dragon", @"Init test");
    XCTAssertEqual(gameA.currentPlayer.name, gameA.startPlayer.name, @"Init test");
    XCTAssertEqual([gameA.companyStack count], (NSUInteger)0, @"Init test");
    XCTAssertEqual([gameA.companyTurnOrder count], (NSUInteger)0, @"Init test");
    XCTAssertEqual(gameA.round, @"Stock Round", @"Init test");
    XCTAssertEqual(gameA.settings.phase, 2, @"Init test");
    XCTAssertEqual(gameA.passCount, 0, @"Init test");
    for (Player *player in gameA.player) {
        XCTAssertEqual(player.money, 360, @"Init test");
    }

    gameA = [[Game alloc] initWithPlayers:@[@"PlayerA", @"PlayerB", @"PlayerC"] AndShortMode:NO];
    
    XCTAssertEqual([gameA.companies count],  (NSUInteger)8, @"Init test");
    XCTAssertEqual([gameA.player count],     (NSUInteger)3, @"Init test");
    XCTAssertEqual([gameA.trains count], (NSUInteger)34, @"Init test");
    XCTAssertEqual(gameA.settings.numPlayers, 3, @"Init test");
    XCTAssertEqual(gameA.settings.isShortGame, NO, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"PlayerA" InPhase:2], 24, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"PlayerB" InPhase:2], 24, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"PlayerC" InPhase:2], 24, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Bank" InPhase:2], 1000, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:2], 6, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:3], 10, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:4], 10, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:5], 16, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:6], 16, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:7], 16, @"Init test");
    XCTAssertEqual(gameA.bank.name, @"Bank", @"Init test");
    XCTAssertEqual(gameA.bank.money, 8000 - 3*330, @"Init test");
    XCTAssertEqual(gameA.dragon.name, @"Dragon", @"Init test");
    XCTAssertEqual(gameA.currentPlayer.name, gameA.startPlayer.name, @"Init test");
    XCTAssertEqual([gameA.companyStack count], (NSUInteger)0, @"Init test");
    XCTAssertEqual([gameA.companyTurnOrder count], (NSUInteger)0, @"Init test");
    XCTAssertEqual(gameA.round, @"Stock Round", @"Init test");
    XCTAssertEqual(gameA.settings.phase, 2, @"Init test");
    XCTAssertEqual(gameA.passCount, 0, @"Init test");
    for (Player *player in gameA.player) {
        XCTAssertEqual(player.money, 330, @"Init test");
    }

    gameA = [[Game alloc] initWithPlayers:@[@"PlayerA", @"PlayerB", @"PlayerC", @"PlayerD"] AndShortMode:NO];
    
    XCTAssertEqual([gameA.companies count],  (NSUInteger)8, @"Init test");
    XCTAssertEqual([gameA.player count],     (NSUInteger)4, @"Init test");
    XCTAssertEqual([gameA.trains count], (NSUInteger)34, @"Init test");
    XCTAssertEqual(gameA.settings.numPlayers, 4, @"Init test");
    XCTAssertEqual(gameA.settings.isShortGame, NO, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"PlayerA" InPhase:2], 18, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"PlayerB" InPhase:2], 18, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"PlayerC" InPhase:2], 18, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"PlayerD" InPhase:2], 18, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Bank" InPhase:2], 1000, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:2], 6, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:3], 10, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:4], 10, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:5], 16, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:6], 16, @"Init test");
    XCTAssertEqual([gameA.settings certificateLimit:@"Dragon" InPhase:7], 16, @"Init test");
    XCTAssertEqual(gameA.bank.name, @"Bank", @"Init test");
    XCTAssertEqual(gameA.bank.money, 8000 - 4*300, @"Init test");
    XCTAssertEqual(gameA.dragon.name, @"Dragon", @"Init test");
    XCTAssertEqual(gameA.currentPlayer.name, gameA.startPlayer.name, @"Init test");
    XCTAssertEqual([gameA.companyStack count], (NSUInteger)0, @"Init test");
    XCTAssertEqual([gameA.companyTurnOrder count], (NSUInteger)0, @"Init test");
    XCTAssertEqual(gameA.round, @"Stock Round", @"Init test");
    XCTAssertEqual(gameA.settings.phase, 2, @"Init test");
    XCTAssertEqual(gameA.passCount, 0, @"Init test");
    for (Player *player in gameA.player) {
        XCTAssertEqual(player.money, 300, @"Init test");
    }
}

- (void) testPlayerCanSellStuff {
//    for (Company* comp in game.companies) {
//        [comp setInitialStockPrice:60];
//    }
    for (Player *player in game.player) {
        for (NSUInteger i=0; i<8; i++) {
            XCTAssert([game player:player CanBuyFromIpo:i], @"Player can sell test");
            XCTAssert(![game player:player CanBuyFromBank:i], @"Player can sell test");
            XCTAssert(![game player:player CanBuyFromDragon:i], @"Player can sell test");
            XCTAssert(![game player:player CanSell:i], @"Player can sell test");
        }
    }
    for (NSUInteger i=0; i<8; i++) {
        XCTAssert([game player:game.dragon CanBuyFromIpo:i], @"Comp %lu", (unsigned long)i);
        XCTAssert(![game player:game.dragon CanBuyFromBank:i], @"Player can sell test");
        XCTAssert(![game player:game.dragon CanBuyFromDragon:i], @"Player can sell test");
        XCTAssert(![game player:game.dragon CanSell:i], @"Player can sell test");
    }

    Company *compA = game.companies[0];
    Player *playerA = game.player[0];
    Player *playerB = game.player[1];
    Player *playerC = game.player[2];
    Player *playerD = game.player[3];
    [compA setInitialStockPrice:60];
    [compA sellCertificate:compA.certificates[0] To:playerA];
    [compA sellCertificate:compA.certificates[1] To:playerB];
    [compA sellCertificate:compA.certificates[2] To:playerC];
    [compA sellCertificate:compA.certificates[3] To:playerD];
    [compA updatePresident];

    // PlayerA cannot sell, as compA has not operated yet!
    for (Player *player in game.player) {
        NSUInteger i=0;
        XCTAssert(![game player:player CanBuyFromIpo:i], @"%@ - %lu", player.name, (unsigned long)i);
        XCTAssert(![game player:player CanBuyFromBank:i], @"%@ - %lu", player.name, (unsigned long)i);
        XCTAssert(![game player:player CanBuyFromDragon:i], @"%@ - %lu", player.name, (unsigned long)i);
        XCTAssert(![game player:player CanSell:i], @"%@ - %lu", player.name, (unsigned long)i);
        for (i=1; i<8; i++) {
            XCTAssert([game player:player CanBuyFromIpo:i], @"%@ - %lu", player.name, (unsigned long)i);
            XCTAssert(![game player:player CanBuyFromBank:i], @"%@ - %lu", player.name, (unsigned long)i);
            XCTAssert(![game player:player CanBuyFromDragon:i], @"%@ - %lu", player.name, (unsigned long)i);
            XCTAssert(![game player:player CanSell:i], @"%@ - %lu", player.name, (unsigned long)i);
        }
    }

    compA.isOperating = YES;
    // Now, playerA can sell
    for (Player *player in game.player) {
        NSUInteger i=0;
        XCTAssert(![game player:player CanBuyFromIpo:i], @"%@ - %lu", player.name, (unsigned long)i);
        XCTAssert(![game player:player CanBuyFromBank:i], @"%@ - %lu", player.name, (unsigned long)i);
        XCTAssert(![game player:player CanBuyFromDragon:i], @"%@ - %lu", player.name, (unsigned long)i);
        if (player == playerA) {
            XCTAssert(![game player:player CanSell:i], @"%@ - %lu", player.name, (unsigned long)i);
        } else {
            XCTAssert([game player:player CanSell:i], @"%@ - %lu", player.name, (unsigned long)i);
        }
        for (i=1; i<8; i++) {
            XCTAssert([game player:player CanBuyFromIpo:i], @"%@ - %lu", player.name, (unsigned long)i);
            XCTAssert(![game player:player CanBuyFromBank:i], @"%@ - %lu", player.name, (unsigned long)i);
            XCTAssert(![game player:player CanBuyFromDragon:i], @"%@ - %lu", player.name, (unsigned long)i);
            XCTAssert(![game player:player CanSell:i], @"%@ - %lu", player.name, (unsigned long)i);
        }
    }
 
    
    NSUInteger i = 0;
    XCTAssert(![game player:game.dragon CanBuyFromIpo:i], @"%lu", (unsigned long)i);
    XCTAssert(![game player:game.dragon CanBuyFromBank:i], @"Player can sell test");
    XCTAssert(![game player:game.dragon CanBuyFromDragon:i], @"Player can sell test");
    XCTAssert(![game player:game.dragon CanSell:i], @"Player can sell test");
    for (i=1; i<8; i++) {
        XCTAssert([game player:game.dragon CanBuyFromIpo:i], @"%lu", (unsigned long)i);
        XCTAssert(![game player:game.dragon CanBuyFromBank:i], @"Player can sell test");
        XCTAssert(![game player:game.dragon CanBuyFromDragon:i], @"Player can sell test");
        XCTAssert(![game player:game.dragon CanSell:i], @"Player can sell test");
    }
}

- (void) testDragonTurn {
    for (Company *comp in game.companies) {
        comp.stockPrice = 100;
        [comp setDragonRowWithPhase:2];
    }
    XCTAssertEqualObjects([game dragonTurn], @"", @"dragon turn test");
    
    Company *compA = game.companies[0];
    Player *playerA = game.player[0];
    [compA sellCertificate:compA.certificates[0] To:playerA];
    [compA sellCertificate:compA.certificates[1] To:playerA];
    XCTAssertEqual(playerA.money, 0, @"dragon turn test");
    XCTAssertEqual(compA.money, 300, @"dragon turn test");
    XCTAssertEqualObjects([game dragonTurn], @"", @"dragon turn test");
    XCTAssert(![compA isDragonBuy], @"dragon turn test");
    XCTAssert([compA isDragonSell], @"dragon turn test");
    XCTAssertEqual([compA rank], 1, @"dragon turn test");
    
    [compA placeStationMarkerForCost:50];
    XCTAssertEqual(compA.money, 250, @"dragon turn test");
    XCTAssert(![compA isDragonBuy], @"dragon turn test");
    XCTAssert([compA isDragonSell], @"dragon turn test");
    XCTAssertEqual([compA rank], 2, @"dragon turn test");
    
    Train *train = [game.trains firstObject];
    [game sellTrain:train To:compA];
    XCTAssertEqual(compA.money, 150, @"dragon turn test");
    XCTAssert(![compA isDragonBuy], @"dragon turn test");
    XCTAssert(![compA isDragonSell], @"dragon turn test");
    XCTAssertEqual([compA rank], 4, @"dragon turn test");
    XCTAssertEqual([game.trains count], (NSUInteger)33, @"Init test");
    
    [game sellTrain:[game.trains firstObject] To:compA];
    XCTAssertEqual(compA.money, 50, @"dragon turn test");
    XCTAssert([compA isDragonBuy], @"dragon turn test");
    XCTAssert(![compA isDragonSell], @"dragon turn test");
    XCTAssertEqual([compA rank], 6, @"dragon turn test");
    XCTAssertEqual([game.trains count], (NSUInteger)32, @"Init test");
    
}

- (void) testCompanyCanBuyTrain {
    Company *comp = [game.companies firstObject];
    Train *train = [game.trains firstObject];
    
    XCTAssertFalse([game companyCanBuyTrain:comp], @"Company can buy train test");

    [comp operateTrainsAndPayDividend:NO];
    
    XCTAssertTrue([game companyCanBuyTrain:comp], @"Company can buy train test");

    [game sellTrain:train To:comp];
//    [comp buyTrain:train];
    
    XCTAssertFalse([game companyCanBuyTrain:comp], @"Company can buy train test");

    comp.money = 10;

    XCTAssertTrue([game companyCanBuyTrain:comp], @"Company can buy train test");
}

- (void) testCompanyPresidentHandsOverMaritimeCompany {
    Company *comp = [game.companies firstObject];
    Player *player = [game.player firstObject];
    
    XCTAssertEqual([comp.maritimeCompanies count], (NSUInteger) 0, @"handover maritime Comp test");
    XCTAssertEqual([player.maritimeCompany count], (NSUInteger) 2, @"handover maritime Comp test");
    XCTAssertEqual(comp.traffic, 0, @"handover maritime Comp test");
    
    [game player:player BuysIpoShare:comp AtPrice:100];
    [game player:player BuysIpoShare:comp AtPrice:99];
    [game advancePlayersDidPass:NO];
    
    XCTAssertEqual([comp.maritimeCompanies count], (NSUInteger) 0, @"handover maritime Comp test");
    XCTAssertEqual([player.maritimeCompany count], (NSUInteger) 2, @"handover maritime Comp test");
    XCTAssertEqual(comp.traffic, 0, @"handover maritime Comp test");

    [game presidentHandsOverMaritimeCompanyTo:comp];

    XCTAssertEqual([comp.maritimeCompanies count], (NSUInteger) 1, @"handover maritime Comp test");
    XCTAssertEqual([player.maritimeCompany count], (NSUInteger) 1, @"handover maritime Comp test");
    XCTAssertEqual(comp.traffic, 8, @"handover maritime Comp test");
    
    [game companyConnectsToMaritimeCompany:comp];

    XCTAssertEqual([comp.maritimeCompanies count], (NSUInteger) 0, @"handover maritime Comp test");
    XCTAssertEqual([player.maritimeCompany count], (NSUInteger) 1, @"handover maritime Comp test");
    XCTAssertEqual(comp.traffic, 10, @"handover maritime Comp test");
}

- (void) testSellTrain {
    Company *compA = game.companies[0];
    Company *compB = game.companies[1];
    Train *trainA = game.trains[0];
    Train *trainB = game.trains[1];
    Train *trainC = game.trains[2];
    Train *trainD = game.trains[3];
    Train *trainE = game.trains[4];
    Train *trainF = game.trains[5];
    Train *train3A = game.trains[6];
    int moneyCompA = compA.money;
    int moneyCompB = compB.money;
    
    XCTAssertEqual([game.trains count], (NSUInteger) 34, @"sell train test");
    XCTAssertEqual([game.bank.trains count], (NSUInteger) 0, @"sell train test");
    XCTAssertEqual([compA.trains count], (NSUInteger) 0, @"sell train test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 0, @"sell train test");
    XCTAssertEqual(compA.money, moneyCompA, @"sell train test");
    XCTAssertEqual(compB.money, moneyCompB, @"sell train test");

    [game sellTrain:trainA To:compA];     moneyCompA -= 100;
    
    XCTAssertEqual([game.trains count], (NSUInteger) 33, @"sell train test");
    XCTAssertEqual([game.bank.trains count], (NSUInteger) 0, @"sell train test");
    XCTAssertEqual([compA.trains count], (NSUInteger) 1, @"sell train test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 0, @"sell train test");
    XCTAssertEqual(compA.money, moneyCompA, @"sell train test");
    XCTAssertEqual(compB.money, moneyCompB, @"sell train test");

    [game sellTrain:trainB To:compA];     moneyCompA -= 100;
    
    XCTAssertEqual([game.trains count], (NSUInteger) 32, @"sell train test");
    XCTAssertEqual([game.bank.trains count], (NSUInteger) 0, @"sell train test");
    XCTAssertEqual([compA.trains count], (NSUInteger) 2, @"sell train test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 0, @"sell train test");
    XCTAssertEqual(compA.money, moneyCompA, @"sell train test");
    XCTAssertEqual(compB.money, moneyCompB, @"sell train test");
    
    [game sellTrain:trainC To:compA];     moneyCompA -= 100;
    
    XCTAssertEqual([game.trains count], (NSUInteger) 31, @"sell train test");
    XCTAssertEqual([game.bank.trains count], (NSUInteger) 0, @"sell train test");
    XCTAssertEqual([compA.trains count], (NSUInteger) 3, @"sell train test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 0, @"sell train test");
    XCTAssertEqual(compA.money, moneyCompA, @"sell train test");
    XCTAssertEqual(compB.money, moneyCompB, @"sell train test");
    
    [game sellTrain:trainD To:compA];     moneyCompA -= 100;
    
    XCTAssertEqual([game.trains count], (NSUInteger) 30, @"sell train test");
    XCTAssertEqual([game.bank.trains count], (NSUInteger) 0, @"sell train test");
    XCTAssertEqual([compA.trains count], (NSUInteger) 4, @"sell train test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 0, @"sell train test");
    XCTAssertEqual(compA.money, moneyCompA, @"sell train test");
    XCTAssertEqual(compB.money, moneyCompB, @"sell train test");
    
    [game sellTrain:trainE To:compB];     moneyCompB -= 100;
    
    XCTAssertEqual([game.trains count], (NSUInteger) 29, @"sell train test");
    XCTAssertEqual([game.bank.trains count], (NSUInteger) 0, @"sell train test");
    XCTAssertEqual([compA.trains count], (NSUInteger) 4, @"sell train test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 1, @"sell train test");
    XCTAssertEqual(compA.money, moneyCompA, @"sell train test");
    XCTAssertEqual(compB.money, moneyCompB, @"sell train test");

    [game sellTrain:trainF To:compB];     moneyCompB -= 70;
    
    XCTAssertEqual([game.trains count], (NSUInteger) 28, @"sell train test");
    XCTAssertEqual([game.bank.trains count], (NSUInteger) 0, @"sell train test");
    XCTAssertEqual([compA.trains count], (NSUInteger) 4, @"sell train test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 2, @"sell train test");
    XCTAssertEqual(compA.money, moneyCompA, @"sell train test");
    XCTAssertEqual(compB.money, moneyCompB, @"sell train test");

    [game sellTrain:train3A To:compB];     moneyCompB -= 200;
    
    XCTAssertEqual([game.trains count], (NSUInteger) 27, @"sell train test");
    XCTAssertEqual([game.bank.trains count], (NSUInteger) 1, @"sell train test");
    XCTAssertEqual([compA.trains count], (NSUInteger) 3, @"sell train test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 3, @"sell train test");
    XCTAssertEqual(compA.money, moneyCompA, @"sell train test");
    XCTAssertEqual(compB.money, moneyCompB, @"sell train test");
    XCTAssertEqual(game.settings.phase, 3, @"sell train test");
}

- (void) testPlayerCanBuy {
    Company *compA = [game.companies firstObject];
    Player *playerA = game.player[0];
    int moneyA = playerA.money;
    
    XCTAssertEqual([game player:playerA CanBuyFromIpo:0], YES, @"play can buy/sell test");
    XCTAssertEqual([game player:playerA CanBuyFromBank:0], NO, @"play can buy/sell test");
    XCTAssertEqual([game player:playerA CanBuyFromDragon:0], NO, @"play can buy/sell test");
    XCTAssertEqual([game player:playerA CanSell:0], NO, @"play can buy/sell test");
    XCTAssertEqual(playerA.money, moneyA, @"player can buy/sell test");
    
    [game player:playerA BuysIpoShare:compA AtPrice:60];        moneyA -= 2*60;
    [game updateStock];
    
    XCTAssertEqual([game player:playerA CanBuyFromIpo:0], YES, @"play can buy/sell test");
    XCTAssertEqual([game player:playerA CanBuyFromBank:0], NO, @"play can buy/sell test");
    XCTAssertEqual([game player:playerA CanBuyFromDragon:0], NO, @"play can buy/sell test");
    XCTAssertEqual([game player:playerA CanSell:0], NO, @"play can buy/sell test");
    XCTAssertEqual(playerA.money, moneyA, @"player can buy/sell test");
    XCTAssertEqual(compA.stockPrice, 60, @"player can buy/sell test");

    [game player:playerA BuysIpoShare:compA AtPrice:99];        moneyA -= 60;
    [game updateStock];
    
    // Player cannot sell, as company didn't operate yet
    XCTAssertEqual([game player:playerA CanBuyFromIpo:0], NO, @"play can buy/sell test");  // certificate limit reached
    XCTAssertEqual([game player:playerA CanBuyFromBank:0], NO, @"play can buy/sell test");
    XCTAssertEqual([game player:playerA CanBuyFromDragon:0], NO, @"play can buy/sell test");
    XCTAssertEqual([game player:playerA CanSell:0], NO, @"play can buy/sell test");
    XCTAssertEqual(playerA.money, moneyA, @"player can buy/sell test");
    XCTAssertEqual(compA.stockPrice, 60, @"player can buy/sell test");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"player can buy/sell test");
    
    compA.isOperating = YES;
    
    XCTAssertEqual([game player:playerA CanBuyFromIpo:0], NO, @"play can buy/sell test");  // certificate limit reached
    XCTAssertEqual([game player:playerA CanBuyFromBank:0], NO, @"play can buy/sell test");
    XCTAssertEqual([game player:playerA CanBuyFromDragon:0], NO, @"play can buy/sell test");
    XCTAssertEqual([game player:playerA CanSell:0], YES, @"play can buy/sell test");
    XCTAssertEqual(playerA.money, moneyA, @"player can buy/sell test");
    XCTAssertEqual(compA.stockPrice, 60, @"player can buy/sell test");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"player can buy/sell test");
    
    [game player:playerA SellsShare:compA];                     moneyA += 60;
    
    // Player cannot buy, as he sold this stock
    XCTAssertEqual([game player:playerA CanBuyFromIpo:0], NO, @"play can buy/sell test");
    XCTAssertEqual([game player:playerA CanBuyFromBank:0], NO, @"play can buy/sell test");
    XCTAssertEqual([game player:playerA CanBuyFromDragon:0], NO, @"play can buy/sell test");
    XCTAssertEqual([game player:playerA CanSell:0], NO, @"play can buy/sell test");
    XCTAssertEqual(playerA.money, moneyA, @"player can buy/sell test");
    // Stock price only is decreased if playerA is done with his turn
    XCTAssertEqual(compA.stockPrice, 60, @"player can buy/sell test");
    XCTAssertEqual(compA.presidentSoldShares, 1, @"player can buy/sell test");

    [game updateStock];
    XCTAssertEqual(compA.stockPrice, 50, @"player can buy/sell test");
    XCTAssertEqual(compA.presidentSoldShares, 0, @"player can buy/sell test");
}

- (void) testStockRound {
    Player *player[4];
    Company *comp[8];
    int pMoney[4];
    int cMoney[8];
    for (int i=0; i<4; i++) {
        player[i] = game.player[i];
        pMoney[i] = player[i].money;
    }
    for (int i=0; i<8; i++) {
        comp[i] = game.companies[i];
        cMoney[i] = comp[i].money;
    }

    [game player:game.currentPlayer BuysIpoShare:comp[0] AtPrice:60];   pMoney[0] -= 120;   cMoney[0] += 120;
    [game advancePlayersDidPass:NO];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    
    [game player:game.currentPlayer BuysIpoShare:comp[1] AtPrice:100];   pMoney[1] -= 200;   cMoney[1] += 200;
    [game advancePlayersDidPass:NO];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    
    [game player:game.currentPlayer BuysIpoShare:comp[2] AtPrice:90];   pMoney[2] -= 180;   cMoney[2] += 180;
    [game advancePlayersDidPass:NO];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    
    [game player:game.currentPlayer BuysIpoShare:comp[3] AtPrice:80];   pMoney[3] -= 160;   cMoney[3] += 160;
    [game advancePlayersDidPass:NO];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }

    NSArray *stack = @[comp[1], comp[2], comp[3], comp[0]];
    XCTAssertEqualObjects(game.companyStack, stack, @"stock round test");
    XCTAssertEqual(comp[0].stockPrice, 60, @"stock round test");
    XCTAssertEqual(comp[1].stockPrice, 100, @"stock round test");
    XCTAssertEqual(comp[2].stockPrice, 90, @"stock round test");
    XCTAssertEqual(comp[3].stockPrice, 80, @"stock round test");
    XCTAssertEqual(comp[4].stockPrice,  0, @"stock round test");
    XCTAssertEqual(comp[5].stockPrice,  0, @"stock round test");
    XCTAssertEqual(comp[6].stockPrice,  0, @"stock round test");
    XCTAssertEqual(comp[7].stockPrice,  0, @"stock round test");
    XCTAssertEqual(comp[0].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[1].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[2].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[3].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[4].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[5].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[6].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[7].isFloating, NO, @"stock round test");
    
    // Round 2
    [game player:game.currentPlayer BuysIpoShare:comp[0] AtPrice:99];   pMoney[0] -= 60;   cMoney[0] += 60;
    [game advancePlayersDidPass:NO];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    
    [game player:game.currentPlayer BuysIpoShare:comp[1] AtPrice:99];   pMoney[1] -= 100;   cMoney[1] += 100;
    [game advancePlayersDidPass:NO];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    
    [game player:game.currentPlayer BuysIpoShare:comp[2] AtPrice:99];   pMoney[2] -= 90;   cMoney[2] += 90;
    [game advancePlayersDidPass:NO];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    
    [game player:game.currentPlayer BuysIpoShare:comp[3] AtPrice:99];   pMoney[3] -= 80;   cMoney[3] += 80;
    [game advancePlayersDidPass:NO];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    stack = @[comp[1], comp[2], comp[3], comp[0]];
    XCTAssertEqualObjects(game.companyStack, stack, @"stock round test");
    XCTAssertEqual(comp[0].stockPrice, 60, @"stock round test");
    XCTAssertEqual(comp[1].stockPrice, 100, @"stock round test");
    XCTAssertEqual(comp[2].stockPrice, 90, @"stock round test");
    XCTAssertEqual(comp[3].stockPrice, 80, @"stock round test");
    XCTAssertEqual(comp[4].stockPrice,  0, @"stock round test");
    XCTAssertEqual(comp[5].stockPrice,  0, @"stock round test");
    XCTAssertEqual(comp[6].stockPrice,  0, @"stock round test");
    XCTAssertEqual(comp[7].stockPrice,  0, @"stock round test");
    XCTAssertEqual(comp[0].isFloating, YES, @"stock round test");
    XCTAssertEqual(comp[1].isFloating, YES, @"stock round test");
    XCTAssertEqual(comp[2].isFloating, YES, @"stock round test");
    XCTAssertEqual(comp[3].isFloating, YES, @"stock round test");
    XCTAssertEqual(comp[4].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[5].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[6].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[7].isFloating, NO, @"stock round test");
    
    // Round 3
    [game player:game.currentPlayer BuysIpoShare:comp[4] AtPrice:60];   pMoney[0] -= 120;   cMoney[4] += 120;
    [game advancePlayersDidPass:NO];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    
    [game advancePlayersDidPass:YES];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    
    [game advancePlayersDidPass:YES];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    
    [game advancePlayersDidPass:YES];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    stack = @[comp[1], comp[2], comp[3], comp[0], comp[4]];
    XCTAssertEqualObjects(game.companyStack, stack, @"stock round test");
    XCTAssertEqual(comp[0].stockPrice, 60, @"stock round test");
    XCTAssertEqual(comp[1].stockPrice, 100, @"stock round test");
    XCTAssertEqual(comp[2].stockPrice, 90, @"stock round test");
    XCTAssertEqual(comp[3].stockPrice, 80, @"stock round test");
    XCTAssertEqual(comp[4].stockPrice, 60, @"stock round test");
    XCTAssertEqual(comp[5].stockPrice,  0, @"stock round test");
    XCTAssertEqual(comp[6].stockPrice,  0, @"stock round test");
    XCTAssertEqual(comp[7].stockPrice,  0, @"stock round test");
    XCTAssertEqual(comp[0].isFloating, YES, @"stock round test");
    XCTAssertEqual(comp[1].isFloating, YES, @"stock round test");
    XCTAssertEqual(comp[2].isFloating, YES, @"stock round test");
    XCTAssertEqual(comp[3].isFloating, YES, @"stock round test");
    XCTAssertEqual(comp[4].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[5].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[6].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[7].isFloating, NO, @"stock round test");
    
    // Round 4
    [game player:game.currentPlayer SellsShare:comp[0]];                pMoney[0] += 60;
    [game player:game.currentPlayer BuysIpoShare:comp[4] AtPrice:99];   pMoney[0] -= 60;   cMoney[4] += 60;
    [game advancePlayersDidPass:NO];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    
    [game advancePlayersDidPass:YES];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    
    [game advancePlayersDidPass:YES];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    
    [game advancePlayersDidPass:YES];
    
    for (int i=0; i<4; i++) {
        XCTAssertEqual(pMoney[i], player[i].money, @"Loop %d", i);
    }
    for (int i=0; i<8; i++) {
        XCTAssertEqual(cMoney[i], comp[i].money, @"Loop %d", i);
    }
    stack = @[comp[1], comp[2], comp[3], comp[4], comp[0]];
    XCTAssertEqualObjects(game.companyStack, stack, @"stock round test");
    XCTAssertEqual(comp[0].stockPrice, 50, @"stock round test");
    XCTAssertEqual(comp[1].stockPrice, 100, @"stock round test");
    XCTAssertEqual(comp[2].stockPrice, 90, @"stock round test");
    XCTAssertEqual(comp[3].stockPrice, 80, @"stock round test");
    XCTAssertEqual(comp[4].stockPrice, 60, @"stock round test");
    XCTAssertEqual(comp[5].stockPrice,  0, @"stock round test");
    XCTAssertEqual(comp[6].stockPrice,  0, @"stock round test");
    XCTAssertEqual(comp[7].stockPrice,  0, @"stock round test");
    XCTAssertEqual(comp[0].isFloating, YES, @"stock round test");
    XCTAssertEqual(comp[1].isFloating, YES, @"stock round test");
    XCTAssertEqual(comp[2].isFloating, YES, @"stock round test");
    XCTAssertEqual(comp[3].isFloating, YES, @"stock round test");
    XCTAssertEqual(comp[4].isFloating, YES, @"stock round test");
    XCTAssertEqual(comp[5].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[6].isFloating, NO, @"stock round test");
    XCTAssertEqual(comp[7].isFloating, NO, @"stock round test");

    // End stock round
    XCTAssertEqualObjects(game.round, @"Stock Round", @"stock round test");
    [game advancePlayersDidPass:YES];
    XCTAssertEqualObjects(game.round, @"Operating Round", @"stock round test");
}

- (void) testStockPriceMovement {
    Company *compA = game.companies[0];
    Company *compB = game.companies[1];
    Player *playerA = game.player[0];
    Player *playerB = game.player[1];

    [game player:playerA BuysIpoShare:compA AtPrice:100];
    [game advancePlayersDidPass:NO];
    [game player:playerA BuysIpoShare:compA AtPrice:100];
    [game advancePlayersDidPass:NO];
    [game player:playerB BuysIpoShare:compB AtPrice:90];
    [game advancePlayersDidPass:NO];
    [game player:playerB BuysIpoShare:compB AtPrice:90];
    [game advancePlayersDidPass:NO];
    [compA trafficUpgrade:10];
    game.round = @"Operating Round";
    
    // No traffic - no change in stock price
    XCTAssertEqual(compA.stockPrice, 100, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 60, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 2, @"stock price test");
    XCTAssertEqual(compA.president, playerA, @"stock price test");
    XCTAssertEqual([compA isDragonBuy], NO, @"stock price test");
    
    [compA operateTrainsAndPayDividend:YES];
    game.companyTurnOrder = [@[compA, compB] mutableCopy];
    [game advancePlayersDidPass:NO];
    
    // Case 4: Zero dividend - stock price decreases
    XCTAssertEqual(compA.stockPrice,  90, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 60, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 2, @"stock price test");
    
    NSArray *trainKeys = [game getTrainTextForCompany:compA];
    [game company:compA BuysTrain:trainKeys[0] AtCost:99];
    game.companyTurnOrder = [@[compA, compB] mutableCopy];
    [game advancePlayersDidPass:NO];
    
    // Case 2: Every time company buys a brand-new train
    // Back one due to not generating income
    XCTAssertEqual(compA.stockPrice,  90, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 60, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 2, @"stock price test");
    XCTAssertEqual([compA isDragonBuy], NO, @"stock price test");
    
    [compA cleanFlagsForOperatingRound];
    [compA operateTrainsAndPayDividend:YES];
    game.companyTurnOrder = [@[compA, compB] mutableCopy];
    [game advancePlayersDidPass:NO];
    
    // Case 1: Every time a company pays a non-zero dividend
    XCTAssertEqual(compA.stockPrice, 100, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 60, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 2, @"stock price test");
    
    [compA cleanFlagsForOperatingRound];
    [compA operateTrainsAndPayDividend:NO];
    game.companyTurnOrder = [@[compA, compB] mutableCopy];
    [game advancePlayersDidPass:NO];
    
    // No change if company withholds income
    XCTAssertEqual(compA.stockPrice, 100, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 60, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 2, @"stock price test");
    
    [compA cleanFlagsForOperatingRound];
    trainKeys = [game getTrainTextForCompany:compA];
    [game company:compA BuysTrain:trainKeys[0] AtCost:99];
    trainKeys = [game getTrainTextForCompany:compA];
    [game company:compA BuysTrain:trainKeys[0] AtCost:99];
    game.companyTurnOrder = [@[compA, compB] mutableCopy];
    [game advancePlayersDidPass:NO];

    // Only 1 increase if company buys two trains
    XCTAssertEqual(compA.stockPrice, 110, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 60, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 2, @"stock price test");
    XCTAssertEqual([compA isDragonBuy], YES, @"stock price test");
    
    [compA cleanFlagsForOperatingRound];
    [game player:playerB BuysIpoShare:compA AtPrice:99];
    [game player:playerB BuysIpoShare:compA AtPrice:99];
    game.companyTurnOrder = [@[compA, compB] mutableCopy];
    [game advancePlayersDidPass:NO];
    
    // No change if other player buys share
    XCTAssertEqual(compA.stockPrice, 110, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 60, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 2, @"stock price test");
    
    [compA cleanFlagsForOperatingRound];
    [game player:playerB SellsShare:compA];
    [game player:playerB SellsShare:compA];
    game.companyTurnOrder = [@[compA, compB] mutableCopy];
    [game advancePlayersDidPass:NO];
    
    // No change if other player sells share
    XCTAssertEqual(compA.stockPrice, 110, @"stock price test");
    XCTAssertEqual(compA.president, playerA, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 60, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 2, @"stock price test");

    [compA cleanFlagsForOperatingRound];
    [game player:playerB BuysBankShare:compA];
    [game player:playerB BuysBankShare:compA];
    [game player:playerA SellsShare:compA];
    game.companyTurnOrder = [@[compA, compB] mutableCopy];
    [game advancePlayersDidPass:NO];
    
    // Drop by one if president sells share
    XCTAssertEqual(compA.stockPrice, 100, @"stock price test");
    XCTAssertEqual(compA.president, playerA, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 40, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 1, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerB], 40, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerB], 2, @"stock price test");
    
    [compA cleanFlagsForOperatingRound];
    [game player:playerA BuysBankShare:compA];
    [game player:playerA SellsShare:compA];
    [game player:playerA SellsShare:compA];
    [game player:playerA SellsShare:compA];
    game.companyTurnOrder = [@[compA, compB] mutableCopy];
    [game advancePlayersDidPass:NO];
    
    // Drop by two if president sells 3 shares (after two, he lost the president's share, but still counts as president when selling)
    XCTAssertEqual(compA.stockPrice,  70, @"stock price test");
    XCTAssertEqual(compA.president, playerB, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 0, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 0, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerB], 40, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerB], 1, @"stock price test");
    XCTAssertEqual([compA isDragonBuy], YES, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:game.dragon], 0, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:game.dragon], 0, @"stock price test");
    
    [game dragonTurn];
    game.companyTurnOrder = [@[compA, compB] mutableCopy];
    [game advancePlayersDidPass:NO];
    
    // Dragon buys one
    XCTAssertEqual(compA.stockPrice,  70, @"stock price test");
    XCTAssertEqual(compA.president, playerB, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 0, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 0, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerB], 40, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerB], 1, @"stock price test");
    XCTAssertEqual([compA isDragonBuy], YES, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:game.dragon], 20, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:game.dragon], 1, @"stock price test");

    [game dragonTurn];
    game.companyTurnOrder = [@[compA, compB] mutableCopy];
    [game advancePlayersDidPass:NO];
    [game dragonTurn];
    game.companyTurnOrder = [@[compA, compB] mutableCopy];
    [game advancePlayersDidPass:NO];

    // Dragon buys one (50% limit), playerB remains president
    XCTAssertEqual(compA.stockPrice,  70, @"stock price test");
    XCTAssertEqual(compA.president, playerB, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 0, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 0, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerB], 40, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerB], 1, @"stock price test");
    XCTAssertEqual([compA isDragonBuy], YES, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:game.dragon], 40, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:game.dragon], 2, @"stock price test");
    XCTAssertEqual([compA.trains count], (NSUInteger) 3, @"stock price test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 0, @"stock price test");
    
    trainKeys = [game getTrainTextForCompany:compB];
    [game company:compB BuysTrain:trainKeys[1] AtCost:10];
    [self checkSaving];
    trainKeys = [game getTrainTextForCompany:compB];
    [game company:compB BuysTrain:trainKeys[1] AtCost:10];
    
    // compA sells two trains, now in dragon neutral range
    XCTAssertEqual(compA.stockPrice,  70, @"stock price test");
    XCTAssertEqual(compA.president, playerB, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 0, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 0, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerB], 40, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerB], 1, @"stock price test");
    XCTAssertEqual([compA isDragonBuy], NO, @"stock price test");
    XCTAssertEqual([compA isDragonSell], NO, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:game.dragon], 40, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:game.dragon], 2, @"stock price test");
    XCTAssertEqual([compA.trains count], (NSUInteger) 1, @"stock price test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 2, @"stock price test");

    [self checkSaving];
    trainKeys = [game getTrainTextForCompany:compB];
    [game company:compB BuysTrain:trainKeys[1] AtCost:10];
    
    // compA sells third train, now in dragon sell range
    XCTAssertEqual(compA.stockPrice,  70, @"stock price test");
    XCTAssertEqual(compA.president, playerB, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 0, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 0, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerB], 40, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerB], 1, @"stock price test");
    XCTAssertEqual([compA isDragonBuy], NO, @"stock price test");
    XCTAssertEqual([compA isDragonSell], YES, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:game.dragon], 40, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:game.dragon], 2, @"stock price test");
    XCTAssertEqual([compA.trains count], (NSUInteger) 0, @"stock price test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 3, @"stock price test");

    [game dragonTurn];
    game.companyTurnOrder = [@[compA, compB] mutableCopy];
    [self checkSaving];
    [game advancePlayersDidPass:NO];
    
    // dragon sells all his stock => stock price drops by two steps
    XCTAssertEqual(compA.stockPrice,  50, @"stock price test");
    XCTAssertEqual(compA.president, playerB, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerA], 0, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerA], 0, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:playerB], 40, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:playerB], 1, @"stock price test");
    XCTAssertEqual([compA isDragonBuy], NO, @"stock price test");
    XCTAssertEqual([compA isDragonSell], YES, @"stock price test");
    XCTAssertEqual([compA getShareByOwner:game.dragon], 0, @"stock price test");
    XCTAssertEqual([compA getCertificatesByOwner:game.dragon], 0, @"stock price test");
    XCTAssertEqual([compA.trains count], (NSUInteger) 0, @"stock price test");
    XCTAssertEqual([compB.trains count], (NSUInteger) 3, @"stock price test");
    
    [self checkSaving];
}

- (void) checkSaving {
    NSString *path = @"savetest-Game.plist";
    XCTAssertTrue([NSKeyedArchiver archiveRootObject:game toFile:path], @"coding test");
    
    Game *copy = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

    XCTAssertEqual([game.companies count], [copy.companies count], @"check saving");
    XCTAssertEqual([game.player count], [copy.player count], @"check saving");
    for (NSUInteger i=0; i<[game.companies count]; i++) {
        Company *comp  = game.companies[i];
        Company *ccomp = copy.companies[i];
        XCTAssertEqualObjects(comp.name, ccomp.name, @"check saving");
        XCTAssertEqual(comp.money, ccomp.money, @"check saving");
        XCTAssertEqual([comp.certificates count], [ccomp.certificates count], @"check saving");
        XCTAssertEqual([comp.trains count], [ccomp.trains count], @"check saving");
        XCTAssertEqual(comp.stockPrice, ccomp.stockPrice, @"check saving");
        XCTAssertEqual(comp.trainCapacity, ccomp.trainCapacity, @"check saving");
        XCTAssertEqual(comp.traffic, ccomp.traffic, @"check saving");
    }
    for (NSUInteger i=0; i<[game.player count]; i++) {
        Player *player = game.player[i];
        Player *cplayer = copy.player[i];
        XCTAssertEqualObjects(player.name, cplayer.name, @"Check saving");
        XCTAssertEqual(player.money, cplayer.money, @"Check saving");
        XCTAssertEqual(player.numCertificates, cplayer.numCertificates, @"Check saving");
        XCTAssertEqual(player.numShares, cplayer.numShares, @"Check saving");
    }
}

- (void) testCoding {
    Company *comp = game.companies[4];
    comp.name = @"Test name";
    Player *player = game.player[2];
    player.name = @"Mr. Testguy";
    game.bank.name = @"Banco";
    game.dragon.name = @"Drache";
    Train *train = game.trains[18];
    train.techLevel = 42;
    game.settings.trainLimit = 23;
    
    NSString *path = @"savetest";
    XCTAssertTrue([NSKeyedArchiver archiveRootObject:game toFile:path], @"coding test");

    Game *copyOfGame = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    XCTAssertNotEqualObjects(game, copyOfGame, @"coding test");
    
    Company *ccomp = copyOfGame.companies[4];
    Player *cplayer = copyOfGame.player[2];
    Train *ctrain = copyOfGame.trains[18];
    
    XCTAssertEqualObjects(ccomp.name, @"Test name", @"coding test");
    XCTAssertEqualObjects(cplayer.name, @"Mr. Testguy", @"coding test");
    XCTAssertEqualObjects(copyOfGame.bank.name, @"Banco", @"coding test");
    XCTAssertEqualObjects(copyOfGame.dragon.name, @"Drache", @"coding test");
    XCTAssertEqual(ctrain.techLevel, 42, @"coding test");
    XCTAssertEqual(copyOfGame.settings.trainLimit, 23, @"coding test");
    
    XCTAssertEqualObjects(game.settings.pref, ccomp.settings.pref, @"coding test");
    XCTAssertEqualObjects(game.settings.trainSpec, ccomp.settings.trainSpec, @"coding test");
}

- (void) testCanAbsorb {
    Player *player[4];
    Company *comp[8];
    int pMoney[4];
    int cMoney[8];
    for (int i=0; i<4; i++) {
        player[i] = game.player[i];
        pMoney[i] = player[i].money;
    }
    for (int i=0; i<8; i++) {
        comp[i] = game.companies[i];
        cMoney[i] = comp[i].money;
    }
    
    [game player:game.currentPlayer BuysIpoShare:comp[0] AtPrice:60];   pMoney[0] -= 120;   cMoney[0] += 120;
    [game advancePlayersDidPass:NO];
    [game player:game.currentPlayer BuysIpoShare:comp[1] AtPrice:100];  pMoney[1] -= 200;   cMoney[1] += 200;
    [game advancePlayersDidPass:NO];
    [game player:game.currentPlayer BuysIpoShare:comp[2] AtPrice:60];   pMoney[2] -= 120;   cMoney[2] += 120;
    [game advancePlayersDidPass:NO];
    [game player:game.currentPlayer BuysIpoShare:comp[3] AtPrice:60];   pMoney[3] -= 120;   cMoney[3] += 120;
    [game advancePlayersDidPass:NO];
    
    [game player:game.currentPlayer BuysIpoShare:comp[0] AtPrice:60];   pMoney[0] -=  60;   cMoney[0] +=  60;
    [game advancePlayersDidPass:NO];
    [game player:game.currentPlayer BuysIpoShare:comp[1] AtPrice:100];  pMoney[1] -= 100;   cMoney[1] += 100;
    [game advancePlayersDidPass:NO];
    [game player:game.currentPlayer BuysIpoShare:comp[2] AtPrice:60];   pMoney[2] -=  60;   cMoney[2] +=  60;
    [game advancePlayersDidPass:NO];
    [game player:game.currentPlayer BuysIpoShare:comp[3] AtPrice:60];   pMoney[3] -=  60;   cMoney[3] +=  60;
    [game advancePlayersDidPass:NO];
    
    [game player:game.currentPlayer BuysIpoShare:comp[4] AtPrice:60];   pMoney[0] -=  60;   cMoney[0] +=  60;
    [game advancePlayersDidPass:NO];
    [game player:game.currentPlayer BuysIpoShare:comp[1] AtPrice:100];  pMoney[1] -= 100;   cMoney[1] += 100;
    [game advancePlayersDidPass:NO];
    [game player:game.currentPlayer BuysIpoShare:comp[2] AtPrice:60];   pMoney[2] -=  60;   cMoney[2] +=  60;
    [game advancePlayersDidPass:NO];
    [game player:game.currentPlayer BuysIpoShare:comp[3] AtPrice:60];   pMoney[3] -=  60;   cMoney[3] +=  60;
    [game advancePlayersDidPass:NO];
    
}

@end
