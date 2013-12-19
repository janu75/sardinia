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
    if (![message isEqualToString:@""]) {
        self.textLog.string = [NSString stringWithFormat:@"%@\n%@", message, self.textLog.string];
    }
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
        NSTableColumn *col = [self.companyTableView tableColumnWithIdentifier:@"CFD"];
        [col setHidden:YES];
        col = [self.companyTableView tableColumnWithIdentifier:@"CFC"];
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
    [self.stockStartingPriceLabel setStringValue:[NSString stringWithFormat:@"Initial Price (60-%d):", [self.game getMaxInitialStockPrice]]];
    [self.stockStartingPrice removeAllItems];
    [self.stockStartingPrice addItemsWithTitles:[self.game.settings getInitialValuesForMoney:aPlayer.money]];
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

- (NSArray*) buildAbsorbItemsList:(NSArray*)comps {
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:7];
    for (Company* comp in comps) {
        [list addObject:comp.shortName];
    }
    return list;
}

- (void) updateButtonsForCompany:(Company*)comp {
    NSArray *absorbCandidates = [self.game companyCanAbsorb:comp];
    if ([absorbCandidates count]) {
        [self.or_buttonAbsorbOther setEnabled:YES];
        [self.or_popupAbsorb removeAllItems];
        [self.or_popupAbsorb addItemsWithTitles:[self buildAbsorbItemsList:absorbCandidates]];
        [self.or_popupAbsorb setEnabled:YES];
    } else {
        [self.or_buttonAbsorbOther setEnabled:NO];
        [self.or_popupAbsorb setEnabled:NO];
    }
    if ([self.game companyCanGetAbsorbed:comp]) {
        [self.or_buttonAbsorbThis setEnabled:YES];
    } else {
        [self.or_buttonAbsorbThis setEnabled:NO];
    }
//    if ([absorbCandidates count] && [comp canGetAbsorbed]) {
//        self.or_textAbsorbOr.stringValue = @"or";
//    } else {
//        self.or_textAbsorbOr.stringValue = @"";
//    }
    [self.or_buttonLay2ndTrack setEnabled:comp.canLay2ndTrack];
    [self.or_buttonPlaceStation setEnabled:comp.canBuildStation];
    [self.or_textfieldStationCost setEnabled:comp.canBuildStation];
    if (comp.didOperateThisTurn) {
        [self.or_buttonOperateTrains setEnabled:NO];
        self.or_textfieldOperateText.stringValue = [NSString stringWithFormat:@"for L.%d",comp.lastIncome];
    } else {
        [self.or_buttonOperateTrains setEnabled:YES];
        self.or_textfieldOperateText.stringValue = [NSString stringWithFormat:@"for L.%d",MIN(comp.traffic, comp.trainCapacity)*10];
    }
    if ([self.game companyCanBuyTrain:comp]) {
        NSArray *trains = [self.game getTrainTextFromTrainList:[self.game getTrainsForPurchaseForCompany:comp] ForCompany:comp];
        [self.or_buttonBuyTrain setEnabled:YES];
        [self.or_popupTrain setEnabled:YES];
        [self.or_popupTrain removeAllItems];
        [self.or_popupTrain addItemsWithTitles:trains];
    } else {
        [self.or_buttonBuyTrain setEnabled:NO];
        [self.or_popupTrain setEnabled:NO];
        [self.or_popupTrain removeAllItems];
    }

    self.or_CompanyName.stringValue = [NSString stringWithFormat:@"%@: %@", comp.shortName, comp.name];
    self.or_presidentName.stringValue = [NSString stringWithFormat:@"President: %@", comp.president.name];
    Player *president = (Player*) comp.president;
    if ([president.maritimeCompany count]) {
        [self.or_buttonHandOverMaritime setEnabled:YES];
    } else {
        [self.or_buttonHandOverMaritime setEnabled:NO];
    }
    if ([comp.maritimeCompanies count]) {
        [self.or_buttonConnectMaritime setEnabled:YES];
    } else {
        [self.or_buttonConnectMaritime setEnabled:NO];
    }
    if (comp.didOperateThisTurn && [comp.trains count]>0) {
        [self.or_buttonOperateDone setEnabled:YES];
    } else {
        [self.or_buttonOperateDone setEnabled:NO];
    }
}

- (IBAction)stockPassButton:(NSButton *)sender {
    [self printLog:[NSString stringWithFormat:@"%@ passes", self.game.currentPlayer.name]];
    [self printLog:[self.game advancePlayersDidPass:YES]];
    [self refreshView];
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
    NSArray *priceList = [self.game.settings getInitialValuesForMoney:1000];
    int price = 0;
    if (self.stockStartingPrice.selectedItem) {
        NSUInteger ind = [self.stockStartingPrice indexOfSelectedItem];
        price = [priceList[ind]intValue];
    }
    [self printLog:[self.game player:self.game.currentPlayer BuysIpoShare:comp AtPrice:price]];
    [self printLog:[self.game advancePlayersDidPass:NO]];
    [self refreshView];
}

