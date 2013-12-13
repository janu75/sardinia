//
//  Game.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameSettings.h"
#import "Player.h"
#import "Bank.h"
#import "Dragon.h"

@interface Game : NSObject

@property (strong) NSArray* companies;
@property (strong) NSArray* player;
@property (strong) GameSettings* settings;
@property (strong) NSArray *compNames; // of NSString
@property (strong) Bank* bank;
@property (strong) Dragon* dragon;

- (id) initWithNumberOfPlayers:(int)numPlayer AndShortMode:(BOOL)isShort;

- (BOOL) player:(Player*)aPlayer CanBuyFromIpo:(int)nComp;

- (BOOL) player:(Player*)aPlayer CanBuyFromBank:(int)nComp;

- (BOOL) player:(Player*)aPlayer CanBuyFromDragon:(int)nComp;

- (BOOL) player:(Player*)aPlayer CanSell:(int)nComp;


@end
