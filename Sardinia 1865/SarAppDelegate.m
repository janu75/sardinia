//
//  SarAppDelegate.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "SarAppDelegate.h"
#import "Company.h"
#import "GameSetupWindowController.h"

@implementation SarAppDelegate

GameSetupWindowController *setupWindow;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    setupWindow = [[GameSetupWindowController alloc] initWithWindowNibName:@"GameSetupWindow"];
    [setupWindow showWindow:self];
//    [setupWindow.window setLevel:NSFloatingWindowLevel];
    [setupWindow useSettings:self];
    [setupWindow.window makeKeyAndOrderFront:setupWindow];
    [self printLog:@"Settings window opened"];
    
}

- (void) printLog:(NSString*)message {
    self.textLog.string = [NSString stringWithFormat:@"%@\n%@", self.textLog.string, message];
}

- (void) setupStockMarketButtons {
    self.ipoBuyButton = @[self.buttonIPO1,
                          self.buttonIPO2,
                          self.buttonIPO3,
                          self.buttonIPO4,
                          self.buttonIPO5,
                          self.buttonIPO6];
    self.bankBuyButton = @[self.buttonBank1,
                           self.buttonBank2,
                           self.buttonBank3,
                           self.buttonBank4,
                           self.buttonBank5,
                           self.buttonBank6];
    self.dragonBuyButton = @[self.buttonDragon1,
                             self.buttonDragon2,
                             self.buttonDragon3,
                             self.buttonDragon4,
                             self.buttonDragon5,
                             self.buttonDragon6];
    self.sellButton = @[self.buttonSell1,
                        self.buttonSell2,
                        self.buttonSell3,
                        self.buttonSell4,
                        self.buttonSell5,
                        self.buttonSell6];
    self.stockCompanyLabel = @[self.stockLabelComp1,
                               self.stockLabelComp2,
                               self.stockLabelComp3,
                               self.stockLabelComp4,
                               self.stockLabelComp5,
                               self.stockLabelComp6];
    if (!self.game.settings.isShortGame) {
        self.ipoBuyButton = [self.ipoBuyButton arrayByAddingObjectsFromArray:@[self.buttonIPO7, self.buttonIPO8]];
        self.bankBuyButton = [self.bankBuyButton arrayByAddingObjectsFromArray:@[self.buttonBank7,self.buttonBank8]];
        self.dragonBuyButton = [self.dragonBuyButton arrayByAddingObjectsFromArray:@[self.buttonDragon7, self.buttonDragon8]];
        self.sellButton = [self.sellButton arrayByAddingObjectsFromArray:@[self.buttonSell7, self.buttonSell8]];
        self.stockCompanyLabel = [self.stockCompanyLabel arrayByAddingObjectsFromArray:@[self.stockLabelComp7, self.stockLabelComp8]];
    } else {
        [self.buttonIPO7 setTransparent:YES];
        [self.buttonIPO8 setTransparent:YES];
        [self.buttonBank7 setTransparent:YES];
        [self.buttonBank8 setTransparent:YES];
        [self.buttonDragon7 setTransparent:YES];
        [self.buttonDragon8 setTransparent:YES];
        [self.buttonSell7 setTransparent:YES];
        [self.buttonSell8 setTransparent:YES];
        [self.stockLabelComp7 setStringValue:@""];
        [self.stockLabelComp8 setStringValue:@""];
    }
}

- (void) setupPlayerOverviewLabels {
    if (self.game.settings.isShortGame) {
        NSTableColumn *col = [self.companyTableView tableColumnWithIdentifier:@"RCSF"];
        [col setHidden:YES];
        col = [self.companyTableView tableColumnWithIdentifier:@"SFSS"];
        [col setHidden:YES];
    }
}

