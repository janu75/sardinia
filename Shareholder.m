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

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInt:self.money] forKey:@"Shareholder Money"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isPlayer] forKey:@"Shareholder IsPlayer"];
    [aCoder encodeObject:self.certificates forKey:@"Shareholder Certificates"];
    [aCoder encodeObject:self.trains forKey:@"Shareholder Trains"];
    [aCoder encodeObject:self.name forKey:@"Shareholder Name"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.numCertificates] forKey:@"Shareholder NumCertificates"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.numShares] forKey:@"Shareholder NumShares"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.money = [[aDecoder decodeObjectForKey:@"Shareholder Money"] intValue];
        self.isPlayer = [[aDecoder decodeObjectForKey:@"Shareholder IsPlayer"] boolValue];
        self.certificates = [aDecoder decodeObjectForKey:@"Shareholder Certificates"];
        self.trains = [aDecoder decodeObjectForKey:@"Shareholder Trains"];
        self.name = [aDecoder decodeObjectForKey:@"Shareholder Name"];
        self.numCertificates = [[aDecoder decodeObjectForKey:@"Shareholder NumCertificates"] intValue];
        self.numShares = [[aDecoder decodeObjectForKey:@"Shareholder NumShares"] intValue];
    }
    return self;
}

@end
