//
//  Company.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "Company.h"

@interface Company ()

@property GameSettings *settings;

@end

@implementation Company

- (id) initWithName:(NSString *)aName IsMajor:(BOOL)isMajor AndSettings:(GameSettings *)settings {
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
        
        self.settings = settings;
        self.name = [self.settings companyLongName:aName];
        
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
    [self.trains addObject:aTrain];
    self.money -= price;
    self.trainCapacity += aTrain.capacity;
}

// Tested
- (void) sellTrain:(Train *)aTrain ForMoney:(int)price {
    [self.trains removeObject:aTrain];
    self.money += price;
    self.trainCapacity -= aTrain.capacity;
}

- (void) operateTrainsAndPayDividend:(BOOL)payout {
    int income = MIN(self.traffic, self.trainCapacity) * 10;
    self.lastIncome = income;
    if (income > 0) {
        self.isOperating = YES;
        if (payout) {
            self.paidDividend = YES;
            for (Certificate *cert in self.certificates) {
                Shareholder *owner = (Shareholder*) cert.owner;
                owner.money += (cert.share * income) / 100;
            }
        } else {
            self.money += income;
        }
    }
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
        if ([self isDragonBuy]) {
            stockPrice = [self.settings getDragonPriceWithStockPrice:stockPrice AndGrade:@"Buy"];
        } else if ([self isDragonSell]) {
            stockPrice = [self.settings getDragonPriceWithStockPrice:stockPrice AndGrade:@"Sell"];
        } else {
            stockPrice = [self.settings getDragonPriceWithStockPrice:stockPrice AndGrade:@"Neutral"];
        }
    }
    oldOwner.money += self.stockPrice;
    newOwner.money -= self.stockPrice;
    oldOwner.numCertificates--;
    newOwner.numCertificates++;
    oldOwner.numShares -= aCertificate.share;
    newOwner.numShares += aCertificate.share;
    NSRange range = [aCertificate.type rangeOfString:@"President"];
    if (range.location != NSNotFound ) {
        oldOwner.money += self.stockPrice;
        newOwner.money -= self.stockPrice;
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
    [self updatePresident];
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
            NSNumber *num = [dict objectForKey:owner.name];
            num = [NSNumber numberWithInt:[dict[owner.name] intValue] + cert.share];
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

- (void) cleanFlagsForOperatingRound {
    self.didOperateThisTurn = NO;
    self.boughtBrandNewTrain = NO;
    self.paidDividend = NO;
    self.canBuildStation = (self.money>=10) ? YES : NO;
    self.canLay2ndTrack  = (self.money>=20) ? YES : NO;
}

@end
