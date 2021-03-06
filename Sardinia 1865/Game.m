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

- (id) initWithPlayers:(NSArray *)playerNames AndShortMode:(BOOL)isShort AndSounds:(NSArray *)sounds {
    self = [super init];
    if (self) {
        self.settings = [[GameSettings alloc] init];
        self.settings.isShortGame = isShort;
        self.settings.numPlayers = [playerNames count];
        int bankMoney = (isShort) ? 6000 : 8000;
        self.bank   = [[Bank alloc] initWithMoney:bankMoney];
        NSMutableArray *companies = [[NSMutableArray alloc] initWithCapacity:8];
        self.compNames = [self.settings companyShortNames];
        for (NSString* name in self.compNames) {
            if (isShort) {
                if (!([name isEqualToString:@"CFC"] || [name isEqualToString:@"CFD"])) {
                    [companies addObject:[[Company alloc] initWithName:name IsMajor:NO AndSettings:self.settings AndBank:self.bank]];
                }
            } else {
                [companies addObject:[[Company alloc] initWithName:name IsMajor:NO AndSettings:self.settings AndBank:self.bank]];
            }
        }
        self.companies = companies;
        self.companyStack = [[NSMutableArray alloc] initWithCapacity:8];
        int playerMoney = 300;
        if ([playerNames count] == 3) playerMoney = 330;
        if ([playerNames count] == 2) playerMoney = 360;
        NSMutableArray *players = [[NSMutableArray alloc] initWithCapacity:4];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm"];
        NSDate *date = [NSDate date];
        NSString *dateString = [dateFormatter stringFromDate:date];
//        NSURL *myUrl = [NSURL URLWithString:@"Save Games"];
//        NSBundle *appBundle = [NSBundle mainBundle];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES) firstObject];
        NSMutableString *dirName = [NSMutableString stringWithFormat:@"%@/1865-Sardinia/", path];
//        [dirName appendString:@"/"];
        [dirName appendString:dateString];
        NSInteger index = 0;
        for (NSString* name in playerNames) {
            [players addObject:[[Player alloc] initWithName:name AndMoney:playerMoney AndBank:self.bank AndSound:sounds[index++]]];
            self.bank.money -= playerMoney;
            [dirName appendString:[NSString stringWithFormat:@"-%@", name]];
        }
        if (isShort) {
            [dirName appendString:@"-short"];
        }
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error;
//        NSLog(@"Attempting to create %@", dirName);
        [fm createDirectoryAtPath:dirName withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"Creating directory failed: %@", error.localizedDescription);
        }
        self.dirName = dirName;
        self.trains = [self.settings generateTrains];
        self.dragon = [[Dragon alloc] initWithName:@"Dragon"];
        self.player = players;
        [self shufflePlayers];
        self.currentPlayer = self.player[0];
        self.startPlayer = self.player[0];
        self.round = @"Stock Round";
        self.turnCount = 0;
        self.saveGames = [[NSMutableDictionary alloc] initWithCapacity:1000];
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
    Certificate *cert = [comp certificateFromOwner:aShareholder];
    int shareAmount = cert.share;
    if (playerShare+shareAmount <= shareLimit && shareholderShare > 0) {
        canBuy = YES;
    }
    if (aPlayer.isPlayer && aPlayer.money < stockprice) {
        canBuy = NO;
    }
    if (aPlayer.numCertificates >= [self.settings certificateLimit:aPlayer.name]) {
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
    for (Company *comp in self.companyStack) {
        if (!comp.isFloating) {
            [self.companyTurnOrder removeObject:comp];
        }
    }
    self.frozenTurnOrder = [self.companyTurnOrder copy];
}

- (NSString*) advancePlayersDidPass:(BOOL)didPass {
    NSString *msg = @"";
    self.turnCount++;
    [self updateStock];
    if (self.bank.money + self.dragon.money < 0) {
        self.bank.ranOutOfMoney = YES;
    }
    if ([self.round isEqualToString:@"Maritime Companies"]) {
        if ([self.startPlayer.maritimeCompany count] < 2) {
            // Dead code?
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
                msg = [NSString stringWithFormat:@"%@%@", [player incomeFromMaritimeCompanies], msg];
            }
            [self buildCompanyOrder];
            self.operatingRoundNum = 1;
            for (Company *c in self.companyTurnOrder) {
                [c cleanFlagsForOperatingRound];
            }
        }
    } else if ([self.round isEqualToString:@"Operating Round"]) {
        Company *comp = [self.companyTurnOrder firstObject];
        [self.companyTurnOrder removeObject:comp];
        comp = [self.companyTurnOrder firstObject];
        if (!comp) {
            if (self.operatingRoundNum==1) {
                self.operatingRoundNum=2;
                [self buildCompanyOrder];
                for (Company *c in self.companyTurnOrder) {
                    [c cleanFlagsForOperatingRound];
                }
            } else {
                // Prepare for stock round => Bureaucracy
                // Only needed if minor companies exist or phase is > 2
                BOOL conversionPossible = NO;
                for (Company *aComp in self.companies) {
                    if ([aComp canConvertToMajor]) {
                        conversionPossible = YES;
                    }
                    if (aComp.isFloating) {
                        [aComp updateDragonRowInPhase:self.settings.phase];
                    }
                }
                if (self.settings.phase > 2 || conversionPossible) {
                    self.round = @"Bureaucracy";
                } else {
                    self.round = @"Stock Round";
                    self.passCount = 0;
                    msg = [self dragonTurn];
                }
            }
        }
    } else if ([self.round isEqualToString:@"Bureaucracy"]) {
        self.round = @"Stock Round";
        self.passCount = 0;
        msg = [self dragonTurn];
    }
    [self saveGame];
    [self PlaySound];
    return msg;
}

