//
//  Company.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shareholder.h"
#import "Train.h"
#import "GameSettings.h"
#import "Certificate.h"

@interface Company : Shareholder<NSCoding>

@property BOOL isOperating;
@property BOOL isFloating;
@property BOOL isMajor;

// Per turn flags, need to be reset at beginning of new turn
@property BOOL didOperateThisTurn;
@property BOOL canLay2ndTrack;
@property BOOL canBuildStation;
@property BOOL boughtBrandNewTrain;
@property BOOL paidDividend;
@property int presidentSoldShares;

@property int numStationMarkers;
@property int builtStations;
@property int traffic;
@property int trainCapacity;
@property int stockPrice;
@property int money;
@property int lastIncome;
@property (strong) NSNumber *dragonRow;

@property (strong) NSString *shortName;
@property (strong) NSMutableArray *trains; // of Train
@property (strong) NSMutableArray *maritimeCompanies; // of MaritimeCompany
@property (strong) NSMutableArray *certificates;// of Certificate
@property (strong) Shareholder* president;
@property (strong) GameSettings *settings;

- (id) initWithName:(NSString *)aName IsMajor:(BOOL)isMajor AndSettings:(GameSettings*)settings;

- (int) rank;

- (void) setInitialStockPrice:(int)price;

- (void) decreaseStockPrice;

- (void) increaseStockPrice;

- (void) buyTrain:(Train*)aTrain;

- (void) buyTrain:(Train*)aTrain ForMoney:(int)price;

- (void) sellTrain:(Train*)aTrain;

- (void) sellTrain:(Train*)aTrain ForMoney:(int)price;

- (void) layExtraTrack;

- (void) trafficUpgrade:(int)value;

- (void) operateMines;

- (void) placeStationMarkerForCost:(int)cost;

- (void) operateTrainsAndPayDividend:(BOOL)payout;

- (void) absorbCompany:(Company*) aCompany;

- (void) sellCertificate:(Certificate*)aCertificate To:(Shareholder*)newOwner;

- (void) equipCertificate:(Certificate*)aCertificate;

- (void) convertToMajorInPhase:(int)phase;

- (int) getShareByOwner:(Shareholder*)anOwner;

- (int) getCertificatesByOwner:(Shareholder*)anOwner;

- (Shareholder*) updatePresident;

- (BOOL) isDragonBuy;

- (BOOL) isDragonSell;

- (Certificate*) certificateFromOwner:(Shareholder*)anOwner;

- (void) setDragonRowWithPhase:(int)phase;

- (void) updateDragonRowInPhase:(int)phase;

- (void) cleanFlagsForOperatingRound;

- (int) getCompanyCost;

- (int) getShareMarketPrice;

@end
