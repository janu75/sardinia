//
//  Player.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "Player.h"
#import "MaritimeCompany.h"

@implementation Player

- (id) initWithName:(NSString *)aName AndMoney:(int)money AndBank:(Shareholder*)aBank AndSound:(NSString *)sound {
    self = [super initWithName:aName];
    if (self) {
        self.money = money;
        self.isPlayer = YES;
        MaritimeCompany *m1 = [[MaritimeCompany alloc] init];
        MaritimeCompany *m2 = [[MaritimeCompany alloc] init];
        self.maritimeCompany = [@[m1, m2] mutableCopy];
        self.soldCompanies = [[NSMutableArray alloc] initWithCapacity:8];
        self.bank = aBank;
        self.sound = sound;
    }
    return self;
}

- (NSString*) incomeFromMaritimeCompanies {
    NSUInteger mCount = [self.maritimeCompany count];
    if (mCount > 0) {
        self.money += mCount * 20;
        self.bank.money -= mCount * 20;
        return [NSString stringWithFormat:@"%@ receives L.%lu from maritime companies\n", self.name, mCount*20];
    }
    return @"";
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.maritimeCompany forKey:@"Player MaritimeCompany"];
    [aCoder encodeObject:self.soldCompanies forKey:@"Player SoldCompanies"];
    [aCoder encodeObject:self.bank forKey:@"Player Bank"];
    [aCoder encodeObject:self.sound forKey:@"Player Sound"];
    [super encodeWithCoder:aCoder];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.maritimeCompany = [aDecoder decodeObjectForKey:@"Player MaritimeCompany"];
        self.soldCompanies   = [aDecoder decodeObjectForKey:@"Player SoldCompanies"];
        self.bank            = [aDecoder decodeObjectForKey:@"Player Bank"];
        self.sound           = [aDecoder decodeObjectForKey:@"Player Sound"];
    }
    return self;
}

@end
