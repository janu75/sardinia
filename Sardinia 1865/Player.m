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
    }
    return self;
}

@end
