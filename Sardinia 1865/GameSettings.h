//
//  GameSettings.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSettings : NSObject

@property (strong) NSDictionary *pref;

@property int numPlayers;
@property BOOL isShortGame;
@property (strong) NSDictionary *trainSpec;

- (NSString*) companyLongName:(NSString*)shortName;

- (NSArray*) companyShortNames;

- (NSNumber*) increasedStockPrice:(NSNumber*)current;

- (NSNumber*) decreasedStockPrice:(NSNumber*)current;

- (int) certificateLimit:(NSString*)playerName;

- (int) certificateLimit:(NSString*)playerName InPhase:(int)phase;

- (NSNumber*) getDragonBuyLimit:(NSNumber*)aRow;

- (NSMutableArray*) generateTrains;

@end
