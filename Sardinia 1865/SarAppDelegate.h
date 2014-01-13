//
//  SarAppDelegate.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Game.h"
#import "CompanyStatusTableController.h"
#import "PlayerRankingController.h"

@interface SarAppDelegate : NSObject <NSApplicationDelegate,NSTableViewDataSource,NSTableViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTabView *roundView;
@property (unsafe_unretained) IBOutlet NSTextView *textLog;
@property (weak) IBOutlet NSScrollView *textLogScrollView;
@property (strong) NSArray* ipoBuyButton;
@property (strong) NSArray* bankBuyButton;
@property (strong) NSArray* dragonBuyButton;
@property (strong) NSArray* sellButton;
@property (strong) NSArray* stockCompanyLabel;
@property (strong) NSArray* companyTypeLabel;
@property (strong) NSDictionary* conversionButtons;
@property (strong) Game* game;
@property (weak) IBOutlet NSTextField *stockRoundPlayerLabel;
@property (weak) IBOutlet NSTextField *stockRoundMoneyLabel;
@property (weak) IBOutlet NSTabView *actionTabView;
@property (weak) IBOutlet NSPopUpButton *stockStartingPrice;

@property (weak) IBOutlet NSTextField *stockStartingPriceLabel;
@property (weak) IBOutlet NSTextField *textFieldOperatingRound;
@property (weak) IBOutlet NSTextField *textFieldTrainPhase;
@property (weak) IBOutlet NSTextField *textFieldTurnMarker;
@property (weak) IBOutlet NSTextField *textFieldTrainLimit;
@property (weak) IBOutlet NSPopUpButton *popupLoadGames;

@property (strong) NSTabViewItem *tabViewItemStockRound;
@property (strong) NSTabViewItem *tabViewItemOperatingRound;
@property (strong) NSTabViewItem *tabViewItemBureaucracy;

// Stock market buttons
@property (weak) IBOutlet NSButton *buttonIPO1;
@property (weak) IBOutlet NSButton *buttonIPO2;
@property (weak) IBOutlet NSButton *buttonIPO3;
@property (weak) IBOutlet NSButton *buttonIPO4;
@property (weak) IBOutlet NSButton *buttonIPO5;
@property (weak) IBOutlet NSButton *buttonIPO6;
@property (weak) IBOutlet NSButton *buttonIPO7;
@property (weak) IBOutlet NSButton *buttonIPO8;

@property (weak) IBOutlet NSButton *buttonBank1;
@property (weak) IBOutlet NSButton *buttonBank2;
@property (weak) IBOutlet NSButton *buttonBank3;
@property (weak) IBOutlet NSButton *buttonBank4;
@property (weak) IBOutlet NSButton *buttonBank5;
@property (weak) IBOutlet NSButton *buttonBank6;
@property (weak) IBOutlet NSButton *buttonBank7;
@property (weak) IBOutlet NSButton *buttonBank8;

@property (weak) IBOutlet NSButton *buttonSell1;
@property (weak) IBOutlet NSButton *buttonSell2;
@property (weak) IBOutlet NSButton *buttonSell3;
@property (weak) IBOutlet NSButton *buttonSell4;
@property (weak) IBOutlet NSButton *buttonSell5;
@property (weak) IBOutlet NSButton *buttonSell6;
@property (weak) IBOutlet NSButton *buttonSell7;
@property (weak) IBOutlet NSButton *buttonSell8;

@property (weak) IBOutlet NSButton *buttonDragon1;
@property (weak) IBOutlet NSButton *buttonDragon2;
@property (weak) IBOutlet NSButton *buttonDragon3;
@property (weak) IBOutlet NSButton *buttonDragon4;
@property (weak) IBOutlet NSButton *buttonDragon5;
@property (weak) IBOutlet NSButton *buttonDragon6;
@property (weak) IBOutlet NSButton *buttonDragon7;
@property (weak) IBOutlet NSButton *buttonDragon8;

@property (weak) IBOutlet NSTextField *labelCompType1;
@property (weak) IBOutlet NSTextField *labelCompType2;
@property (weak) IBOutlet NSTextField *labelCompType3;
@property (weak) IBOutlet NSTextField *labelCompType4;
@property (weak) IBOutlet NSTextField *labelCompType5;
@property (weak) IBOutlet NSTextField *labelCompType6;
@property (weak) IBOutlet NSTextField *labelCompType7;
@property (weak) IBOutlet NSTextField *labelCompType8;

