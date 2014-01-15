//
//  Company.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "Company.h"

@interface Company ()


@end

@implementation Company

- (id) initWithName:(NSString *)aName IsMajor:(BOOL)isMajor AndSettings:(GameSettings *)settings AndBank:(Shareholder*) aBank {
    self = [super initWithName:aName];
    if (self) {
        self.shortName = aName;
        if (isMajor) {
            self.numStationMarkers = 7;
        } else {
            self.numStationMarkers = 3;
        }
        self.builtStations = 1;
        self.isMajor = isMajor;
        self.certificates = [[NSMutableArray alloc] initWithCapacity:10];
        self.trains = [[NSMutableArray alloc] initWithCapacity:4];
        self.maritimeCompanies = [[NSMutableArray alloc] initWithCapacity:2];
        self.settings = settings;
        self.name = [self.settings companyLongName:aName];
        self.bank = aBank;
        
        if (isMajor) {
            [self equipCertificate:[[Certificate alloc] initWithType:@"President Major"]];
            for (int i=0; i<8; i++) {
                [self equipCertificate:[[Certificate alloc] initWithType:@"Major"]];
            }
        } else {
            [self equipCertificate:[[Certificate alloc] initWithType:@"President Minor"]];
            for (int i=0; i<3; i++) {
                [self equipCertificate:[[Certificate alloc] initWithType:@"Minor"]];
            }
        }
    }
    return self;
}

// Tested
- (int) rank {
    int techRank = 0;
    for (Train *train in self.trains) {
        techRank += train.techLevel;
    }
    return self.builtStations + techRank;
}

// Tested
- (void) layExtraTrack {
    self.money -= 20;
    self.canLay2ndTrack = NO;
}

// Tested
- (void) trafficUpgrade:(int)value {
    self.traffic += value;
}

// Tested
- (void) setInitialStockPrice:(int)price {
    self.stockPrice = price;
}

// Tested
- (void) increaseStockPrice {
    self.stockPrice = [[self.settings increasedStockPrice:[NSNumber numberWithInt:self.stockPrice]] intValue];
}

// Tested
- (void) decreaseStockPrice {
    self.stockPrice = [[self.settings decreasedStockPrice:[NSNumber numberWithInt:self.stockPrice]] intValue];
}

- (void) operateMines {
    
}

// Tested
- (void) placeStationMarkerForCost:(int)cost{
    self.money -= cost;
    self.bank.money += cost;
    self.builtStations++;
    self.canBuildStation = NO;
    self.canLay2ndTrack = NO;
}

// Tested
- (void) buyTrain:(Train *)aTrain {
    if (aTrain.owner == nil) {
        self.boughtBrandNewTrain = YES;
    }
    [self buyTrain:aTrain ForMoney:aTrain.cost];
}

// Tested
- (void) sellTrain:(Train *)aTrain {
    [self sellTrain:aTrain ForMoney:aTrain.cost];
    self.settings.phase = aTrain.techLevel;
}

// Tested
- (void) buyTrain:(Train *)aTrain ForMoney:(int)price {
    self.trainCapacity += aTrain.capacity;
}

// Tested
- (void) sellTrain:(Train *)aTrain ForMoney:(int)price {
    self.trainCapacity -= aTrain.capacity;
}

- (void) operateTrainsAndPayDividend:(BOOL)payout {
    int income = MIN(self.traffic, self.trainCapacity) * 10;
    if ([self.trains count] == 0) {
        income = 0;
    }
    self.lastIncome = income;
    if (income > 0) {
        if (payout) {
            self.paidDividend = YES;
            for (Certificate *cert in self.certificates) {
                Shareholder *owner = (Shareholder*) cert.owner;
                int amount = (cert.share * income) / 100;
                owner.money += amount;
            }
        } else {
            self.money += income;
        }
        self.bank.money -= income;
    }
    self.isOperating = YES;
    self.didOperateThisTurn = YES;
    self.canLay2ndTrack = NO;
    self.canBuildStation = NO;
}

