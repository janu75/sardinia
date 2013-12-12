//
//  Bank.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shareholder.h"

@interface Bank : NSObject <Shareholder>

@property (strong, nonatomic) NSMutableArray* trains; // of Train
@property BOOL ranOutOfMoney;

- (id) initWithMoney:(int) money;

- (void) buyCertificate:(Certificate *)aCertificate atPrice:(int)price;

- (void) sellCertificate:(Certificate *)aCertificate atPrice:(int)price;

@end
