//
//  Bank.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "Bank.h"

@implementation Bank

// For Shareholder Protocol
@synthesize money = _money;
@synthesize certificates = _certificates;

- (id) initWithMoney:(int)money {
    self = [super init];
    if (self) {
        self.money = money;
        self.trains = [[NSMutableArray alloc] init];
        self.certificates = [[NSMutableArray alloc] init];
        self.ranOutOfMoney = NO;
    }
    return self;
}

- (void) buyCertificate:(Certificate *)aCertificate atPrice:(int)price {
    self.money -= price;
    [self.certificates addObject:aCertificate];
}

- (void) sellCertificate:(Certificate *)aCertificate atPrice:(int)price{
    self.money += price;
    [self.certificates removeObject:aCertificate];
}

@end
