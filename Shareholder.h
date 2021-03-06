//
//  Shareholder.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 12/13/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shareholder : NSObject<NSCoding>

@property NSInteger money;   // money is not unsigned (bank can have negative money)
@property BOOL isPlayer;
@property (strong) NSMutableArray *trains;       // of Train
@property (strong) NSString* name;
@property int numCertificates;
@property int numShares;
@property int numLoans;

- (id) initWithName:(NSString*) aName;

@end