- (void) absorbCompany:(Company *)aCompany {
    
}

// Tested
- (void) equipCertificate:(Certificate *)aCertificate {
    [self.certificates addObject:aCertificate];
    aCertificate.owner = self;
    self.numCertificates++;
    self.numShares += aCertificate.share;
    // A company does not really buy certificates, it gets new certificates when started or being switched to major
}

// Tested
- (void) sellCertificate:(Certificate *)aCertificate To:(Shareholder*)newOwner {
    Shareholder *oldOwner = aCertificate.owner;
    aCertificate.owner = newOwner;
    int stockPrice = self.stockPrice;
    if ([oldOwner.name isEqualToString:@"Dragon"]) {
        stockPrice = [self getShareMarketPrice];
    }
    oldOwner.money += stockPrice;
    newOwner.money -= stockPrice;
    oldOwner.numCertificates--;
    newOwner.numCertificates++;
    oldOwner.numShares -= aCertificate.share;
    newOwner.numShares += aCertificate.share;
    NSRange range = [aCertificate.type rangeOfString:@"President"];
    if (range.location != NSNotFound ) {
        oldOwner.money += stockPrice;
        newOwner.money -= stockPrice;
    }
    int unsold_shares=0;
    for (Certificate *cert in self.certificates) {
        if (cert.owner == self) unsold_shares += cert.share;
    }
    if (unsold_shares < 50) {
        self.isFloating = YES;
        if (!self.dragonRow) {
            [self setDragonRowWithPhase:self.settings.phase];
        }
    }
}

// Tested
- (void) convertToMajorInPhase:(int)phase {
    for (Certificate *cert in self.certificates) {
        [cert convertToMajor];
    }
    for (int i=0; i<5; i++) {
        [self equipCertificate:[[Certificate alloc] initWithType:@"Major"]];
    }
    self.isMajor = YES;
    self.numStationMarkers = MIN(self.numStationMarkers + phase-1, 7);
}

- (int) getShareByOwner:(Shareholder *)anOwner {
    int share = 0;
    for (Certificate* cert in self.certificates) {
        if (cert.owner == anOwner) {
            share += cert.share;
        }
    }
    return share;
}

- (int) getCertificatesByOwner:(Shareholder *)anOwner {
    int num = 0;
    for (Certificate* cert in self.certificates) {
        if (cert.owner == anOwner) {
            num++;
        }
    }
    return num;
}

- (Shareholder*) updatePresident {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:7];
    NSMutableDictionary *ownerByName = [[NSMutableDictionary alloc] initWithCapacity:4];
    int presidentShare = [self getShareByOwner:self.president];
    for (Certificate* cert in self.certificates) {
        Shareholder *owner = cert.owner;
        if (owner.isPlayer) {
            ownerByName[owner.name] = owner;
            NSNumber *num = [NSNumber numberWithInt:[dict[owner.name] intValue] + cert.share];
            dict[owner.name] = num;
        }
    }
    int maxShare = 0;
    Shareholder* maxOwner;
    for (Shareholder *name in [dict allKeys]) {
        if ([dict[name] intValue] > maxShare) {
            maxShare = [dict[name] intValue];
            maxOwner = ownerByName[name];
        }
    }
    if (presidentShare < maxShare) {
        Certificate *presidentCert = self.certificates[0];
        Certificate *replacement = [self certificateFromOwner:maxOwner];
        replacement.owner = self.president;
        replacement = [self certificateFromOwner:maxOwner];
        replacement.owner = self.president;
        presidentCert.owner = maxOwner;
        self.president = maxOwner;
    }
    return self.president;
}

- (BOOL) isDragonBuy {
    if (!self.isFloating) {
        return NO;
    }
    int minRank = [[self.settings getDragonBuyLimit:self.dragonRow] intValue];
    int myRank  = [self rank];
    if (minRank < myRank) {
        return YES;
    }
    return NO;
}