- (IBAction)buyBankButton:(NSButton *)sender {
    NSUInteger index = [self.bankBuyButton indexOfObject:sender];
    Company *comp = self.game.companies[index];
    [self printLog:[self.game player:self.game.currentPlayer BuysBankShare:comp]];
    [self printLog:[self.game advancePlayersDidPass:NO]];
    [self refreshView];
}

- (IBAction)buyDragonButton:(NSButton*)sender {
    NSUInteger index = [self.dragonBuyButton indexOfObject:sender];
    Company *comp = self.game.companies[index];
    [self printLog:[self.game player:self.game.currentPlayer BuysDragonShare:comp]];
    [self printLog:[self.game advancePlayersDidPass:NO]];
    [self refreshView];
}

- (IBAction)sellButton:(NSButton *)sender {
    NSUInteger index = [self.sellButton indexOfObject:sender];
    Company *comp = self.game.companies[index];
    [self printLog:[self.game player:self.game.currentPlayer SellsShare:comp]];
    [self refreshView];
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
    [self refreshView];
}

- (void) refreshView {
    [self updateTableData];
    if ([self.game.round isEqualToString:@"Stock Round"]) {
        [self.actionTabView selectTabViewItemAtIndex:0];
        [self updateButtonsForPlayer:self.game.currentPlayer];
    } else {
        [self.actionTabView selectTabViewItemAtIndex:1];
        [self updateButtonsForCompany:[self.game.companyTurnOrder firstObject]];
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
    NSIndexSet *indexSet;
    if ([self.game.round isEqualToString:@"Stock Round"]) {
        indexSet = [NSIndexSet indexSetWithIndex:[self.game.player indexOfObject:self.game.currentPlayer]+2];
    } else {
        Company *comp = [self.game.companyTurnOrder firstObject];
        indexSet = [NSIndexSet indexSetWithIndex:[self.game.player indexOfObject:comp.president]+2];
    }
    [self.companyTableView selectRowIndexes:indexSet byExtendingSelection:NO];
    [self.companyTable updateTableData];
}

- (IBAction)actionAbsorbAnotherCompany:(NSButton *)sender {
    NSLog(@"Todo: Implementation of absorbtion");
}

- (IBAction)actionAbsorbThisCompany:(NSButton *)sender {
    NSLog(@"Todo: Implementation of absorbtion");
}

- (IBAction)actionLay2ndTrack:(NSButton *)sender {
    Company *comp = [self.game.companyTurnOrder firstObject];
    [comp layExtraTrack];
    [self refreshView];
}

- (IBAction)actionPlaceStationToken:(NSButton *)sender {
    Company *comp = [self.game.companyTurnOrder firstObject];
    int cost = [self.or_textfieldStationCost.stringValue intValue];
    [comp placeStationMarkerForCost:cost];
    [self refreshView];
}

- (IBAction)actionAddTraffic:(NSButton *)sender {
    Company *comp = [self.game.companyTurnOrder firstObject];
    int traffic = [self.or_textfieldTraffic.stringValue intValue];
    [comp trafficUpgrade:traffic];
    [self refreshView];
}

- (IBAction)actionOperateTrains:(NSButton *)sender {
    Company *comp = [self.game.companyTurnOrder firstObject];
    BOOL payDividend = (self.or_buttonPayDividend.state==NSOnState) ? YES : NO;
    [comp operateTrainsAndPayDividend:payDividend];
    [self refreshView];
}

- (IBAction)actionBuyTrain:(NSButton *)sender {
    Company *comp = [self.game.companyTurnOrder firstObject];
    if (self.or_popupTrain) {
        NSUInteger trainNum = [self.or_popupTrain indexOfSelectedItem];
        int cost = self.or_textfieldTrainCost.stringValue.intValue;
        [self printLog:[self.game company:comp BuysTrain:trainNum AtCost:cost]];
    }
    [self refreshView];
}

- (IBAction)actionHandOverMCompany:(NSButton *)sender {
    [self printLog:[self.game presidentHandsOverMaritimeCompanyTo:[self.game.companyTurnOrder firstObject]]];
    [self refreshView];
}

- (IBAction)actionConnectMCompany:(NSButton *)sender {
    [self printLog:[self.game companyConnectsToMaritimeCompany:[self.game.companyTurnOrder firstObject]]];
    [self refreshView];
}

- (IBAction)actionOperatingTurnDone:(NSButton *)sender {
    [self printLog:[self.game advancePlayersDidPass:NO]];
    [self refreshView];
}

@end
