//
//  Certificate.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "Certificate.h"

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

@end
