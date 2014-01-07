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

@interface Game : NSObject<NSCoding>

@property (strong) NSArray* companies;
@property (strong) NSArray* player;
@property (strong) GameSettings* settings;
@property (strong) NSArray *compNames; // of NSString
@property (strong) Bank* bank;
@property (strong) Dragon* dragon;
@property (strong) Player* currentPlayer;
@property (strong) Player* startPlayer;
@property (strong) NSMutableArray *companyStack;
@property (strong) NSMutableArray *companyTurnOrder;
@property (strong) NSArray *frozenTurnOrder;
@property (strong) NSMutableArray *trains;
@property (strong) NSString* round;
@property int passCount;
@property int operatingRoundNum;
@property int turnCount;
@property (strong) NSMutableDictionary* saveGames;
@property (strong) NSString* dirName;


- (id) initWithPlayers:(NSArray*)playerNames AndShortMode:(BOOL)isShort;

- (BOOL) player:(Shareholder*)aPlayer CanBuyFromIpo:(NSUInteger)nComp;

- (BOOL) player:(Shareholder*)aPlayer CanBuyFromBank:(NSUInteger)nComp;

- (BOOL) player:(Shareholder*)aPlayer CanBuyFromDragon:(NSUInteger)nComp;

- (BOOL) player:(Shareholder*)aPlayer CanSell:(NSUInteger)nComp;

- (void) shufflePlayers;

- (NSString*) advancePlayersDidPass:(BOOL)didPass;

- (BOOL) isStockRound;

- (NSString*) dragonTurn;

- (int) getMaxInitialStockPrice;

- (void) addToCompanyStack:(Company*)aComp;

- (void) removeFromCompanyStack:(Company*)aComp;

- (void) increaseStockPrice:(Company*)aComp;

- (void) decreaseStockPrice:(Company*)aComp;

- (Train*) getTrainForPurchaseForCompany:(Company*)aComp WithText:(NSString*)aKey;

- (NSArray*) getTrainTextForCompany:(Company*)aComp;

- (NSArray*) companyCanAbsorb:(Company*)aComp;

- (BOOL) companyCanGetAbsorbed:(Company*)aComp;

- (BOOL) companyCanBuyTrain:(Company*)aComp;

- (NSString*) company:(Company*)aCompany BuysTrain:(NSString*)key AtCost:(int)aPrice;

- (NSString*) presidentHandsOverMaritimeCompanyTo:(Company*)aComp;

- (NSString*) companyConnectsToMaritimeCompany:(Company*)aComp;

- (NSString*) checkTrainLimits;

- (NSString*) player:(Player*)aPlayer BuysIpoShare:(Company*)aComp AtPrice:(int)aPrice;

- (NSString*) player:(Player*)aPlayer BuysBankShare:(Company*)aComp;

- (NSString*) player:(Player*)aPlayer BuysDragonShare:(Company*)aComp;

- (NSString*) player:(Player*)aPlayer SellsShare:(Company*)aComp;

- (void) updateStock;

- (NSString*) swapPresidentForCompany:(Company*)aComp;

- (void) saveGame;

- (NSArray*) getListOfCertificatesForSaleForPresident:(Company*)aComp;

- (Company*) getCompanyForSaleWithKey:(NSString*)key;

- (NSString*) shareholderTakesLoan:(Shareholder*)shareholder;

- (NSString*) shareholderPaysBackLoan:(Shareholder*)shareholder;

- (NSString*) company:(Company*)comp absorbsCompany:(Company*)target;

- (NSString*) downgradeMinesSentence;

@end
