//
//  Company.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "Company.h"

@implementation Company

// For Shareholder Protocol
@synthesize money;
@synthesize certificates;

// Tested
- (id)initWithName:(NSString *)aName AndPrice:(int)price {
    self = [super init];
    if (self) {
        self.shortName = aName;
        self.stockPrice = price;
        self.numStationMarkers = 3;
        self.builtStations = 1;
        self.certificates = [[NSMutableArray alloc] initWithCapacity:10];
        self.trains = [[NSMutableArray alloc] initWithCapacity:4];

        GameSettings *settings = [[GameSettings alloc] init];
        self.name = [settings companyLongName:aName];
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

- (void) increaseStockPrice {
    
}

- (void) decreaseStockPrice {
    
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
}

// Tested
- (void) sellTrain:(Train *)aTrain ForMoney:(int)price {
    [self.trains removeObject:aTrain];
    self.money += price;
}

- (void) operateTrainsWithIncome:(int)income AndDividend:(BOOL)payout {
    
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

@end
