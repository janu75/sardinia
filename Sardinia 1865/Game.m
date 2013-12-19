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
        for (NSString* name in self.compNames) {
            if (isShort) {
                if (!([name isEqualToString:@"CFC"] || [name isEqualToString:@"CFD"])) {
                    [companies addObject:[[Company alloc] initWithName:name IsMajor:NO AndSettings:self.settings]];
                }
            } else {
                [companies addObject:[[Company alloc] initWithName:name IsMajor:NO AndSettings:self.settings]];
            }
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
    if (comp.president == aPlayer && [comp getCertificatesByOwner:aPlayer]<2) {
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
    if (!comp.isOperating) {
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
        NSArray *stack = [self.companyStack copy]; // Need to copy as we are changing the stack within the loop!
        for (Company* comp in stack) {
            if (comp.presidentSoldShares) {
                [self decreaseStockPrice:comp];
                comp.presidentSoldShares = NO;
            }
        }
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
            Company *comp = [self.companyTurnOrder firstObject];
            [comp cleanFlagsForOperatingRound];
            self.operatingRoundNum = 1;
        }
    } else if ([self.round isEqualToString:@"Operating Round"]) {
        Company *comp = [self.companyTurnOrder firstObject];
        [self.companyTurnOrder removeObject:comp];
        comp = [self.companyTurnOrder firstObject];
        if (!comp) {
            if (self.operatingRoundNum==1) {
                self.operatingRoundNum=2;
                [self buildCompanyOrder];
                comp = [self.companyTurnOrder firstObject];
            } else {
                self.round = @"Stock Round";
                // FIXME: Add reminder to downgrade tokened mines here!
                // FIXME: Add conversion minor => major here!
                msg = [self dragonTurn];
            }
        }
        [comp cleanFlagsForOperatingRound];
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

- (void) sellTrain:(Train *)aTrain To:(id)newOwner {
    id oldOwner = aTrain.owner;
    [self sellTrain:aTrain To:newOwner AtCost:aTrain.cost];
    if (oldOwner == self) {
        Company *comp = newOwner;
        comp.boughtBrandNewTrain = YES;
    }
    if (aTrain.techLevel > self.settings.phase) {
        [self.settings enterNewPhase:aTrain.techLevel];
        [self checkTrainLimits];
    }
}

- (void) sellTrain:(Train *)aTrain To:(id)newOwner AtCost:(int)price {
    id oldOwner = aTrain.owner;
    Shareholder *newGuy = newOwner;
    [newGuy.trains addObject:aTrain];
    newGuy.money -= price;
    if (oldOwner == nil) {
        [self.trains removeObject:aTrain];
        self.bank.money += price;
    } else {
        Shareholder *oldGuy = oldOwner;
        [oldGuy.trains removeObject:aTrain];
        oldGuy.money += price;
    }
    aTrain.owner = newOwner;
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
            [list addObject:comp];
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

- (NSArray*) getTrainTextFromTrainList:(NSArray *)trainList ForCompany:(Company *)aComp {
    NSMutableArray *list      = [[NSMutableArray alloc] initWithCapacity:20];
    BOOL presidentMayPay = YES;
    if ([aComp.trains count]) {
        presidentMayPay = NO;
    } else {
        for (Train* train in trainList) {
            if (train.owner == nil || train.owner == self.bank) {
                if (aComp.money >= train.cost) {
                    presidentMayPay = NO;
                }
            }
        }
    }
    Player *president = (Player*) aComp.president;
    for (Train* train in trainList) {
        if (train.owner == nil) {
            if (train.cost <= aComp.money) {
                [list addObject:[NSString stringWithFormat:@"New Train: Capacity %d for L.%d", train.capacity, train.cost]];
            } else if (presidentMayPay) {
                [list addObject:[NSString stringWithFormat:@"New Train: Capacity %d for L.%d + %d (%@)", train.capacity, aComp.money, train.cost-aComp.money, president.name]];
            }
        } else if (train.owner == self.bank) {
            if (train.cost <= aComp.money) {
                [list addObject:[NSString stringWithFormat:@"Bank: Capacity %d for L.%d", train.capacity, train.cost]];
            } else {
                [list addObject:[NSString stringWithFormat:@"Bank: Capacity %d for L.%d + %d (%@)", train.capacity, train.cost, train.cost-aComp.money, president.name]];
            }
        } else {
            if (aComp.money > 0) {
                Company* comp = (Company*) train.owner;
                [list addObject:[NSString stringWithFormat:@"%@: Capacity %d for L.1 - %d", comp.shortName, train.capacity, aComp.money]];
            }
        }
    }
    return list;
}

- (NSArray*) getTrainsForPurchaseForCompany:(Company *)aComp {
    NSMutableArray *trainList = [[NSMutableArray alloc] initWithCapacity:20];
    [trainList addObject:[self.trains firstObject]];
    [trainList addObjectsFromArray:self.bank.trains];
    for (Company *comp in self.companies) {
        if (aComp != comp) {
            [trainList addObjectsFromArray:comp.trains];
        }
    }
    return trainList;
}

- (BOOL) companyCanBuyTrain:(Company *)aComp {
    if (!aComp.didOperateThisTurn) {
        return NO;
    }
    if ([aComp.trains count] == 0) {
        return YES;
    }
    if (aComp.money > 0) {
        return YES;
    }
    return NO;
}

- (NSString*) company:(Company *)aCompany BuysTrain:(NSUInteger)num AtCost:(int)aPrice {
    NSArray *list = [self getTrainsForPurchaseForCompany:aCompany];
    Train *train = list[num];
    
    NSString *transaction;
    if (train.owner==nil || train.owner==self.bank) {
        if (aCompany.money < train.cost) {
            transaction = @"FIXME: President has to help out, not implemented yet";
        } else {
            if (train.owner==nil) {
                transaction = [NSString stringWithFormat:@"%@ buys a new Train with capacity %d for %d", aCompany.shortName, train.capacity, aPrice];
            } else {
                transaction = [NSString stringWithFormat:@"%@ buys a Train with capacity %d for %d from the bank", aCompany.shortName, train.capacity, aPrice];
            }
            [self sellTrain:train To:aCompany];
            [aCompany buyTrain:train];
        }
    } else {
        [self sellTrain:train To:aCompany AtCost:aPrice];
        transaction = [NSString stringWithFormat:@"%@ buys a used train with capacity %d for %d from %@", aCompany.shortName, train.capacity, aPrice, [train.owner shortName]];
    }
    return transaction;
}

- (NSString*) presidentHandsOverMaritimeCompanyTo:(Company *)aComp {
    Player* president = (Player*) aComp.president;
    MaritimeCompany* mc = [president.maritimeCompany firstObject];
    [president.maritimeCompany removeObject:mc];
    [aComp.maritimeCompanies addObject:mc];
    aComp.traffic += 8;
    return [NSString stringWithFormat:@"%@ hands over maritime company to %@", president.name, aComp.shortName];
}

- (NSString*) companyConnectsToMaritimeCompany:(Company *)aComp {
    [aComp.maritimeCompanies removeLastObject];
    aComp.traffic += self.settings.phase;
    return [NSString stringWithFormat:@"%@ connects to maritime company for %d additional traffic", aComp.shortName, self.settings.phase];
}

- (NSString*) checkTrainLimits {
    NSMutableString *msg = [[NSMutableString alloc] init];
    for (Company* comp in self.companies) {
        for (Train* train in comp.trains) {
            if ([train.rustsAt intValue] == self.settings.phase) {
                [comp.trains removeObject:train];
                comp.trainCapacity -= train.capacity;
                [msg appendString:[NSString stringWithFormat:@"Scrapped train with capacity %d from %@", train.capacity, comp.shortName]];
            }
        }
        while ([comp.trains count]> self.settings.trainLimit) {
            Train *train = [comp.trains firstObject];
            [comp.trains removeObject:train];
            [msg appendString:[NSString stringWithFormat:@"%@ has more trains than limit of %d! Train with capacity %d goes to bank", comp.shortName, self.settings.trainLimit, train.capacity]];
            [self.bank.trains addObject:train];
        }
    }
    for (Train* train in self.bank.trains) {
        if ([train.rustsAt intValue] == self.settings.phase) {
            [self.bank.trains removeObject:train];
            [msg appendString:[NSString stringWithFormat:@"Scrapped train with capacity %d from bank", train.capacity]];
        }
    }
    return msg;
}

- (NSString*) player:(Player *)aPlayer BuysIpoShare:(Company *)aComp AtPrice:(int)aPrice {
    if ([aComp getShareByOwner:aComp] == 100) {
        // Initial offer
        [aComp setInitialStockPrice:aPrice];
        [self addToCompanyStack:aComp];
    }
    Certificate *cert = [aComp certificateFromOwner:aComp];
    [aComp sellCertificate:cert To:aPlayer];
    return [NSString stringWithFormat:@"%@ buys %@ of %@ from Initial Offer", aPlayer.name, cert.type, aComp.shortName];
}

- (NSString*) player:(Player *)aPlayer BuysBankShare:(Company *)aComp {
    Certificate *cert = [aComp certificateFromOwner:self.bank];
    [aComp sellCertificate:cert To:aPlayer];
    return [NSString stringWithFormat:@"%@ buys %@ of %@ from Bank", aPlayer.name, cert.type, aComp.shortName];
}

- (NSString*) player:(Player *)aPlayer BuysDragonShare:(Company *)aComp {
    Certificate *cert = [aComp certificateFromOwner:self.dragon];
    [aComp sellCertificate:cert To:aPlayer];
    return [NSString stringWithFormat:@"%@ buys %@ of %@ from Dragon", aPlayer.name, cert.type, aComp.shortName];
}

- (NSString*) player:(Player *)aPlayer SellsShare:(Company *)aComp {
    if (aPlayer == aComp.president) {
        aComp.presidentSoldShares = YES;
    }
    Certificate *cert = [aComp certificateFromOwner:aPlayer];
    [aComp sellCertificate:cert To:self.bank];
    [aPlayer.soldCompanies addObject:aComp];
    return [NSString stringWithFormat:@"%@ sells %@ of %@ to Bank", aPlayer.name, cert.type, aComp.shortName];
}

@end
