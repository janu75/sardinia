//
//  Game.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameSettings.h"
#import "Player.h"
#import "Bank.h"
#import "Dragon.h"
#import "Train.h"
#import "Company.h"

@interface Game : NSObject

@property (strong) NSArray* companies;
@property (strong) NSArray* player;
@property (strong) GameSettings* settings;
@property (strong) NSArray *compNames; // of NSString
@property (strong) Bank* bank;
@property (strong) Dragon* dragon;
@property (weak) Player* currentPlayer;
@property (weak) Player* startPlayer;
@property (strong) NSMutableArray *companyStack;
@property (strong) NSMutableArray *companyTurnOrder;
@property (strong) NSMutableArray *trains;
@property (strong) NSString* round;
@property int passCount;

- (id) initWithPlayers:(NSArray*)playerNames AndShortMode:(BOOL)isShort;

- (BOOL) player:(Shareholder*)aPlayer CanBuyFromIpo:(NSUInteger)nComp;

- (BOOL) player:(Shareholder*)aPlayer CanBuyFromBank:(NSUInteger)nComp;

- (BOOL) player:(Shareholder*)aPlayer CanBuyFromDragon:(NSUInteger)nComp;

- (BOOL) player:(Shareholder*)aPlayer CanSell:(NSUInteger)nComp;

- (void) shufflePlayers;

- (NSString*) advancePlayersDidPass:(BOOL)didPass;

- (BOOL) isStockRound;

- (NSString*) dragonTurn;

- (void) sellTrain:(Train*)aTrain From:(id)oldOwner To:(id)newOwner;

- (void) sellTrain:(Train*)aTrain From:(id)oldOwner To:(id)newOwner AtCost:(int)price;

- (int) getMaxInitialStockPrice;

- (void) addToCompanyStack:(Company*)aComp;

- (void) removeFromCompanyStack:(Company*)aComp;

- (void) increaseStockPrice:(Company*)aComp;

- (void) decreaseStockPrice:(Company*)aComp;

- (NSArray*) getTrainsForPurchaseForCompany:(Company*)aComp;

- (NSArray*) getTrainTextFromTrainList:(NSArray*)trainList ForCompany:(Company*)aComp;

- (NSArray*) companyCanAbsorb:(Company*)aComp;

- (BOOL) companyCanGetAbsorbed:(Company*)aComp;

- (BOOL) companyCanBuyTrain:(Company*)aComp;

@end
