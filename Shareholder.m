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
        self.name = aName;
        self.isPlayer = NO;
        self.numLoans = 0;
        self.numShares = 0;
        self.numCertificates = 0;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.money forKey:@"Shareholder Money"];
    [aCoder encodeBool:self.isPlayer forKey:@"Shareholder IsPlayer"];
    [aCoder encodeObject:self.trains forKey:@"Shareholder Trains"];
    [aCoder encodeObject:self.name forKey:@"Shareholder Name"];
    [aCoder encodeInt:self.numCertificates forKey:@"Shareholder NumCertificates"];
    [aCoder encodeInt:self.numShares forKey:@"Shareholder NumShares"];
    [aCoder encodeInt:self.numLoans forKey:@"Shareholder Loans"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.money =           [aDecoder decodeIntForKey:@"Shareholder Money"];
        self.isPlayer =        [aDecoder decodeBoolForKey:@"Shareholder IsPlayer"];
        self.trains =          [aDecoder decodeObjectForKey:@"Shareholder Trains"];
        self.name =            [aDecoder decodeObjectForKey:@"Shareholder Name"];
        self.numCertificates = [aDecoder decodeIntForKey:@"Shareholder NumCertificates"];
        self.numShares =       [aDecoder decodeIntForKey:@"Shareholder NumShares"];
        self.numLoans =        [aDecoder decodeIntForKey:@"Shareholder Loans"];
    }
    return self;
}

@end
