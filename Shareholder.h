//
//  Shareholder.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 12/13/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Certificate.h"

@interface Shareholder : NSObject

@property int money;
@property BOOL isPlayer;
@property (strong) NSMutableArray *certificates; // of Certificate
@property (strong) NSMutableArray *trains;       // of Train
@property (strong) NSString* name;
@property int numCertificates;
@property int numShares;

- (id) initWithName:(NSString*) aName;

//- (void) buyCertificate:(Certificate*)aCertificate atPrice:(int)price;
//
//- (void) sellCertificate:(Certificate*)aCertificate atPrice:(int)price;

@end