- (void) PlaySound {
    if ([self.round isEqualToString:@"Stock Round"]) {
        [[NSSound soundNamed:[self.currentPlayer sound]] play];
    } else if ([self.round isEqualToString:@"Operating Round"]) {
        Company *comp = [self.companyTurnOrder firstObject];
        Player *president = (Player*) comp.president;
        [[NSSound soundNamed:president.sound] play];
    } else {
        [[NSSound soundNamed:@"Purr"] play];
    }
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
    // Sort will be low to high
    NSUInteger val = (6-[aComp getShareByOwner:self.dragon])<<(4+9+3);
    val = val | ((30-[aComp rank])<<(9+3));
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
        while ([self player:self.dragon CanSell:[self.companies indexOfObject:comp]]) {
            Certificate *cert = [comp certificateFromOwner:self.dragon];
            [comp sellCertificate:cert To:self.bank];
            comp.presidentSoldShares++;
            log = [NSString stringWithFormat:@"%@Dragon sells %@ (%@)", log, comp.name, comp.shortName];
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
            log = [NSString stringWithFormat:@"%@Dragon buys %@ (%@) from initial Offer", log, comp.name, comp.shortName];
            return log;
        }
        if ([self player:self.dragon CanBuyFromBank:compNum]) {
            Certificate *cert = [comp certificateFromOwner:self.bank];
            [comp sellCertificate:cert To:self.dragon];
            log = [NSString stringWithFormat:@"%@Dragon buys %@ (%@) from bank", log, comp.name, comp.shortName];
            return log;
        }
    }
    return log;
}

- (BOOL) isStockRound {
    if ([self.round isEqualToString:@"Stock Round"]) return YES;
    return NO;
}

- (NSString*) sellTrain:(Train *)aTrain To:(id)newOwner {
    id oldOwner = aTrain.owner;
    NSString *msg = [self sellTrain:aTrain To:newOwner AtCost:aTrain.cost];
    if (oldOwner == nil) {
        Company *comp = newOwner;
        comp.boughtBrandNewTrain = YES;
    }
    if (aTrain.techLevel > self.settings.phase) {
        msg = [NSString stringWithFormat:@"%@%@", msg, [self.settings enterNewPhase:aTrain.techLevel]];
        msg = [NSString stringWithFormat:@"%@%@", msg, [self checkTrainLimits]];
    }
    return msg;
}

