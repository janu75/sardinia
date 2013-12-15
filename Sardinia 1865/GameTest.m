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
    XCTAssertEqual(gameA.phase, 2, @"Init test");
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
    XCTAssertEqual(gameA.phase, 2, @"Init test");
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
    XCTAssertEqual(gameA.phase, 2, @"Init test");
    XCTAssertEqual(gameA.passCount, 0, @"Init test");
    for (Player *player in gameA.player) {
        XCTAssertEqual(player.money, 300, @"Init test");
    }
}

- (void) testPlayerCanSellStuff {
    for (Player *player in game.player) {
        for (NSUInteger i=0; i<8; i++) {
            XCTAssert([game player:player CanBuyFromIpo:i], @"Player can sell test");
            XCTAssert(![game player:player CanBuyFromBank:i], @"Player can sell test");
            XCTAssert(![game player:player CanBuyFromDragon:i], @"Player can sell test");
            XCTAssert(![game player:player CanSell:i], @"Player can sell test");
        }
    }
    for (NSUInteger i=0; i<8; i++) {
        XCTAssert([game player:game.dragon CanBuyFromIpo:i], @"Player can sell test");
        XCTAssert(![game player:game.dragon CanBuyFromBank:i], @"Player can sell test");
        XCTAssert(![game player:game.dragon CanBuyFromDragon:i], @"Player can sell test");
        XCTAssert(![game player:game.dragon CanSell:i], @"Player can sell test");
    }

    Company *compA = game.companies[0];
    Player *playerA = game.player[0];
    Player *playerB = game.player[1];
    Player *playerC = game.player[2];
    Player *playerD = game.player[3];
    compA.stockPrice = 100;
    [compA sellCertificate:compA.certificates[0] To:playerA];
    [compA sellCertificate:compA.certificates[1] To:playerB];
    [compA sellCertificate:compA.certificates[2] To:playerC];
    [compA sellCertificate:compA.certificates[3] To:playerD];
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
    
    [game sellTrain:[game.trains firstObject] From:game To:compA];
    XCTAssertEqual(compA.money, 150, @"dragon turn test");
    XCTAssert(![compA isDragonBuy], @"dragon turn test");
    XCTAssert(![compA isDragonSell], @"dragon turn test");
    XCTAssertEqual([compA rank], 4, @"dragon turn test");
    XCTAssertEqual([game.trains count], (NSUInteger)33, @"Init test");
    
    [game sellTrain:[game.trains firstObject] From:game To:compA];
    XCTAssertEqual(compA.money, 50, @"dragon turn test");
    XCTAssert([compA isDragonBuy], @"dragon turn test");
    XCTAssert(![compA isDragonSell], @"dragon turn test");
    XCTAssertEqual([compA rank], 6, @"dragon turn test");
    XCTAssertEqual([game.trains count], (NSUInteger)32, @"Init test");
    
}
















@end