@property (weak) IBOutlet NSButton *buttonPlayerPayBackLoan;

// Stock market labels
@property (weak) IBOutlet NSTextField *stockLabelComp1;
@property (weak) IBOutlet NSTextField *stockLabelComp2;
@property (weak) IBOutlet NSTextField *stockLabelComp3;
@property (weak) IBOutlet NSTextField *stockLabelComp4;
@property (weak) IBOutlet NSTextField *stockLabelComp5;
@property (weak) IBOutlet NSTextField *stockLabelComp6;
@property (weak) IBOutlet NSTextField *stockLabelComp7;
@property (weak) IBOutlet NSTextField *stockLabelComp8;

@property (weak) IBOutlet NSScrollView *companyScrollView;
@property (weak) IBOutlet NSTableView *companyTableView;

@property (strong) NSDictionary *overviewTableData;
@property (strong) NSArray *playerNames;
@property BOOL isShortGame;
- (void) setPlayers:(NSArray*)players AndGameMode:(BOOL)isShort;

@property (weak) IBOutlet CompanyStatusTableController *companyTable;
@property (weak) IBOutlet PlayerRankingController *playerRanking;

// Operating Round
@property (weak) IBOutlet NSButton *or_buttonAbsorbOther;
@property (weak) IBOutlet NSPopUpButton *or_popupAbsorb;
@property (weak) IBOutlet NSTextField *or_textAbsorbOr;
@property (weak) IBOutlet NSButton *or_buttonAbsorbThis;
@property (weak) IBOutlet NSButton *or_buttonLay2ndTrack;
@property (weak) IBOutlet NSButton *or_buttonPlaceStation;
@property (weak) IBOutlet NSTextField *or_textfieldStationCost;
@property (weak) IBOutlet NSButton *or_buttonAddTraffic;
@property (weak) IBOutlet NSTextField *or_textfieldTraffic;
@property (weak) IBOutlet NSButton *or_buttonOperateTrains;
@property (weak) IBOutlet NSButton *or_buttonPayDividend;
@property (weak) IBOutlet NSButton *or_buttonBuyTrain;
@property (weak) IBOutlet NSPopUpButton *or_popupTrain;
@property (weak) IBOutlet NSTextField *or_textfieldTrainCost;
@property (weak) IBOutlet NSTextField *or_CompanyName;
@property (weak) IBOutlet NSTextField *or_presidentName;
@property (weak) IBOutlet NSButton *or_buttonHandOverMaritime;
@property (weak) IBOutlet NSTextField *or_textfieldOperateText;
@property (weak) IBOutlet NSButton *or_buttonConnectMaritime;
@property (weak) IBOutlet NSButton *or_buttonOperateDone;
@property (weak) IBOutlet NSPopUpButton *or_popupPresidentSellCompanies;
@property (weak) IBOutlet NSButton *or_buttonCompanyPayBackLoan;
@property (weak) IBOutlet NSTextField *or_labelAbsorbCities;
@property (weak) IBOutlet NSTextField *or_textfieldAbsorbCities;
@property (weak) IBOutlet NSTextField *or_labelAbsorbTokens;
@property (weak) IBOutlet NSTextField *or_textfieldAbsorbTokens;
@property (weak) IBOutlet NSTextField *or_labelNewTrainInfo;
@property (weak) IBOutlet NSButton *or_buttonAbsorbDone;

// Bureaucracy
@property (weak) IBOutlet NSButton *bu_buttonConvertSFS;
@property (weak) IBOutlet NSButton *bu_buttonConvertFCS;
@property (weak) IBOutlet NSButton *bu_buttonConvertRCSF;
@property (weak) IBOutlet NSButton *bu_buttonConvertCFC;
@property (weak) IBOutlet NSButton *bu_buttonConvertFA;
@property (weak) IBOutlet NSButton *bu_buttonConvertFMS;
@property (weak) IBOutlet NSButton *bu_buttonConvertSFSS;
@property (weak) IBOutlet NSButton *bu_buttonConvertCFD;
@property (weak) IBOutlet NSButton *bu_buttonDone;
@property (weak) IBOutlet NSTextField *bu_labelDownGradeMines;

@property BOOL absorptionOngoing;
@property (strong) NSString* absorbee;
@property (strong) NSString* absorber;

@property (strong) NSFont* tableFont;

- (void) loadSavedGameWithFile:(NSString*)file;

@end