- (NSString*) sellTrain:(Train *)aTrain To:(id)newOwner AtCost:(int)price {
//    NSString *msg;
    id oldOwner = aTrain.owner;
    Shareholder *newGuy = newOwner;
    [newGuy.trains addObject:aTrain];
    newGuy.money -= price;
    if (oldOwner == nil) {
        [self.trains removeObject:aTrain];
        self.bank.money += price;
//        msg = [NSString stringWithFormat:@"%@ bought new level %d train", newGuy.name, aTrain.techLevel];
    } else {
        Shareholder *oldGuy = oldOwner;
        [oldGuy.trains removeObject:aTrain];
        oldGuy.money += price;
//        msg = [NSString stringWithFormat:@"%@ bought level %d train from %@", newGuy.name, aTrain.techLevel, oldGuy.name];
    }
    aTrain.owner = newOwner;
//    return msg;
    return @"";
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
    if (aComp.didOperateThisTurn) {
        return nil;
    }
    int ipoMoney = [aComp getShareByOwner:aComp];
    if (aComp.isMajor) {
        ipoMoney = MIN(ipoMoney, 50-[aComp getShareByOwner:self.bank]);
        ipoMoney = ipoMoney / 10 * aComp.stockPrice;
    } else {
        ipoMoney = MIN(ipoMoney, 40-[aComp getShareByOwner:self.bank]);
        ipoMoney = ipoMoney / 20 * aComp.stockPrice;
    }
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:7];
    for (Company* comp in self.companyStack) {
        if (comp != aComp && comp.isOperating && aComp.president == comp.president && !comp.didOperateThisTurn) {
            int cost = [comp getCompanyCost];
//            int ipoMoney = [aComp getShareByOwner:aComp] * aComp.stockPrice;
            NSInteger totalMoney = aComp.money + comp.money + ipoMoney - 500*(aComp.numLoans + comp.numLoans);
            // Absorbing company may hold max of three loans after merger
            if (totalMoney - cost >= -1500) {
                [list addObject:comp];
            }
        }
    }
    return list;
}

- (BOOL) companyCanGetAbsorbed:(Company *)aComp {
    if (!aComp.isOperating) {
        return NO;
    }
    if (aComp.didOperateThisTurn) {
        return NO;
    }
    // Can only get absorbed if company later in stack can absorb
    BOOL found = NO;
    for (Company* comp in self.frozenTurnOrder) {
        if (comp == aComp) {
            found = YES;
        } else {
            if (found && comp.isOperating && aComp.president == comp.president && !comp.didOperateThisTurn) {
                return YES;
            }
        }
    }
    return NO;
}

- (NSDictionary*) buildTrainListWithTextForCompany:(Company*)aComp {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:20];
    // Build a list of all trains not owned by this company
    NSMutableArray *trainList = [[NSMutableArray alloc] initWithCapacity:20];
    [trainList addObject:[self.trains firstObject]];
    [trainList addObjectsFromArray:self.bank.trains];
    for (Company *comp in self.companies) {
        if (aComp != comp) {
            [trainList addObjectsFromArray:comp.trains];
        }
    }
    // Check if company if forced to buy a train and if president may help out in buying from bank or new train stack
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
    int i=0;
    for (Train* train in trainList) {
        if (train.owner == nil) {
            if (train.cost <= aComp.money) {
                NSString *key = [NSString stringWithFormat:@"%02d: New Train %d: Capacity %d for L.%d", i, train.techLevel, train.capacity, train.cost];
                [dict setObject:train forKey:key];
            } else if (presidentMayPay) {
                NSString *key = [NSString stringWithFormat:@"%02d: New Train %d: Capacity %d for L.%ld + %ld (%@)", i, train.techLevel, train.capacity, (long)aComp.money, train.cost-aComp.money, president.name];
                [dict setObject:train forKey:key];
            }
        } else if (train.owner == self.bank) {
            if (train.cost <= aComp.money) {
                NSString *key = [NSString stringWithFormat:@"%02d: Bank %d: Capacity %d for L.%d", i, train.techLevel, train.capacity, train.cost];
                [dict setObject:train forKey:key];
            } else if (presidentMayPay) {
                NSString *key = [NSString stringWithFormat:@"%02d: Bank %d: Capacity %d for L.%d + %ld (%@)", i, train.techLevel, train.capacity, train.cost, train.cost-aComp.money, president.name];
                [dict setObject:train forKey:key];
            }
        } else {
            if (aComp.money > 0) {
                Company* comp = (Company*) train.owner;
                NSString *key = [NSString stringWithFormat:@"%02d: %@ %d: Capacity %d for L.1 - %ld", i, comp.shortName, train.techLevel, train.capacity, (long)aComp.money];
                [dict setObject:train forKey:key];
            }
        }
        i++;
    }
    return dict;
}

