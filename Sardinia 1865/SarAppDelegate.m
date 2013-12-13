//
//  SarAppDelegate.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "SarAppDelegate.h"
#import "Company.h"

@implementation SarAppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.game = [[Game alloc] initWithNumberOfPlayers:4 AndShortMode:NO];
    self.textLog.string = @"Game started";
    [self setupStockMarketButtons];
//    [self testButtons];
    [self updateButtonsForPlayer:self.game.player[0]];
}

- (void) setupStockMarketButtons {
    self.ipoBuyButton = [[NSArray alloc] initWithObjects:
                         self.buttonIPO1,
                         self.buttonIPO2,
                         self.buttonIPO3,
                         self.buttonIPO4,
                         self.buttonIPO5,
                         self.buttonIPO6,
                         self.buttonIPO7,
                         self.buttonIPO8, nil];
    self.bankBuyButton = [[NSArray alloc] initWithObjects:
                          self.buttonBank1,
                          self.buttonBank2,
                          self.buttonBank3,
                          self.buttonBank4,
                          self.buttonBank5,
                          self.buttonBank6,
                          self.buttonBank7,
                          self.buttonBank8,
                          nil];
    self.dragonBuyButton = [[NSArray alloc] initWithObjects:
                            self.buttonDragon1,
                            self.buttonDragon2,
                            self.buttonDragon3,
                            self.buttonDragon4,
                            self.buttonDragon5,
                            self.buttonDragon6,
                            self.buttonDragon7,
                            self.buttonDragon8,
                            nil];
    self.sellButton = [[NSArray alloc] initWithObjects:
                       self.buttonSell1,
                       self.buttonSell2,
                       self.buttonSell3,
                       self.buttonSell4,
                       self.buttonSell5,
                       self.buttonSell6,
                       self.buttonSell7,
                       self.buttonSell8,
                       nil];
}

- (NSString*) formatStockPrice:(Company*)comp {
    if (comp.stockPrice > 0) {
        return [NSString stringWithFormat:@"L. %d", comp.stockPrice];
    }
    return @"N/A";
}

- (void) updateButtonsForPlayer:(Player*)aPlayer {
    [self.stockRoundMoneyLabel setStringValue:[NSString stringWithFormat:@"L. %d", aPlayer.money]];
    [self.stockRoundPlayerLabel setStringValue:[NSString stringWithFormat:@"Player %@", aPlayer.name]];
    int i=0;
    for (NSButton *button in self.ipoBuyButton) {
        Company *comp = self.game.companies[i];
        [button setTitle:[self formatStockPrice:comp]];
        [button setEnabled:[self.game player:aPlayer CanBuyFromIpo:i++]];
    }
    i=0;
    for (NSButton *button in self.dragonBuyButton) {
        Company *comp = self.game.companies[i];
        [button setTitle:[self formatStockPrice:comp]];
        [button setEnabled:[self.game player:aPlayer CanBuyFromDragon:i++]];
    }
    i=0;
    for (NSButton *button in self.bankBuyButton) {
        Company *comp = self.game.companies[i];
        [button setTitle:[self formatStockPrice:comp]];
        [button setEnabled:[self.game player:aPlayer CanBuyFromBank:i++]];
    }
    i=0;
    for (NSButton *button in self.sellButton) {
        Company *comp = self.game.companies[i];
        [button setTitle:[self formatStockPrice:comp]];
        [button setEnabled:[self.game player:aPlayer CanSell:i++]];
    }
}

- (void) testButtons {
    int i=0;
    for (NSButton *button in self.ipoBuyButton) {
        [button setTitle:[NSString stringWithFormat:@"IPO %d", i++]];
    }
    i=0;
    for (NSButton *button in self.bankBuyButton) {
        [button setTitle:[NSString stringWithFormat:@"Bank %d", i++]];
    }
    i=0;
    for (NSButton *button in self.dragonBuyButton) {
        [button setTitle:[NSString stringWithFormat:@"Dra %d", i++]];
    }
    i=0;
    for (NSButton *button in self.sellButton) {
        [button setTitle:[NSString stringWithFormat:@"Sell %d", i++]];
    }
}

@end
