//
//  Player.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id) initWithName:(NSString *)aName AndMoney:(int)money {
    self = [super initWithName:aName];
    if (self) {
        self.money = money;
        self.isPlayer = YES;
        self.maritimeCompany = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

@end
