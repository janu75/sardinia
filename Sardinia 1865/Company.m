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

- (id) initWithName:(NSString *)aName IsMajor:(BOOL)isMajor {
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
        
        self.settings = [[GameSettings alloc] init];
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
}

// Tested
- (void) buyTrain:(Train *)aTrain {
    [self buyTrain:aTrain ForMoney:aTrain.cost];
}

// Tested
- (void) sellTrain:(Train *)aTrain {
    [self sellTrain:aTrain ForMoney:aTrain.cost];
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
    if (income > 0) {
        self.isOperating = YES;
        if (payout) {
            [self increaseStockPrice];
            for (Certificate *cert in self.certificates) {
                Shareholder *owner = (Shareholder*) cert.owner;
                owner.money += (cert.share * income) / 100;
            }
        } else {
            self.money += income;
        }
    } else {
        if (self.traffic > 0) [self decreaseStockPrice];
    }
}

- (void) absorbCompany:(Company *)aCompany {
    
}

// Tested
- (void) equipCertificate:(Certificate *)aCertificate {
    [self.certificates addObject:aCertificate];
    aCertificate.owner = self;
    // A company does not really buy certificates, it gets new certificates when started or being switched to major
}

// Tested
- (void) sellCertificate:(Certificate *)aCertificate To:(Shareholder*)newOwner {
    aCertificate.owner = newOwner;
    self.money += self.stockPrice;
    NSRange range = [aCertificate.type rangeOfString:@"President"];
    if (range.location != NSNotFound ) {
        self.money += self.stockPrice;
    }
    int unsold_shares=0;
    for (Certificate *cert in self.certificates) {
        if (cert.owner == self) unsold_shares += cert.share;
    }
    if (unsold_shares < 50) {
        self.isFloating = YES;
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
    if (presidentShare < maxShare) self.president = maxOwner;
    return self.president;
}

@end
