//
//  GameSettings.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "GameSettings.h"
#import "Train.h"

@implementation GameSettings

// Tested
- (id) init {
    self = [super init];
    if (self) {
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath;
        plistPath = [[NSBundle mainBundle] pathForResource:@"1865-settings" ofType:@"plist"];
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        self.pref = (NSDictionary*) [NSPropertyListSerialization propertyListFromData:plistXML
                                                                     mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                               format:&format
                                                                     errorDescription:&errorDesc];
        if (!self.pref) {
            NSLog(@"Error reading plist: %@, format: %ld", errorDesc, format);
        }
        self.trainSpec = [self.pref objectForKey:@"Train Spec"];
        self.phase = 2;
    }
    return self;
}

- (NSString*) companyLongName:(NSString *)shortName {
	NSDictionary *names = [self.pref objectForKey:@"Company Names"];
    return [names objectForKey:shortName];
}

- (NSArray*) companyShortNames {
	NSDictionary *names = [self.pref objectForKey:@"Company Names"];
    return [names allKeys];
}

- (NSNumber*) increasedStockPrice:(NSNumber *)current {
    NSArray *table = [self.pref objectForKey:@"Stock Price Table"];
    NSUInteger index = [table indexOfObject:current];
    if (index+1 < [table count]) {
        index++;
    }
    return [table objectAtIndex:index];
}

- (NSNumber*) decreasedStockPrice:(NSNumber *)current {
    NSArray *table = [self.pref objectForKey:@"Stock Price Table"];
    NSInteger index = [table indexOfObject:current];
    if (index > 0) {
        index--;
    }
    return [table objectAtIndex:index];
}

- (int) certificateLimit:(NSString *)playerName InPhase:(int)phase {
    if ([playerName isEqualToString:@"Dragon"]) {
        NSDictionary *dict = [self.pref objectForKey:@"Dragon Certificate Limit"];
        return [[dict objectForKey:[NSString stringWithFormat:@"%d", phase]] intValue];
    }
    if ([playerName isEqualToString:@"Bank"]) {
        return 1000;
    }
    if (self.isShortGame) {
        NSDictionary *dict = [self.pref objectForKey:@"Player Certificate Limit Short Game"];
        return [[dict objectForKey:[NSString stringWithFormat:@"%d", self.numPlayers]] intValue];
    }
    NSDictionary *dict = [self.pref objectForKey:@"Player Certificate Limit"];
    return [[dict objectForKey:[NSString stringWithFormat:@"%d", self.numPlayers]] intValue];
}

- (int) certificateLimit:(NSString *)playerName {
    if ([playerName isEqualToString:@"Dragon"]) {
        NSLog(@"certificateLimit called for Dragon!");
    }
    return [self certificateLimit:playerName InPhase:0];
}

- (NSNumber*) getDragonBuyLimit:(NSNumber *)aRow {
    NSDictionary *dict = [self.pref objectForKey:@"Dragon Chart"];
    return dict[[NSString stringWithFormat:@"%@", aRow]];
}

- (NSMutableArray*) generateTrains {
    NSMutableArray *trains = [[NSMutableArray alloc] initWithCapacity:34];
    NSDictionary *dict;
    if (self.isShortGame) {
        dict = [self.pref objectForKey:@"Trains Short Game"];
    } else {
        dict = [self.pref objectForKey:@"Trains"];
    }
    for (int i=2; i<8; i++) {
        int N = [dict[[NSString stringWithFormat:@"Tech %d", i]]intValue];
        for (int j=0; j<N; j++) {
            [trains addObject:[[Train alloc] initWithTech:i AndDiscount:NO]];
        }
        N = [dict[[NSString stringWithFormat:@"Tech %d Discount", i]]intValue];
        for (int j=0; j<N; j++) {
            [trains addObject:[[Train alloc] initWithTech:i AndDiscount:YES]];
        }
    }
    return trains;
}

- (int) getDragonPriceWithStockPrice:(int)price AndGrade:(NSString*)grade {
    if ([grade isEqualToString:@"Sell"]) {
        return price;
    }
    if ([grade isEqualToString:@"Buy"]) {
        NSDictionary *dict = [self.pref objectForKey:@"Dragon Price Buy"];
        int val = [dict[[NSString stringWithFormat:@"%d", price]] intValue];
        return val;
    }
    NSDictionary *dict = [self.pref objectForKey:@"Dragon Price Neutral"];
    int val = [dict[[NSString stringWithFormat:@"%d", price]] intValue];
    return val;
}

- (NSString*) adjustTrainLimit {
    NSDictionary *dict = [self.pref objectForKey:@"Train Limit"];
    int newLimit = [dict[[NSString stringWithFormat:@"%d", self.phase]] intValue];
    if (newLimit != self.trainLimit) {
        self.trainLimit = newLimit;
        return [NSString stringWithFormat:@"Train limit now is %d", newLimit];
    }
    return @"";
}

- (NSString*) enterNewPhase:(int)aPhase {
    self.phase = aPhase;
    return [self adjustTrainLimit];
}

- (NSArray*) getInitialValuesForMoney:(int)money {
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i=60; i<=[self maxInitialStockValue]; i+=10) {
        if (money >= 2*i) [list addObject:[NSString stringWithFormat:@"%d", i]];
    }
    return list;
}

- (int) maxInitialStockValue {
    NSDictionary *dict = [self.pref objectForKey:@"Initial Stock Price Limit"];
    return [dict[[NSString stringWithFormat:@"%d", self.phase]] intValue];
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.pref forKey:@"GameSettings Pref"];
    [aCoder encodeInt:self.numPlayers forKey:@"GameSettings NumPlayers"];
    [aCoder encodeInt:self.phase forKey:@"GameSettings Phase"];
    [aCoder encodeInt:self.trainLimit forKey:@"GameSettings TrainLimit"];
    [aCoder encodeBool:self.isShortGame forKey:@"GameSettings IsShortGame"];
    [aCoder encodeObject:self.trainSpec forKey:@"GameSettings TrainSpec"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.pref = [aDecoder decodeObjectForKey:@"GameSettings Pref"];
        self.numPlayers = [aDecoder decodeIntForKey:@"GameSettings NumPlayers"];
        self.phase      = [aDecoder decodeIntForKey:@"GameSettings Phase"];
        self.trainLimit = [aDecoder decodeIntForKey:@"GameSettings TrainLimit"];
        self.isShortGame = [aDecoder decodeBoolForKey:@"GameSettings IsShortGame"];
        self.trainSpec   = [aDecoder decodeObjectForKey:@"GameSettings TrainSpec"];
    }
    return self;
}

@end
