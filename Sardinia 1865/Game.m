//
//  Game.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "Game.h"
#import "Company.h"
#import "GameSettings.h"

@implementation Game

- (id) initWithPlayers:(NSArray *)playerNames AndShortMode:(BOOL)isShort {
    self = [super init];
    if (self) {
        self.settings = [[GameSettings alloc] init];
        NSMutableArray *companies = [[NSMutableArray alloc] initWithCapacity:8];
        self.compNames = [self.settings companyShortNames];
        for (NSString *name in self.compNames) {
            [companies addObject:[[Company alloc] initWithName:name IsMajor:NO]];
        }
        self.companies = companies;
        NSMutableArray *players = [[NSMutableArray alloc] initWithCapacity:4];
        for (NSString* name in playerNames) {
            [players addObject:[[Player alloc] initWithName:name]];
        }
        self.player = players;
    }
    return self;
}

- (BOOL) player:(Player *)aPlayer CanBuy:(int)nComp FromShareholder:(Shareholder*)aShareholder {
    int playerShare       = [self.companies[nComp] getShareByOwner:aPlayer];
    int shareholderShare  = [self.companies[nComp] getShareByOwner:aShareholder];
    if (playerShare < 60 && shareholderShare > 0) {
        return YES;
    }
    return NO;
}

- (BOOL) player:(Player *)aPlayer CanBuyFromBank:(int)nComp {
    return [self player:aPlayer CanBuy:nComp FromShareholder:self.bank];
}

- (BOOL) player:(Player *)aPlayer CanBuyFromDragon:(int)nComp {
    return [self player:aPlayer CanBuy:nComp FromShareholder:self.dragon];
}

- (BOOL) player:(Player *)aPlayer CanBuyFromIpo:(int)nComp {
    return [self player:aPlayer CanBuy:nComp FromShareholder:self.companies[nComp]];
}

- (BOOL) player:(Player *)aPlayer CanSell:(int)nComp {
    Company *comp = self.companies[nComp];
    BOOL canSell = NO;
    if (comp.president == aPlayer) {
        for (Player *player in self.player) {
            if (player != aPlayer) {
                if ([comp getShareByOwner:player] > 10) {
                    canSell = YES;
                }
            }
        }
    } else {
        if ([comp getShareByOwner:aPlayer] > 0) {
            canSell = YES;
        }
    }
    if ([comp getShareByOwner:self.bank] > 40) {
        canSell = NO;
    }
    return canSell;
}

@end
