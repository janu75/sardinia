//
//  Game.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "Game.h"
#import "Company.h"
#import "GameSettings.h"

@implementation Game

- (id) initWithPlayers:(NSArray *)playerNames AndShortMode:(BOOL)isShort {
    self = [super init];
    if (self) {
        self.settings = [[GameSettings alloc] init];
        self.settings.isShortGame = isShort;
        self.settings.numPlayers = [playerNames count];
        NSMutableArray *companies = [[NSMutableArray alloc] initWithCapacity:8];
        self.compNames = [self.settings companyShortNames];
        int i=0;
        for (NSString *name in self.compNames) {
            if (!isShort || i<6) {
                [companies addObject:[[Company alloc] initWithName:name IsMajor:NO AndSettings:self.settings]];
            }
            i++;
        }
        self.companies = companies;
        self.companyStack = [[NSMutableArray alloc] initWithCapacity:8];
        int bankMoney = (isShort) ? 6000 : 8000;
        self.bank   = [[Bank alloc] initWithMoney:bankMoney];
        int playerMoney = 300;
        if ([playerNames count] == 3) playerMoney = 330;
        if ([playerNames count] == 2) playerMoney = 360;
        NSMutableArray *players = [[NSMutableArray alloc] initWithCapacity:4];
        for (NSString* name in playerNames) {
            [players addObject:[[Player alloc] initWithName:name AndMoney:playerMoney]];
            self.bank.money -= playerMoney;
        }
        self.trains = [self.settings generateTrains];
        self.dragon = [[Dragon alloc] initWithName:@"Dragon"];
        self.player = players;
        [self shufflePlayers];
        self.currentPlayer = self.player[0];
        self.startPlayer = self.player[0];
        self.round = @"Stock Round";
    }
    return self;
}

- (BOOL) player:(Shareholder *)aPlayer CanBuy:(NSUInteger)nComp FromShareholder:(Shareholder*)aShareholder {
    BOOL canBuy = NO;
    Company *comp = self.companies[nComp];
    int stockprice = comp.stockPrice;
    if (stockprice == 0) stockprice = 2*60;  // Initial offering: stockprice not set yet, set to 2*min for canBuy check
    if ([aShareholder.name isEqualToString:@"Dragon"]) {
        if ([comp isDragonBuy]) {
            stockprice = [self.settings getDragonPriceWithStockPrice:stockprice AndGrade:@"Buy"];
        } else if ([comp isDragonSell]) {
            stockprice = [self.settings getDragonPriceWithStockPrice:stockprice AndGrade:@"Sell"];
        } else {
            stockprice = [self.settings getDragonPriceWithStockPrice:stockprice AndGrade:@"Neutral"];
        }

    }
    int playerShare       = [comp getShareByOwner:aPlayer];
    int shareholderShare  = [comp getShareByOwner:aShareholder];
    int shareLimit        = aPlayer.isPlayer ? 60 : 50;
    if (playerShare < shareLimit && shareholderShare > 0) {
        canBuy = YES;
    }
    if (aPlayer.isPlayer && aPlayer.money < stockprice) {
        canBuy = NO;
    }
    if ([comp getCertificatesByOwner:aPlayer] == [self.settings certificateLimit:aPlayer.name InPhase:self.settings.phase]) {
        canBuy = NO;
    }
    if (aPlayer.isPlayer) {
        Player *player = (Player*) aPlayer;
        if ([player.soldCompanies containsObject:comp]) {
            canBuy = NO;
        }
    }
    return canBuy;
}

- (BOOL) player:(Shareholder *)aPlayer CanBuyFromBank:(NSUInteger)nComp {
    return [self player:aPlayer CanBuy:nComp FromShareholder:self.bank];
}

- (BOOL) player:(Shareholder *)aPlayer CanBuyFromDragon:(NSUInteger)nComp {
    return [self player:aPlayer CanBuy:nComp FromShareholder:self.dragon];
}

- (BOOL) player:(Shareholder *)aPlayer CanBuyFromIpo:(NSUInteger)nComp {
    return [self player:aPlayer CanBuy:nComp FromShareholder:self.companies[nComp]];
}

