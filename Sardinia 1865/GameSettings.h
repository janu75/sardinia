//
//  GameSettings.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSettings : NSObject

@property (strong, nonatomic) NSDictionary *pref;

- (NSString*) companyLongName:(NSString*)shortName;

- (NSArray*) companyShortNames;

- (NSNumber*) increasedStockPrice:(NSNumber*)current;

- (NSNumber*) decreasedStockPrice:(NSNumber*)current;

@end