- (NSArray*) getTrainTextForCompany:(Company *)aComp {
    NSDictionary *dict = [self buildTrainListWithTextForCompany:aComp];
    NSArray *keys = [dict allKeys];
    NSArray *text = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    return text;
}

- (Train*) getTrainForPurchaseForCompany:(Company *)aComp WithText:(NSString *)aKey {
    NSDictionary *dict = [self buildTrainListWithTextForCompany:aComp];
    return (Train*) dict[aKey];
}

- (BOOL) companyCanBuyTrain:(Company *)aComp {
    if (!aComp.didOperateThisTurn) {
        return NO;
    }
    if ([aComp.trains count] == 0) {
        return YES;
    }
    if ([aComp.trains count] == self.settings.trainLimit) {
        return NO;
    }
    if (aComp.money > 0) {
        return YES;
    }
    return NO;
}

- (NSString*) company:(Company *)aCompany BuysTrain:(NSString*)key AtCost:(int)aPrice {
    Train *train = [self getTrainForPurchaseForCompany:aCompany WithText:key];
    
    NSString *transaction;
    if (train.owner==nil || train.owner==self.bank) {
        if (aCompany.money < train.cost) {
            Player *president = (Player*) aCompany.president;
            NSInteger diff = train.cost - aCompany.money;
            if (train.owner==nil) {
                transaction = [NSString stringWithFormat:@"%@ buys a new Train with capacity %d for %d. %@ adds %ld.", aCompany.shortName, train.capacity, aPrice, president.name, (long)diff];
            } else {
                transaction = [NSString stringWithFormat:@"%@ buys a Train with capacity %d for %d from the bank. %@ adds %ld.", aCompany.shortName, train.capacity, aPrice, president.name, (long)diff];
            }
            [self sellTrain:train To:aCompany];
            [aCompany buyTrain:train];
            aCompany.money += diff;
            president.money -= diff;
        } else {
            if (train.owner==nil) {
                transaction = [NSString stringWithFormat:@"%@ buys a new Train with capacity %d for %d", aCompany.shortName, train.capacity, train.cost];
            } else {
                transaction = [NSString stringWithFormat:@"%@ buys a Train with capacity %d for %d from the bank", aCompany.shortName, train.capacity, train.cost];
            }
            transaction = [NSString stringWithFormat:@"%@%@", transaction, [self sellTrain:train To:aCompany]];
            [aCompany buyTrain:train];
        }
    } else {
        Company *otherComp = train.owner;
        transaction = [NSString stringWithFormat:@"%@ buys a used train with capacity %d for %d from %@", aCompany.shortName, train.capacity, aPrice, [train.owner shortName]];
        [self sellTrain:train To:aCompany AtCost:aPrice];
        [aCompany buyTrain:train];
        [otherComp sellTrain:train];
    }
    return transaction;
}

