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
            [array addObject:[NSString stringWithFormat:@"%d%%", [comp getShareByOwner:guy]]];
        }
        [dict setObject:array forKey:comp.shortName];
    }
    self.overviewTableData = dict;
    [self.companyTableView reloadData];
}

//// This method is optional if you use bindings to provide the data
//- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    // Group our "model" object, which is a dictionary
//    NSDictionary *dictionary = [_tableContents objectAtIndex:row];
//    
//    // In IB the tableColumn has the identifier set to the same string as the keys in our dictionary
//    NSString *identifier = [tableColumn identifier];
//    
//    if ([identifier isEqualToString:@"MainCell"]) {
//        // We pass us as the owner so we can setup target/actions into this main controller object
//        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
//        // Then setup properties on the cellView based on the column
//        cellView.textField.stringValue = [dictionary objectForKey:@"Name"];
//        cellView.imageView.objectValue = [dictionary objectForKey:@"Image"];
//        return cellView;
//    } else if ([identifier isEqualToString:@"SizeCell"]) {
//        NSTextField *textField = [tableView makeViewWithIdentifier:identifier owner:self];
//        NSImage *image = [dictionary objectForKey:@"Image"];
//        NSSize size = image ? [image size] : NSZeroSize;
//        NSString *sizeString = [NSString stringWithFormat:@"%.0fx%.0f", size.width, size.height];
//        textField.objectValue = sizeString;
//        return textField;
//    } else {
//        NSAssert1(NO, @"Unhandled table column identifier %@", identifier);
//    }
//    return nil;
//}

@end
