//
//  Train.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Train : NSObject<NSCoding>

@property int cost;
@property int capacity;
@property int techLevel;
@property (strong) NSNumber *rustsAt;
@property (weak) id owner;

- (id) initWithTech:(int)techLevel AndDiscount:(BOOL)discount;

@end