- (NSString*) presidentHandsOverMaritimeCompanyTo:(Company *)aComp {
    Player* president = (Player*) aComp.president;
    MaritimeCompany* mc = [president.maritimeCompany firstObject];
    [president.maritimeCompany removeObject:mc];
    [aComp.maritimeCompanies addObject:mc];
    aComp.trainCapacity += 8;
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
        [comp sortTrains];  // Make sure that the old trains are the first ones in the list
        for (Train* train in [comp.trains copy]) {
            if ([train.rustsAt intValue] == self.settings.phase) {
                [comp.trains removeObject:train];
                comp.trainCapacity -= train.capacity;
                [msg appendString:[NSString stringWithFormat:@"Scrapped train with capacity %d from %@\n", train.capacity, comp.shortName]];
            }
        }
        while ([comp.trains count]> self.settings.trainLimit) {
            Train *train = [comp.trains firstObject];
            comp.trainCapacity -= train.capacity;
            [comp.trains removeObject:train];
            [msg appendString:[NSString stringWithFormat:@"%@ has more trains than limit of %d! Train with capacity %d goes to bank\n", comp.shortName, self.settings.trainLimit, train.capacity]];
            [self.bank.trains addObject:train];
            train.owner = self.bank;
        }
    }
    for (Train* train in [self.bank.trains copy]) {
        if ([train.rustsAt intValue] == self.settings.phase) {
            [self.bank.trains removeObject:train];
            [msg appendString:[NSString stringWithFormat:@"Scrapped train with capacity %d from bank\n", train.capacity]];
        }
    }
    if (self.settings.phase > 4) {
        for (Player *player in self.player) {
            if ([player.maritimeCompany count]) {
                [player.maritimeCompany removeAllObjects];
                [msg appendString:[NSString stringWithFormat:@"Player %@ closed all maritime companies\n", player.name]];
            }
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
    [self buildCompanyOrder];
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
    NSString *msg = @"";
    if (aPlayer == aComp.president) {
        aComp.presidentSoldShares++;
    }
    Certificate *cert = [aComp certificateFromOwner:aPlayer];
    if ([cert.type hasPrefix:@"President"]) {
        msg = [self swapPresidentForCompany:aComp];
        cert = [aComp certificateFromOwner:aPlayer];
    }
    [aComp sellCertificate:cert To:self.bank];
    [aPlayer.soldCompanies addObject:aComp];
    return [NSString stringWithFormat:@"%@ sells %@ of %@ to Bank\n%@", aPlayer.name, cert.type, aComp.shortName, msg];
}

- (void) updateStock {
    if ([self.round isEqualToString:@"Operating Round"]) {
        Company *comp = [self.companyTurnOrder firstObject];
        if (comp.lastIncome==0 && comp.isOperating) {
            [self decreaseStockPrice:comp];
        }
        if (comp.paidDividend) {
            [self increaseStockPrice:comp];
        }
        if (comp.boughtBrandNewTrain) {
            [self increaseStockPrice:comp];
        }
    }
    NSArray *stack = [self.companyStack copy]; // Need to copy as we are changing the stack within the loop!
    for (Company* comp in stack) {
        [comp updatePresident];
        while (comp.presidentSoldShares) {
            [self decreaseStockPrice:comp];
            comp.presidentSoldShares--;
        }
    }
}

- (NSString*) swapPresidentForCompany:(Company *)aComp {
    // President tries to sell his presidential share, and needs to exchange it with two normal shares
    // For his turn during the stock round, he still counts as the president, even though he lost the presidential share
    NSMutableDictionary *shares = [[NSMutableDictionary alloc] initWithCapacity:4];
    int maxShares = 0;
    for (Player* player in self.player) {
        int share = [aComp getShareByOwner:player];
        shares[player.name] = [NSNumber numberWithInt:share];
        if (share > maxShares) maxShares = share;
    }
    NSUInteger index = [self.player indexOfObject:aComp.president];
    for (NSUInteger i=1; i<[self.player count]-1; i++) {
        NSUInteger playerIndex = (index + i) % [self.player count];
        Player *newPres = self.player[playerIndex];
        int sh = [shares[newPres.name] intValue];
        if (sh == maxShares) {
            Certificate *cert = [aComp certificateFromOwner:newPres];
            cert.owner = aComp.president;
            cert = [aComp certificateFromOwner:newPres];
            cert.owner = aComp.president;
            cert = aComp.certificates[0];
            cert.owner = newPres;
            aComp.president.numCertificates++;
            newPres.numCertificates--;
            return [NSString stringWithFormat:@"Presidency of %@ changes from %@ to %@", aComp.shortName, aComp.president.name, newPres.name];
        }
    }
    return @"Error: Could not swap president's share with anyone else. This should not happen...";
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.player forKey:@"Game Player"];
    [aCoder encodeObject:self.settings forKey:@"Game Settings"];
    [aCoder encodeObject:self.compNames forKey:@"Game CompNames"];
    [aCoder encodeObject:self.bank forKey:@"Game Bank"];
    [aCoder encodeObject:self.dragon forKey:@"Game Dragon"];
    [aCoder encodeObject:self.currentPlayer forKey:@"Game CurrentPlayer"];
    [aCoder encodeObject:self.startPlayer forKey:@"Game StartPlayer"];
    [aCoder encodeObject:self.companyStack forKey:@"Game CompanyStack"];
    [aCoder encodeObject:self.companyTurnOrder forKey:@"Game CompanyTurnOrder"];
    [aCoder encodeObject:self.trains forKey:@"Game Trains"];
    [aCoder encodeObject:self.round forKey:@"Game Round"];
    [aCoder encodeInt:self.passCount forKey:@"Game PassCount"];
    [aCoder encodeInt:self.operatingRoundNum forKey:@"Game OperatingRoundNum"];
    [aCoder encodeInt:self.turnCount forKey:@"Game TurnCount"];
    [aCoder encodeObject:self.saveGames forKey:@"Game SaveGames"];
    [aCoder encodeObject:self.companies forKey:@"Game Companies"];
    [aCoder encodeObject:self.dirName forKey:@"Game DirName"];
    [aCoder encodeObject:self.frozenTurnOrder forKey:@"Game FrozenTurnOrder"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.companies = [aDecoder decodeObjectForKey:@"Game Companies"];
        self.player = [aDecoder decodeObjectForKey:@"Game Player"];
        self.settings = [aDecoder decodeObjectForKey:@"Game Settings"];
        self.compNames = [aDecoder decodeObjectForKey:@"Game CompNames"];
        self.bank = [aDecoder decodeObjectForKey:@"Game Bank"];
        self.dragon = [aDecoder decodeObjectForKey:@"Game Dragon"];
        self.currentPlayer = [aDecoder decodeObjectForKey:@"Game CurrentPlayer"];
        self.startPlayer = [aDecoder decodeObjectForKey:@"Game StartPlayer"];
        self.companyStack = [aDecoder decodeObjectForKey:@"Game CompanyStack"];
        self.companyTurnOrder = [aDecoder decodeObjectForKey:@"Game CompanyTurnOrder"];
        self.trains = [aDecoder decodeObjectForKey:@"Game Trains"];
        self.round = [aDecoder decodeObjectForKey:@"Game Round"];
        self.passCount         = [aDecoder decodeIntForKey:@"Game PassCount"];
        self.operatingRoundNum = [aDecoder decodeIntForKey:@"Game OperatingRoundNum"];
        self.turnCount         = [aDecoder decodeIntForKey:@"Game TurnCount"];
        self.saveGames         = [aDecoder decodeObjectForKey:@"Game SaveGames"];
        self.dirName           = [aDecoder decodeObjectForKey:@"Game DirName"];
        self.frozenTurnOrder   = [aDecoder decodeObjectForKey:@"Game FrozenTurnOrder"];
    }
    return self;
}

