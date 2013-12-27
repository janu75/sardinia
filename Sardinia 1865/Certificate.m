//
//  Certificate.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "Certificate.h"
#import "Shareholder.h"

@implementation Certificate

- (id) initWithType:(NSString *)type {
    self = [super init];
    if (self) {
        if ([type isEqualToString:@"President Minor"]) {
            self.share = 40;
        } else if ([type isEqualToString:@"President Major"]) {
            self.share = 20;
        } else if ([type isEqualToString:@"Major"]) {
            self.share = 10;
        } else if ([type isEqualToString:@"Minor"]) {
            self.share = 20;
        } else {
            return nil;
        }
        self.type = type;
    }
    return self;
}

- (void) convertToMajor {
    self.share = self.share / 2;
    if ([self.type isEqualToString:@"President Minor"]) {
        self.type = @"President Major";
    } else {
        self.type = @"Major";
    }
    Shareholder *owner = self.owner;
    owner.numShares -= self.share;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.share forKey:@"Certificate Share"];
    [aCoder encodeObject:self.type forKey:@"Certificate Type"];
    [aCoder encodeObject:self.owner forKey:@"Certificate Owner"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.share = [aDecoder decodeIntForKey:@"Certificate Share"];
        self.type  = [aDecoder decodeObjectForKey:@"Certificate Type"];
        self.owner = [aDecoder decodeObjectForKey:@"Certificate Owner"];
    }
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"\nCertificate '%@'\n  %d%% share\n  owned by %@\n", self.type, self.share, self.owner];
}

@end
