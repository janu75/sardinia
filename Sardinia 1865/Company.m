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

// For Shareholder Protocol
@synthesize money;
@synthesize certificates;

- (id) initWithName:(NSString *)aName IsMajor:(BOOL)isMajor {
    self = [super init];
    if (self) {
        self.shortName = aName;
        self.numStationMarkers = 3;
        self.builtStations = 1;
        self.isMajor = isMajor;
        self.certificates = [[NSMutableArray alloc] initWithCapacity:10];
        self.trains = [[NSMutableArray alloc] initWithCapacity:4];
        
        self.settings = [[GameSettings alloc] init];
        self.name = [self.settings companyLongName:aName];
        
        if (isMajor) {
            [self.certificates addObject:[[Certificate alloc] initWithType:@"President Major"]];
            for (int i=0; i<8; i++) {
                [self.certificates addObject:[[Certificate alloc] initWithType:@"Major"]];
            }
        } else {
            [self.certificates addObject:[[Certificate alloc] initWithType:@"President Minor"]];
            for (int i=0; i<3; i++) {
                [self.certificates addObject:[[Certificate alloc] initWithType:@"Minor"]];
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
        if (payout) {
            [self increaseStockPrice];
            for (Certificate *cert in self.certificates) {
                self.money += (cert.share * income) / 100;
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
    // A company does not really buy certificates, it gets new certificates when started or being switched to major
}

// Tested
- (void) sellCertificate:(Certificate *)aCertificate {
    [self.certificates removeObject:aCertificate];
    self.money += self.stockPrice;
    NSRange range = [aCertificate.type rangeOfString:@"President"];
    if (range.location != NSNotFound ) {
        self.money += self.stockPrice;
    }
}

- (void) convertToMajorInPhase:(int)phase {
    for (Certificate *cert in self.certificates) {
        [cert convertToMajor];
    }
    for (int i=0; i<5; i++) {
        [self.certificates addObject:[[Certificate alloc] initWithType:@"Major"]];
    }
}

@end