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

- (id) initWithName:(NSString *)aName AndMoney:(int)money {
    self = [super initWithName:aName];
    if (self) {
        self.money = money;
        self.isPlayer = YES;
        MaritimeCompany *m1 = [[MaritimeCompany alloc] init];
        MaritimeCompany *m2 = [[MaritimeCompany alloc] init];
        self.maritimeCompany = [@[m1, m2] mutableCopy];
        self.soldCompanies = [[NSMutableArray alloc] initWithCapacity:8];
    }
    return self;
}

- (NSString*) incomeFromMaritimeCompanies {
    NSUInteger mCount = [self.maritimeCompany count];
    if (mCount > 0) {
        self.money += mCount * 20;
        return [NSString stringWithFormat:@"%@ receives L.%lu from maritime companies\n", self.name, mCount*20];
    }
    return @"";
}

@end