- (void) saveGame {
    NSString *path = [NSString stringWithFormat:@"%@/savegame-%03d.sav", self.dirName, self.turnCount];
    if ([NSKeyedArchiver archiveRootObject:self toFile:path]) {
        NSString *key;
        Company *comp = [self.companyTurnOrder firstObject];
        if ([self.round isEqualToString:@"Stock Round"]) {
            key = [NSString stringWithFormat:@"Load %03d: Stock Round - Start of turn for %@", self.turnCount, self.currentPlayer.name];
        } else if ([self.round isEqualToString:@"Operating Round"]) {
            key = [NSString stringWithFormat:@"Load %03d: Operating Round - Start of turn for %@", self.turnCount, comp.shortName];
        } else {
            key = [NSString stringWithFormat:@"Load %03d: %@", self.turnCount, self.round];
        }
        self.saveGames[key] = path;
    }
}

- (NSString*) shareholderTakesLoan:(Shareholder *)shareholder {
    shareholder.money += 500;
    self.bank.money -= 500;
    shareholder.numLoans++;
    return [NSString stringWithFormat:@"%@ takes loan of L.500\n", shareholder.name];
}

- (NSString*) shareholderPaysBackLoan:(Shareholder *)shareholder {
    shareholder.money -= 500;
    self.bank.money += 500;
    shareholder.numLoans--;
    return [NSString stringWithFormat:@"%@ pays back loan of L.500", shareholder.name];
}