- (NSString*) formatStockPriceForDragon:(Company*)comp {
    int stockPrice = comp.stockPrice;
    if ([comp isDragonBuy]) {
        stockPrice = [self.game.settings getDragonPriceWithStockPrice:stockPrice AndGrade:@"Buy"];
    } else if ([comp isDragonSell]) {
        stockPrice = [self.game.settings getDragonPriceWithStockPrice:stockPrice AndGrade:@"Sell"];
    } else {
        stockPrice = [self.game.settings getDragonPriceWithStockPrice:stockPrice AndGrade:@"Neutral"];
    }
    if (stockPrice > 0) {
        return [NSString stringWithFormat:@"L. %d", comp.stockPrice];
    }
    return @"N/A";
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
    [self.stockStartingPriceLabel setStringValue:[NSString stringWithFormat:@"Initial Price (50-%d):", [self.game getMaxInitialStockPrice]]];
    int i=0;
    for (NSButton *button in self.ipoBuyButton) {
        Company *comp = self.game.companies[i];
        [button setTitle:[self formatStockPrice:comp]];
        [button setEnabled:[self.game player:aPlayer CanBuyFromIpo:i++]];
    }
    i=0;
    for (NSButton *button in self.dragonBuyButton) {
        Company *comp = self.game.companies[i];
        [button setTitle:[self formatStockPriceForDragon:comp]];
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
    i=0;
    for (NSTextField* label in self.stockCompanyLabel) {
        label.stringValue = self.game.compNames[i++];
    }
}

- (IBAction)stockPassButton:(NSButton *)sender {
    [self printLog:[NSString stringWithFormat:@"%@ did pass", self.game.currentPlayer.name]];
    [self printLog:[self.game advancePlayersDidPass:YES]];
    [self nextPlayer];
}

- (IBAction)stockInitialPrice:(NSTextField *)sender {
    int price = [sender.stringValue intValue];
    price = price/10;
    price = price*10;
    price = MIN(price, [self.game getMaxInitialStockPrice]);
    price = MAX(price, 60);
    [sender setStringValue:[NSString stringWithFormat:@"%d", price]];
}

- (IBAction)buyIpoButton:(NSButton *)sender {
    NSUInteger index = [self.ipoBuyButton indexOfObject:sender];
    Company *comp = self.game.companies[index];
    if ([comp getShareByOwner:comp] == 100) {
        // Initial offer
        [comp setInitialStockPrice:[self.stockStartingPrice.stringValue intValue]];
    }
    Certificate *cert = [comp certificateFromOwner:comp];
    [comp sellCertificate:cert To:self.game.currentPlayer];
    [self printLog:[NSString stringWithFormat:@"%@ buys %@ of %@ from Initial Offer", self.game.currentPlayer.name, cert.type, comp.shortName]];
    [self printLog:[self.game advancePlayersDidPass:NO]];
    [self nextPlayer];
}

- (IBAction)buyBankButton:(NSButton *)sender {
    NSUInteger index = [self.bankBuyButton indexOfObject:sender];
    Company *comp = self.game.companies[index];
    Certificate *cert = [comp certificateFromOwner:self.game.bank];
    [comp sellCertificate:cert To:self.game.currentPlayer];
    [self printLog:[NSString stringWithFormat:@"%@ buys %@ of %@ from Bank", self.game.currentPlayer.name, cert.type, comp.shortName]];
    [self printLog:[self.game advancePlayersDidPass:NO]];
    [self nextPlayer];
}

- (IBAction)buyDragonButton:(NSButton*)sender {
    NSUInteger index = [self.dragonBuyButton indexOfObject:sender];
    Company *comp = self.game.companies[index];
    Certificate *cert = [comp certificateFromOwner:self.game.dragon];
    [comp sellCertificate:cert To:self.game.currentPlayer];
    [self printLog:[NSString stringWithFormat:@"%@ buys %@ of %@ from Dragon", self.game.currentPlayer.name, cert.type, comp.shortName]];
    [self printLog:[self.game advancePlayersDidPass:NO]];
    [self nextPlayer];
}

- (IBAction)sellButton:(NSButton *)sender {
    NSUInteger index = [self.sellButton indexOfObject:sender];
    Company *comp = self.game.companies[index];
    Certificate *cert = [comp certificateFromOwner:self.game.currentPlayer];
    [comp sellCertificate:cert To:self.game.bank];
    [self printLog:[NSString stringWithFormat:@"%@ sells %@ of %@ to Bank", self.game.currentPlayer.name, cert.type, comp.shortName]];
    [self.game.currentPlayer.soldCompanies addObject:comp];
    [self updateTableData];
    [self updateButtonsForPlayer:self.game.currentPlayer];
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

- (void) setPlayers:(NSArray *)players AndGameMode:(BOOL)isShort {
    self.playerNames = players;
    self.isShortGame = isShort;
    [setupWindow close];
    setupWindow = nil;
    NSLog(@"Got Players %@", self.playerNames);
    self.game = [[Game alloc] initWithPlayers:players AndShortMode:isShort];
    self.companyTable.game = self.game;
    [self setupPlayerOverviewLabels];
    [self setupStockMarketButtons];
    [self printLog:@"Game started"];
    [self nextPlayer];
}

- (void) nextPlayer {
    [self updateTableData];
    if ([self.game.round isEqualToString:@"Stock Round"]) {
        [self.actionTabView selectTabViewItemAtIndex:0];
        [self updateButtonsForPlayer:self.game.currentPlayer];
    } else {
        [self.actionTabView selectTabViewItemAtIndex:1];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return (NSInteger) [self.game.player count] + 2;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = [tableColumn identifier];
    NSArray *rowData = self.overviewTableData[identifier];
    
    if (rowData && [rowData count] > row) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        cellView.textField.stringValue = rowData[row];
        return cellView;
    } else {
        NSTextField *cellView = [[NSTextField alloc] initWithFrame:tableView.frame];
        cellView.stringValue = [NSString stringWithFormat:@"??%@-%ld??", identifier, (long)row];
        return cellView;
//        NSAssert1(NO, @"Unhandled table column identifier %@", identifier);
    }
    return nil;
}

- (void) updateTableData {
    NSMutableArray *player = [@[@"Bank", @"Dragon"] mutableCopy];
    NSMutableArray *money = [@[[NSNumber numberWithInt:self.game.bank.money], [NSNumber numberWithInt:self.game.dragon.money]] mutableCopy];
    NSMutableArray *cert = [@[[NSNumber numberWithInt:self.game.bank.numCertificates], [NSNumber numberWithInt:self.game.dragon.numCertificates]] mutableCopy];
    for (Player *guy in self.game.player) {
        [player addObject:guy.name];
        [money addObject:[NSNumber numberWithInt:guy.money]];
        [cert addObject:[NSString stringWithFormat:@"%luM + %d", (unsigned long)[guy.maritimeCompany count], guy.numCertificates]];
    }
    NSMutableDictionary *dict = [@{@"Player"       : player,
                                  @"Money"        : money,
                                  @"Certificates" : cert} mutableCopy];
    for (Company *comp in self.game.companies) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:6];
        [array addObject:[NSString stringWithFormat:@"%d%%", [comp getShareByOwner:self.game.bank]]];
        [array addObject:[NSString stringWithFormat:@"%d%%", [comp getShareByOwner:self.game.dragon]]];
        for (Player *guy in self.game.player) {
            if (comp.president == guy) {
                [array addObject:[NSString stringWithFormat:@"* %d%%", [comp getShareByOwner:guy]]];
            } else {
                [array addObject:[NSString stringWithFormat:@"%d%%", [comp getShareByOwner:guy]]];
            }
        }
        [dict setObject:array forKey:comp.shortName];
    }
    self.overviewTableData = dict;
    [self.companyTableView reloadData];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[self.game.player indexOfObject:self.game.currentPlayer]+2];
    [self.companyTableView selectRowIndexes:indexSet byExtendingSelection:NO];
    [self.companyTable updateTableData];
}

@end
