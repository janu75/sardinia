//
//  Shareholder.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 12/13/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "Shareholder.h"

@implementation Shareholder

- (id) initWithName:(NSString *)aName {
    self = [super init];
    if (self) {
        self.money = 0;
        self.certificates = [[NSMutableArray alloc] initWithCapacity:10];
        self.name = aName;
        self.isPlayer = NO;
    }
    return self;
}

//- (void) buyCertificate:(Certificate *)aCertificate atPrice:(int)price {
//    self.money -= price;
//    aCertificate.owner = self;
//    [self.certificates addObject:aCertificate];
//}
//
//- (void) sellCertificate:(Certificate *)aCertificate atPrice:(int)price {
//    self.money += price;
//    aCertificate.owner = nil;
//    [self.certificates removeObject:aCertificate];
//}

@end
