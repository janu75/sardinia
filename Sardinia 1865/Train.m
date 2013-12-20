//
//  Train.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "Train.h"

@implementation Train

- (id) initWithTech:(int)techLevel AndDiscount:(BOOL)discount {
    self = [super init];
    if (self) {
        self.techLevel = techLevel;
        self.rustsAt = nil;
        if (techLevel == 2) {               // 6x
            self.cost = 100;
            self.capacity = 8;
            self.rustsAt = [NSNumber numberWithInt:4];
            if (discount) self.cost -= 30;  // 5x
        } else if (techLevel == 3){
            self.cost = 200;
            self.capacity = 14;
            if (discount) self.cost -= 40;
            self.rustsAt = [NSNumber numberWithInt:6];
        } else if (techLevel == 4){         // 4x
            self.cost = 350;
            self.capacity = 20;
            if (discount) self.cost -= 50;
            self.rustsAt = [NSNumber numberWithInt:7];
        } else if (techLevel == 5){         // 2x
            self.cost = 500;
            self.capacity = 25;
        } else if (techLevel == 6){         // 3x
            self.cost = 650;
            self.capacity = 30;
        } else if (techLevel == 7){         // 14x
            self.cost = 800;
            self.capacity = 35;
        } else {
            self.cost = 0;
            self.capacity = 0;
        }
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.cost forKey:@"Train Cost"];
    [aCoder encodeInt:self.capacity forKey:@"Train Capactiy"];
    [aCoder encodeInt:self.techLevel forKey:@"Train TechLevel"];
    [aCoder encodeObject:self.rustsAt forKey:@"Train RustsAt"];
    [aCoder encodeObject:self.owner forKey:@"Train Owner"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.cost = [aDecoder decodeIntForKey:@"Train Cost"];
        self.capacity = [aDecoder decodeIntForKey:@"Train Capacity"];
        self.techLevel = [aDecoder decodeIntForKey:@"Train TechLevel"];
        self.rustsAt   = [aDecoder decodeObjectForKey:@"Train RustsAt"];
        self.owner     = [aDecoder decodeObjectForKey:@"Train Owner"];
    }
    return self;
}

@end