- (BOOL) isDragonSell {
    if ([[self.settings getDragonBuyLimit:self.dragonRow] intValue]-1 > [self rank]) {
        return YES;
    }
    return NO;
}

- (Certificate*) certificateFromOwner:(Shareholder *)anOwner {
    Certificate *myCert;
    // Return last possible certificate in list to make sure we don't sell president shares easily
    // Unless these are IPO shares, in this case, return the first one
    for (Certificate* cert in self.certificates) {
        if (cert.owner == anOwner) {
            myCert = cert;
            if (anOwner == self) {
                return myCert;
            }
        }
    }
    return myCert;
}

- (void) setDragonRowWithPhase:(int)phase {
    if (phase > 4) {
        self.dragonRow = @2;
    } else {
        self.dragonRow = @1;
    }
}

- (void) updateDragonRowInPhase:(int)phase {
    if ([self.dragonRow intValue]+1 < phase) {
        self.dragonRow = [NSNumber numberWithInt:[self.dragonRow intValue]+1];
    }
}

- (void) cleanFlagsForOperatingRound {
    self.didOperateThisTurn = NO;
    self.boughtBrandNewTrain = NO;
    self.paidDividend = NO;
    self.canBuildStation = (self.money>=10 && self.builtStations<self.numStationMarkers) ? YES : NO;
    self.canLay2ndTrack  = (self.money>=20) ? YES : NO;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.certificates forKey:@"Company Certificates"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isOperating] forKey:@"Company IsOperating"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isFloating] forKey:@"Company IsFloating"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isMajor] forKey:@"Company IsMajor"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.didOperateThisTurn] forKey:@"Company DidOperateThisTurn"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.canLay2ndTrack] forKey:@"Company CanLay2ndTrack"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.canBuildStation] forKey:@"Company CanBuildStation"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.boughtBrandNewTrain] forKey:@"Company BoughtBrandNewTrain"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.paidDividend] forKey:@"Company PaidDividend"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.presidentSoldShares] forKey:@"Company PresidentSoldShares"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.numStationMarkers] forKey:@"Company NumStationMarkers"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.builtStations] forKey:@"Company BuiltStations"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.traffic] forKey:@"Company Traffic"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.trainCapacity] forKey:@"Company TrainCapacity"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.stockPrice] forKey:@"Company StockPrice"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.money] forKey:@"Company Money"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.lastIncome] forKey:@"Company LastIncome"];
    [aCoder encodeObject:self.dragonRow forKey:@"Company DragonRow"];
    [aCoder encodeObject:self.shortName forKey:@"Company ShortName"];
    [aCoder encodeObject:self.trains forKey:@"Company Trains"];
    [aCoder encodeObject:self.maritimeCompanies forKey:@"Company MaritimeCompanies"];
    [aCoder encodeObject:self.settings forKey:@"Company Settings"];
    [aCoder encodeObject:self.president forKey:@"Company President"];
    [aCoder encodeObject:self.bank forKey:@"Company Bank"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isOperating = [[aDecoder decodeObjectForKey:@"Company IsOperating"] boolValue];
        self.isFloating  = [[aDecoder decodeObjectForKey:@"Company IsFloating"] boolValue];
        self.isMajor     = [[aDecoder decodeObjectForKey:@"Company IsMajor"] boolValue];
        self.didOperateThisTurn = [[aDecoder decodeObjectForKey:@"Company DidOperateThisTurn"] boolValue];
        self.canLay2ndTrack     = [[aDecoder decodeObjectForKey:@"Company CanLay2ndTrack"] boolValue];
        self.canBuildStation    = [[aDecoder decodeObjectForKey:@"Company CanBuildStation"] boolValue];
        self.boughtBrandNewTrain = [[aDecoder decodeObjectForKey:@"Company BoughtBrandNewTrain"] boolValue];
        self.paidDividend        = [[aDecoder decodeObjectForKey:@"Company PaidDividend"] boolValue];
        self.presidentSoldShares = [[aDecoder decodeObjectForKey:@"Company PresidentSoldShares"] intValue];
        self.numStationMarkers   = [[aDecoder decodeObjectForKey:@"Company NumStationMarkers"] intValue];
        self.builtStations       = [[aDecoder decodeObjectForKey:@"Company BuiltStations"] intValue];
        self.traffic             = [[aDecoder decodeObjectForKey:@"Company Traffic"] intValue];
        self.trainCapacity       = [[aDecoder decodeObjectForKey:@"Company TrainCapacity"] intValue];
        self.stockPrice          = [[aDecoder decodeObjectForKey:@"Company StockPrice"] intValue];
        self.money               = [[aDecoder decodeObjectForKey:@"Company Money"] intValue];
        self.lastIncome          = [[aDecoder decodeObjectForKey:@"Company LastIncome"] intValue];
        self.dragonRow           = [aDecoder decodeObjectForKey:@"Company DragonRow"];
        self.shortName           = [aDecoder decodeObjectForKey:@"Company ShortName"];
        self.trains              = [aDecoder decodeObjectForKey:@"Company Trains"];
        self.maritimeCompanies   = [aDecoder decodeObjectForKey:@"Company MaritimeCompanies"];
        self.settings            = [aDecoder decodeObjectForKey:@"Company Settings"];
        self.certificates        = [aDecoder decodeObjectForKey:@"Company Certificates"];
        self.president           = [aDecoder decodeObjectForKey:@"Company President"];
        self.bank                = [aDecoder decodeObjectForKey:@"Company Bank"];
    }
    return self;
}