- (BOOL) player:(Shareholder *)aPlayer CanSell:(NSUInteger)nComp {
    Company *comp = self.companies[nComp];
    BOOL canSell = NO;
    if (comp.president == aPlayer) {
        for (Player *player in self.player) {
            if (player != aPlayer) {
                if ([comp getCertificatesByOwner:player] > 1) {
                    canSell = YES;
                }
            }
        }
    } else {
        if ([comp getShareByOwner:aPlayer] > 0) {
            canSell = YES;
        }
    }
    if ([comp getShareByOwner:self.bank] > 40) {
        canSell = NO;
    }
    return canSell;
}

- (void) shufflePlayers {
    self.player = [self.player sortedArrayUsingComparator:^(id obj1, id obj2) {
        if ((arc4random() % 100) > 49) {
            return (NSComparisonResult) NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedAscending;
    }];
}

- (void) buildCompanyOrder {
    self.companyTurnOrder = [NSMutableArray arrayWithArray:self.companyStack];
}

- (NSString*) advancePlayersDidPass:(BOOL)didPass {
    NSString *msg;
    if ([self.round isEqualToString:@"Maritime Companies"]) {
        if ([self.startPlayer.maritimeCompany count] < 2) {
            NSUInteger i = [self.player indexOfObject:self.currentPlayer];
            self.currentPlayer = self.player[(i+1) % [self.player count]];
        } else {
            self.round = @"Stock Round";
            self.settings.phase = 2;
            self.currentPlayer = self.startPlayer;
            self.passCount = 0;
            msg = [self dragonTurn];
        }
    } else if ([self.round isEqualToString:@"Stock Round"]) {
        NSUInteger i = [self.player indexOfObject:self.currentPlayer];
        self.currentPlayer = self.player[(i+1) % [self.player count]];
        if (didPass) {
            self.passCount++;
        } else {
            self.startPlayer = self.currentPlayer;
            self.passCount = 0;
        }
        msg = [self dragonTurn];
        if (self.passCount == [self.player count]) {
            self.round = @"Operating Round";
            for (Player *player in self.player) {
                [player.soldCompanies removeAllObjects];
            }
            [self buildCompanyOrder];
        }
    } else if ([self.round isEqualToString:@"Operating Round"]) {
        Company *comp = [self.companyTurnOrder firstObject];
        [self.companyTurnOrder removeObject:comp];
        comp = [self.companyTurnOrder firstObject];
        comp.didOperateThisTurn = NO;
    }
    return msg;
}

- (NSUInteger) dragonValue:(Company*)aComp {
    // Priority order:
    // 1. Diversify
    // 2. Highest Rank
    // 3. Cheapest
    // 4. Top of Pile (== index of companyStack)
    // Generate an integer for each company:
    // value bits  6          4     9         3
    //             Diversify  Rank  Cheapest  Top of Pile
    NSUInteger val = [aComp getShareByOwner:self.dragon]<<(4+9+3);
    val = val | ([aComp rank]<<(9+3));
    val = val | (aComp.stockPrice<<3);
    val = val | ([self.companyStack indexOfObject:aComp]);
    return val;
}

- (NSString*) dragonTurn {
    NSString *log = @"";
    // Build arrays for selling & buying
    NSMutableArray *sellCompanies = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *buyCompanies = [[NSMutableArray alloc] initWithCapacity:8];
    for (Company* comp in self.companies) {
        if ([comp isDragonBuy])  [buyCompanies addObject:comp];
        if ([comp isDragonSell]) [sellCompanies addObject:comp];
    }
    // First, sell all companies
    for (Company *comp in sellCompanies) {
        if ([self player:self.dragon CanSell:[self.companies indexOfObject:comp]]) {
            Certificate *cert = [comp certificateFromOwner:self.dragon];
            [comp sellCertificate:cert To:self.bank];
            log = [NSString stringWithFormat:@"%@Dragon sells %@ (%@)\n", log, comp.name, comp.shortName];
        }
    }
    // Buy one company. First sort by preference, then try to buy one
    buyCompanies = [[buyCompanies sortedArrayUsingComparator:^(id obj1, id obj2) {
        Company *comp1 = obj1;
        Company *comp2 = obj2;
        NSUInteger v1 = [self dragonValue:comp1];
        NSUInteger v2 = [self dragonValue:comp2];
        
        if (v1 < v2)
            return NSOrderedAscending;
        else if (v1 > v2)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
        
    }] mutableCopy];
    for (Company *comp in buyCompanies) {
        NSUInteger compNum = [self.companies indexOfObject:comp];
        if ([self player:self.dragon CanBuyFromIpo:compNum]) {
            Certificate *cert = [comp certificateFromOwner:comp];
            [comp sellCertificate:cert To:self.dragon];
            log = [NSString stringWithFormat:@"%@Dragon buys %@ (%@) from initial Offer\n", log, comp.name, comp.shortName];
            return log;
        }
        if ([self player:self.dragon CanBuyFromBank:compNum]) {
            Certificate *cert = [comp certificateFromOwner:self.bank];
            [comp sellCertificate:cert To:self.dragon];
            log = [NSString stringWithFormat:@"%@Dragon buys %@ (%@) from bank\n", log, comp.name, comp.shortName];
            return log;
        }
    }
    return log;
}

- (BOOL) isStockRound {
    if ([self.round isEqualToString:@"Stock Round"]) return YES;
    return NO;
}

- (void) sellTrain:(Train *)aTrain From:(id)oldOwner To:(id)newOwner {
    [self sellTrain:aTrain From:oldOwner To:newOwner AtCost:aTrain.cost];
    if (oldOwner == self) {
        Company *comp = newOwner;
        comp.boughtBrandNewTrain = YES;
    }
}

- (void) sellTrain:(Train *)aTrain From:(id)oldOwner To:(id)newOwner AtCost:(int)price {
    Shareholder *newGuy = newOwner;
    [newGuy.trains addObject:aTrain];
    newGuy.money -= price;
    if (oldOwner == self) {
        [self.trains removeObject:aTrain];
        self.bank.money += price;
    } else {
        Shareholder *oldGuy = oldOwner;
        [oldGuy.trains removeObject:aTrain];
        oldGuy.money += price;
    }
}

- (int) getMaxInitialStockPrice {
    if (self.settings.phase < 3) {
        return 100;
    } else if (self.settings.phase < 5) {
        return 130;
    }
    return 150;
}

- (void) addToCompanyStack:(Company *)aComp {
    NSUInteger index = 0;
    for (Company *comp in self.companyStack) {
        if (aComp.stockPrice > comp.stockPrice) {
            [self.companyStack insertObject:aComp atIndex:index];
            return;
        }
        index++;
    }
    [self.companyStack insertObject:aComp atIndex:index];
}

- (void) removeFromCompanyStack:(Company *)aComp {
    [self.companyStack removeObject:aComp];
}

- (void) increaseStockPrice:(Company *)aComp {
    [aComp increaseStockPrice];
    [self removeFromCompanyStack:aComp];
    [self addToCompanyStack:aComp];
}

- (void) decreaseStockPrice:(Company *)aComp {
    [aComp decreaseStockPrice];
    [self removeFromCompanyStack:aComp];
    [self addToCompanyStack:aComp];
}

- (NSArray*) companyCanAbsorb:(Company *)aComp {
    if (!aComp.isOperating) {
        return nil;
    }
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:7];
    for (Company* comp in self.companyStack) {
        if (comp != aComp && comp.isOperating && aComp.president == comp.president) {
            // Todo: Add share price check!
            NSLog(@"Todo: Need to check if companies have enough money for this!");
            [list addObject:comp.shortName];
        }
    }
    return list;
}

- (BOOL) companyCanGetAbsorbed:(Company *)aComp {
    if (!aComp.isOperating) {
        return NO;
    }
    for (Company* comp in self.companyStack) {
        if (comp != aComp && comp.isOperating && aComp.president == comp.president) {
            return NO;
            // Todo: Add share price check!
            NSLog(@"Todo: Need to check if companies have enough money for this!");
        }
    }
    return NO;
}

- (NSArray*) getTrainsForPurchase {
    Train *train = [self.trains firstObject];
    NSMutableArray *list = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"New Train: Capacity %d for L.%d", train.capacity, train.cost]];
    for (Train *aTrain in self.bank.trains) {
        [list addObjectsFromArray:[NSMutableArray arrayWithObject:[NSString stringWithFormat:@"Bank: Capacity %d for L.%d", aTrain.capacity, aTrain.cost]]];
    }
    NSLog(@"Todo: Buy trains from other companies");
    return list;
}

@end
