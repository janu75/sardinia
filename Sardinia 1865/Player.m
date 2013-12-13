//
//  Player.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id) initWithName:(NSString *)aName {
    self = [super initWithName:aName];
    if (self) {
        self.money = 300;
        self.isPlayer = YES;
    }
    return self;
}

@end
