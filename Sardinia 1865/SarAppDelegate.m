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
        self.conversionButtons = @{@"FMS"  : self.bu_buttonConvertFMS,
                                   @"RCSF" : self.bu_buttonConvertRCSF,
                                   @"SFSS" : self.bu_buttonConvertSFSS,
                                   @"FCS"  : self.bu_buttonConvertFCS,
                                   @"SFS"  : self.bu_buttonConvertSFS,
                                   @"FA"   : self.bu_buttonConvertFA,
                                   @"CFC"  : self.bu_buttonConvertCFC,
                                   @"CFD"  : self.bu_buttonConvertCFD
                                   };
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
        self.conversionButtons = @{@"FMS"  : self.bu_buttonConvertFMS,
                                   @"RCSF" : self.bu_buttonConvertRCSF,
                                   @"SFSS" : self.bu_buttonConvertSFSS,
                                   @"FCS"  : self.bu_buttonConvertFCS,
                                   @"SFS"  : self.bu_buttonConvertSFS,
                                   @"FA"   : self.bu_buttonConvertFA
                                   };
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
        return [NSString stringWithFormat:@"L. %d", stockPrice];
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
        NSLog(@"Dragon price for %@ is %@", comp.shortName, [self formatStockPriceForDragon:comp]);
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
    if (aPlayer.numLoans > 0 && aPlayer.money>=500) {
        [self.buttonPlayerPayBackLoan setEnabled:YES];
    } else {
        [self.buttonPlayerPayBackLoan setEnabled:NO];
    }
}

- (NSArray*) buildAbsorbItemsList:(NSArray*)comps {
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:7];
    for (Company* comp in comps) {
        [list addObject:[NSString stringWithFormat:@"%@ for L.%d", comp.shortName, [comp getCompanyCost]]];
    }
    return list;
}

