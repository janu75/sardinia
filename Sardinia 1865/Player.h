//
//  Player.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shareholder.h"
#import "MaritimeCompany.h"

@interface Player : Shareholder

//@property (strong) NSString* name;
@property (strong) NSMutableArray* maritimeCompany;
@property (strong) NSMutableArray* soldCompanies;
@property (strong) Shareholder* bank;

- (id) initWithName:(NSString*)aName AndMoney:(int)money AndBank:(Shareholder*)aBank;

- (NSString*) incomeFromMaritimeCompanies;

@end
