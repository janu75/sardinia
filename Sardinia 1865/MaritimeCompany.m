//
//  MaritimeCompany.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "MaritimeCompany.h"

@implementation MaritimeCompany

- (id) initWithIdentifier:(int)ident {
    self = [super init];
    if (self) {
        self.identifier  = ident;
        self.isConnected = NO;
        self.isPrivate   = NO;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:self.isPrivate forKey:@"MaritimeCompany IsPrivate"];
    [aCoder encodeBool:self.isConnected forKey:@"MaritimeCompany IsConnected"];
    [aCoder encodeInt:self.identifier forKey:@"MaritimeCompany Identifier"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.isPrivate = [aDecoder decodeBoolForKey:@"MaritimeCompany IsPrivate"];
        self.isConnected = [aDecoder decodeBoolForKey:@"MaritimeCompany IsConnected"];
        self.identifier  = [aDecoder decodeIntForKey:@"MaritimeCompany Identifier"];
    }
    return self;
}

@end
