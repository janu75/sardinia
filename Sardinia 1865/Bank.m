//
//  Bank.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "Bank.h"

@implementation Bank

- (id) initWithMoney:(int)money {
    self = [super initWithName:@"Bank"];
    if (self) {
        self.money = money;
        self.trains = [[NSMutableArray alloc] init];
        self.ranOutOfMoney = NO;
    }
    return self;
}

@end