- (int) getCompanyCost {
    int cost = 0;
    int marketPrice = [self getShareMarketPrice];
    for (Certificate* cert in self.certificates) {
        if (cert.owner != self) {
            if (self.isMajor) {
                cost += cert.share * marketPrice / 10;
            } else {
                cost += cert.share * marketPrice / 20;
            }
        }
    }
    return cost;
}

- (int) getShareMarketPrice {
    if ([self isDragonBuy]) {
        return [self.settings getDragonPriceWithStockPrice:self.stockPrice AndGrade:@"Buy"];
    } else if ([self isDragonSell]) {
        return [self.settings getDragonPriceWithStockPrice:self.stockPrice AndGrade:@"Sell"];
    } else {
        return [self.settings getDragonPriceWithStockPrice:self.stockPrice AndGrade:@"Neutral"];
    }    
}

- (BOOL) isEqual:(id)object {
    BOOL equal = YES;
    if (object == self) {
        return YES;
    }
    Company *other = object;
    if (![self.name isEqualToString:other.name]) equal = NO;
    if (self.money != other.money) equal = NO;
    if ([self getShareByOwner:self] != [other getShareByOwner:other]) equal = NO;
    return equal;
}

- (BOOL) canConvertToMajor {
    if (self.isFloating && !self.isMajor) {
        return YES;
    }
    return NO;
}

- (BOOL) shareholderHasNoShares:(Shareholder *)aShareholder {
    if ([self getShareByOwner:aShareholder] > 0) {
        return NO;
    }
    return YES;
}

- (int) potentialIncome {
    if ([self.trains count] == 0) {
        return 0;
    }
    return MIN(self.trainCapacity, self.traffic) * 10;
}

- (void) sortTrains {
    self.trains = [[self.trains sortedArrayUsingComparator:^(id obj1, id obj2) {
        Train *train1 = obj1;
        Train *train2 = obj2;
        if (train1.techLevel < train2.techLevel) {
            return NSOrderedAscending;
        } else if (train1.techLevel > train2.techLevel) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }] mutableCopy];
}

@end