- (void) updateButtonsForCompany:(Company*)comp {
    NSArray *absorbCandidates = [self.game companyCanAbsorb:comp];
    if ([absorbCandidates count]) {
        [self.or_buttonAbsorbOther setEnabled:YES];
        [self.or_buttonAbsorbOther setTransparent:NO];
        [self.or_popupAbsorb removeAllItems];
        [self.or_popupAbsorb addItemsWithTitles:[self buildAbsorbItemsList:absorbCandidates]];
        [self.or_popupAbsorb setEnabled:YES];
        [self.or_popupAbsorb setTransparent:NO];
    } else {
        [self.or_buttonAbsorbOther setEnabled:NO];
        [self.or_buttonAbsorbOther setTransparent:YES];
        [self.or_popupAbsorb setEnabled:NO];
        [self.or_popupAbsorb setTransparent:YES];
    }
    if ([self.game companyCanGetAbsorbed:comp]) {
        [self.or_buttonAbsorbThis setEnabled:YES];
        [self.or_buttonAbsorbThis setTransparent:NO];
    } else {
        [self.or_buttonAbsorbThis setEnabled:NO];
        [self.or_buttonAbsorbThis setTransparent:YES];
    }
    if ([absorbCandidates count] && [self.game companyCanGetAbsorbed:comp]) {
        self.or_textAbsorbOr.stringValue = @"or";
    } else {
        self.or_textAbsorbOr.stringValue = @"";
    }
    [self.or_buttonLay2ndTrack setEnabled:comp.canLay2ndTrack];
    [self.or_buttonPlaceStation setEnabled:comp.canBuildStation];
    [self.or_textfieldStationCost setEnabled:comp.canBuildStation];
    if (comp.didOperateThisTurn) {
        [self.or_buttonOperateTrains setEnabled:NO];
        self.or_textfieldOperateText.stringValue = [NSString stringWithFormat:@"for L.%d",comp.lastIncome];
        [self.or_buttonAddTraffic setEnabled:NO];
    } else {
        [self.or_buttonOperateTrains setEnabled:YES];
        self.or_textfieldOperateText.stringValue = [NSString stringWithFormat:@"for L.%d",MIN(comp.traffic, comp.trainCapacity)*10];
        [self.or_buttonAddTraffic setEnabled:YES];
    }
    if ([self.game companyCanBuyTrain:comp]) {
        NSArray *trainLabels = [self.game getTrainTextForCompany:comp];
        [self.or_buttonBuyTrain setEnabled:YES];
        [self.or_popupTrain setEnabled:YES];
        [self.or_popupTrain removeAllItems];
        [self.or_popupTrain addItemsWithTitles:trainLabels];
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
    if (president.money < 0) {
        [self.or_buttonOperateDone setEnabled:NO];
        [self.or_popupPresidentSellCompanies removeAllItems];
        [self.or_popupPresidentSellCompanies addItemWithTitle:[NSString stringWithFormat:@"%@ has to sell shares", president.name]];
        NSArray* list = [self.game getListOfCertificatesForSaleForPresident:comp];
        if ([list count]) {
            [self.or_popupPresidentSellCompanies addItemsWithTitles:list];
        } else {
            [self.or_popupPresidentSellCompanies addItemWithTitle:@"Take loan for L.500"];
        }
        [self.or_popupPresidentSellCompanies setEnabled:YES];
    } else {
        [self.or_popupPresidentSellCompanies setEnabled:NO];
    }
    if (comp.numLoans > 0 && comp.money>=500) {
        [self.or_buttonCompanyPayBackLoan setEnabled:YES];
    } else {
        [self.or_buttonCompanyPayBackLoan setEnabled:NO];
    }
}

- (void) updateButtonsForBureaucracy {
    for (Company *comp in self.game.companies) {
        NSButton *button = self.conversionButtons[comp.shortName];
        if ([comp canConvertToMajor]) {
            [button setEnabled:YES];
            [button setTransparent:NO];
        } else {
            [button setEnabled:NO];
            [button setTransparent:YES];
        }
    }
    NSString *msg = [self.game downgradeMinesSentence];
    if (msg) {
        [self.bu_labelDownGradeMines setStringValue:msg];
    } else {
        [self.bu_labelDownGradeMines setStringValue:@""];
    }
}

- (IBAction)stockPassButton:(NSButton *)sender {
    [self printLog:[NSString stringWithFormat:@"%@ passes", self.game.currentPlayer.name]];
    [self printLog:[self.game advancePlayersDidPass:YES]];
    [self refreshView];
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
    [self.companyTable loadNewGame:self.game];
    [self.playerRanking loadNewGame:self.game];
    [self setupPlayerOverviewLabels];
    [self setupStockMarketButtons];
    [self printLog:@"Game started"];
    [self refreshView];
}

- (void) refreshView {
    [self updateTableData];
    // Initial call, clean up tab view
    if ([self.actionTabView numberOfTabViewItems] > 3) {
        self.tabViewItemStockRound     = [self.actionTabView tabViewItemAtIndex:0];
        self.tabViewItemOperatingRound = [self.actionTabView tabViewItemAtIndex:1];
        self.tabViewItemBureaucracy    = [self.actionTabView tabViewItemAtIndex:2];
        [self.actionTabView removeTabViewItem:self.tabViewItemStockRound];
        [self.actionTabView removeTabViewItem:self.tabViewItemOperatingRound];
    }
    if ([self.game.round isEqualToString:@"Stock Round"]) {
        if ([self.actionTabView indexOfTabViewItem:self.tabViewItemStockRound] == NSNotFound) {
            [self.actionTabView removeTabViewItem:self.tabViewItemBureaucracy];
            [self.actionTabView insertTabViewItem:self.tabViewItemStockRound atIndex:0];
            [self.actionTabView selectTabViewItemAtIndex:0];
        }
        [self updateButtonsForPlayer:self.game.currentPlayer];
    } else if ([self.game.round isEqualToString:@"Operating Round"]) {
        if ([self.actionTabView indexOfTabViewItem:self.tabViewItemOperatingRound] == NSNotFound) {
            [self.actionTabView removeTabViewItem:self.tabViewItemStockRound];
            [self.actionTabView insertTabViewItem:self.tabViewItemOperatingRound atIndex:0];
            [self.actionTabView selectTabViewItemAtIndex:0];
        }
        [self updateButtonsForCompany:[self.game.companyTurnOrder firstObject]];
    } else {
        if ([self.actionTabView indexOfTabViewItem:self.tabViewItemBureaucracy] == NSNotFound) {
            [self.actionTabView removeTabViewItem:self.tabViewItemOperatingRound];
            [self.actionTabView insertTabViewItem:self.tabViewItemBureaucracy atIndex:0];
            [self.actionTabView selectTabViewItemAtIndex:0];
        }
        [self updateButtonsForBureaucracy];
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
    NSMutableArray *cert = [@[[NSNumber numberWithInt:self.game.bank.numCertificates], [NSString stringWithFormat:@"%d/%d", self.game.dragon.numCertificates, [self.game.settings certificateLimit:@"Dragon"]]] mutableCopy];
    NSMutableArray *loans = [@[[NSNumber numberWithInt:0], [NSNumber numberWithInt:0]] mutableCopy];
    for (Player *guy in self.game.player) {
        [player addObject:guy.name];
        [money addObject:[NSNumber numberWithInt:guy.money]];
        int limit = [self.game.settings certificateLimit:guy.name];
        [cert addObject:[NSString stringWithFormat:@"%luM + %d/%d", (unsigned long)[guy.maritimeCompany count], guy.numCertificates, limit]];
        [loans addObject:[NSNumber numberWithInt:guy.numLoans]];
    }
    NSMutableDictionary *dict = [@{@"Player"       : player,
                                   @"Money"        : money,
                                   @"Certificates" : cert,
                                   @"Loans"        : loans} mutableCopy];
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
        [self.companyTableView selectRowIndexes:indexSet byExtendingSelection:NO];
    } else if ([self.game.round isEqualToString:@"Operating Round"]) {
        Company *comp = [self.game.companyTurnOrder firstObject];
        indexSet = [NSIndexSet indexSetWithIndex:[self.game.player indexOfObject:comp.president]+2];
        [self.companyTableView selectRowIndexes:indexSet byExtendingSelection:NO];
    }
    [self.companyTable updateTableData];
    [self.playerRanking updateTableData];
    if ([self.game.round isEqualToString:@"Operating Round"]) {
        self.textFieldOperatingRound.stringValue = [NSString stringWithFormat:@"Operating Round - %d", self.game.operatingRoundNum];
    } else {
        self.textFieldOperatingRound.stringValue = self.game.round;
    }
    self.textFieldTrainPhase.stringValue = [NSString stringWithFormat:@"Phase: %d", self.game.settings.phase];
    self.textFieldTurnMarker.stringValue = [NSString stringWithFormat:@"Player turns: %d", self.game.turnCount];
    self.textFieldTrainLimit.stringValue = [NSString stringWithFormat:@"Train Limit: %d", self.game.settings.trainLimit];
    NSArray *list = [self.game.saveGames allKeys];
    [self.popupLoadGames removeAllItems];
    list = [list sortedArrayUsingSelector:@selector(compare:)];
    [self.popupLoadGames addItemsWithTitles:list];
}

- (IBAction)actionAbsorbAnotherCompany:(NSButton *)sender {
    Company *comp = [self.game.companyTurnOrder firstObject];
    NSArray *absorbCandidates = [self.game companyCanAbsorb:comp];
    NSString *key = [[self.or_popupAbsorb selectedItem] title];
    NSUInteger index = [[self buildAbsorbItemsList:absorbCandidates] indexOfObject:key];
    Company *absorbedComp = absorbCandidates[index];
    [self printLog:[self.game company:comp absorbsCompany:absorbedComp]];
    [self refreshView];
}

- (IBAction)actionAbsorbThisCompany:(NSButton *)sender {
    [self printLog:[self.game advancePlayersDidPass:NO]];
    [self refreshView];
}

- (IBAction)actionLay2ndTrack:(NSButton *)sender {
    Company *comp = [self.game.companyTurnOrder firstObject];
    [comp layExtraTrack];
    [self refreshView];
}

- (IBAction)actionPlaceStationToken:(NSButton *)sender {
    Company *comp = [self.game.companyTurnOrder firstObject];
    int cost = [self.or_textfieldStationCost.stringValue intValue];
    if (cost <= comp.money) {
        [comp placeStationMarkerForCost:cost];
        [self refreshView];
    }
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
        NSString *key = [[self.or_popupTrain selectedItem] title];
        int cost = self.or_textfieldTrainCost.stringValue.intValue;
        [self printLog:[self.game company:comp BuysTrain:key AtCost:cost]];
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

- (IBAction)actionLoadSavedGame:(NSPopUpButton *)sender {
    NSString *key = [[sender selectedItem] title];
    NSString *path = self.game.saveGames[key];
    self.game = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    [self.companyTable loadNewGame:self.game];
    [self.playerRanking loadNewGame:self.game];
    [self refreshView];
}

- (IBAction)companyPayBackLoan:(NSButton *)sender {
    [self printLog:[self.game shareholderPaysBackLoan:[self.game.companyTurnOrder firstObject]]];
    [self refreshView];
}

- (IBAction)presidentSellStock:(NSPopUpButton *)sender {
    NSString *key = sender.titleOfSelectedItem;
    Company *currentComp = [self.game.companyTurnOrder firstObject];
    Player *president = (Player *) currentComp.president;
    Company *comp = [self.game getCompanyForSaleWithKey:key];
    if (comp) {
        [self printLog:[self.game player:president SellsShare:comp]];
    } else if ([key isEqualToString:@"Take loan for L.500"]) {
        [self printLog:[self.game shareholderTakesLoan:president]];
    }
    [self refreshView];
}

- (IBAction)playerPayBackLoan:(NSButton *)sender {
    [self printLog:[self.game shareholderPaysBackLoan:self.game.currentPlayer]];
    [self refreshView];
}

- (IBAction)actionAbsorbtionDone:(NSButton *)sender {
    NSLog(@"Todo: Implement me");
    assert(0);
}

- (IBAction)actionConvertCompanyToMajor:(NSButton *)sender {
    NSString *name = [[self.conversionButtons allKeysForObject:sender] firstObject];
    for (Company *comp in self.game.companies) {
        if ([comp.shortName isEqualToString:name]) {
            [comp convertToMajorInPhase:self.game.settings.phase];
            [self printLog:[NSString stringWithFormat:@"Converting %@ to major company", name]];
        }
    }
    [self refreshView];
}

- (IBAction)actionBureaucracyDone:(NSButton *)sender {
    [self printLog:[self.game advancePlayersDidPass:NO]];
    [self refreshView];
}

- (IBAction)actionTrainSelected:(NSPopUpButton *)sender {
    Company *comp = [self.game.companyTurnOrder firstObject];
    NSString *key = [[self.or_popupTrain selectedItem] title];
    Train *train = [self.game getTrainForPurchaseForCompany:comp WithText:key];
    int cost = comp.money;
    if (train.owner == nil || train.owner==self.game.bank) {
        cost = train.cost;
    }
    [self.or_textfieldTrainCost setStringValue:[NSString stringWithFormat:@"%d", cost]];
}

@end
