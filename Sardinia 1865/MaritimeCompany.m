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

@end
