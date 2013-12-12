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

@interface Company : NSObject <Shareholder>

@property BOOL isOperating;
@property BOOL isFloating;
@property BOOL isMajor;

@property int numStationMarkers;
@property int builtStations;
@property int traffic;
@property int trainCapacity;
@property int stockPrice;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *shortName;
@property (strong, nonatomic) NSMutableArray *trains; // of Train
@property (strong, nonatomic) NSMutableArray *maritimeCompanies; // of MaritimeCompany

- (id) initWithName:(NSString *)aName IsMajor:(BOOL)isMajor;

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

- (void) sellCertificate:(Certificate*)aCertificate;

- (void) equipCertificate:(Certificate*)aCertificate;

- (void) convertToMajorInPhase:(int)phase;

@end