- (NSDictionary*) getDictionaryOfCertificatesForSaleForPresident:(Company*)aComp {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:18];
    Player *pres = (Player*) aComp.president;
    int i=1;
    NSUInteger index = 0;
    for (Company* comp in self.companies) {
        if (comp != aComp) {
            if ([self player:pres CanSell:index]) {
                NSString *key = [NSString stringWithFormat:@"%02d: Sell share of %@", i, comp.shortName];
                dict[key] = comp;
                i++;
            }
        } else {
            int maxShare = 0;
            int presShare = [aComp getShareByOwner:pres];
            for (Player *player in self.player) {
                if (player != pres) {
                    int share = [aComp getShareByOwner:player];
                    if (maxShare < share) maxShare = share;
                }
            }
            if (presShare > maxShare && [self player:pres CanSell:index]) {
                NSString *key = [NSString stringWithFormat:@"%02d: Sell share of %@", i, aComp.shortName];
                dict[key] = aComp;
                i++;
            }
        }
        index++;
    }
    return dict;
}

- (NSArray*) getListOfCertificatesForSaleForPresident:(Company *)aComp {
    NSDictionary *dict = [self getDictionaryOfCertificatesForSaleForPresident:aComp];
    return [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

- (Company*) getCompanyForSaleWithKey:(NSString *)key {
    NSDictionary *dict = [self getDictionaryOfCertificatesForSaleForPresident:[self.companyTurnOrder firstObject]];
    return dict[key];
}

- (NSString*) company:(Company *)comp absorbsCompany:(Company *)target {
    NSString *msg = @"";
    int price = [target getShareMarketPrice];
    for (Certificate *cert in target.certificates) {
        Shareholder *owner = cert.owner;
        int cost = cert.share * price / 20;
        if (target.isMajor) {
            cost = cert.share * price / 10;
        }
        if (owner != target) {
            owner.money += cost;
            comp.money  -= cost;
            owner.numCertificates--;
            owner.numShares -= cert.share;
            msg = [NSString stringWithFormat:@"%@ pays %@ L.%d for %@\n%@", comp.shortName, owner.name, cost, cert.type, msg];
        }
    }
    comp.numStationMarkers = 7;
    comp.traffic       += target.traffic;
    comp.trainCapacity += target.trainCapacity;
    comp.money         += target.money;
    comp.numLoans      += target.numLoans;
    for (Train *train in target.trains) {
        train.owner = comp;
    }
    [comp.trains addObjectsFromArray:target.trains];
    msg = [NSString stringWithFormat:@"%@%@", [self checkTrainLimits], msg];
    [comp.maritimeCompanies addObjectsFromArray:target.maritimeCompanies];
    while ((comp.money < 0) && [self player:comp CanSell:[self.companies indexOfObject:comp]]) {
        Certificate *cert = [comp certificateFromOwner:comp];
        [comp sellCertificate:cert To:self.bank];
        int cost = cert.share * comp.stockPrice / 20;
        if (comp.isMajor) {
            cost = cert.share * comp.stockPrice / 10;
        }
        msg = [NSString stringWithFormat:@"%@ sells %@ to bank for L.%d to raise money\n%@", comp.shortName, cert.type, cost, msg];
    }
    while (comp.money<0) {
        msg = [NSString stringWithFormat:@"%@%@", [self shareholderTakesLoan:comp], msg];
    }
    // Remove old company and re-generate as new major company
    [self.companyStack removeObject:target];
    [self.companyTurnOrder removeObject:target];
    NSMutableArray *frozen = [self.frozenTurnOrder mutableCopy];
    [frozen removeObject:target];
    self.frozenTurnOrder = frozen;
    NSUInteger index = [self.companies indexOfObject:target];
    NSMutableArray *tmp = [self.companies mutableCopy];
    tmp[index] = [[Company alloc] initWithName:target.shortName IsMajor:YES AndSettings:self.settings AndBank:self.bank];
    self.companies = tmp;
    return msg;
}

- (NSString*) downgradeMinesSentence {
    if (self.settings.phase < 3) {
        return @"";
    }
    if (self.settings.phase < 5) {
        return @"Downgrade yellow tokened mines to green!";
    }
    return @"Downgrade tokened mines: yellow => green, green => brown";
}

- (NSString*) trainStackText {
    NSString *out = @"New trains: ";
    for (Train *train in self.trains) {
        out = [NSString stringWithFormat:@"%@%d", out, train.techLevel];
    }
    if ([self.bank.trains count] > 0) {
        out = [NSString stringWithFormat:@"%@ Bank: ", out];
        for (Train *train in self.bank.trains) {
            out = [NSString stringWithFormat:@"%@%d", out, train.techLevel];
        }
    }
    return out;
}

@end
