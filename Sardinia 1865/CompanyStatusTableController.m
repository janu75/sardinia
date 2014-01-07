//
//  CompanyStatusTableController.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 16/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "CompanyStatusTableController.h"
#import "Company.h"
#import "Train.h"

@implementation CompanyStatusTableController

- (id) initWithGame:(Game *)aGame {
    self = [super init];
    if (self) {
        self.game = aGame;
    }
    return self;
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    NSInteger n = 0;
    for (Company* comp in self.game.companies) {
        if (comp.isFloating) {
            n++;
        }
    }
    return n;
}

- (NSView *) tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
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
    NSMutableArray *compName = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *shortName = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *president = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *money = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *trains = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *capacity = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *traffic = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *stations = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *markers = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *mComp = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *type = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *stockPrice = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *shares = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *income = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *dragon = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *loans  = [[NSMutableArray alloc] initWithCapacity:8];
    for (Company *comp in self.game.frozenTurnOrder) {
        [compName addObject:comp.name];
        [shortName addObject:comp.shortName];
        [president addObject:comp.president.name];
        [money addObject:[NSNumber numberWithInt:comp.money]];
        NSMutableString *train = [[NSMutableString alloc] init];
        for (Train* t in comp.trains) {
            [train appendFormat:@"%d-", [t techLevel]];
        }
        if ([train length] == 0) {
            train = [@"No Trains" mutableCopy];
        } else {
            [train deleteCharactersInRange:NSMakeRange([train length]-1, 1)];
        }
        [trains addObject:train];
        [capacity addObject:[NSString stringWithFormat:@"%d", comp.trainCapacity]];
        [traffic addObject:[NSString stringWithFormat:@"%d", comp.traffic]];
        [stations addObject:[NSString stringWithFormat:@"%d", comp.builtStations]];
        [markers addObject:[NSString stringWithFormat:@"%d", comp.numStationMarkers]];
        [mComp addObject:[NSString stringWithFormat:@"%lu", (unsigned long)[comp.maritimeCompanies count]]];
        if (comp.isMajor) {
            [type addObject:@"Major"];
        } else {
            [type addObject:@"Minor"];
        }
        [stockPrice addObject:[NSString stringWithFormat:@"%d", comp.stockPrice]];
        [shares addObject:[NSString stringWithFormat:@"%d", [comp getShareByOwner:comp]]];
        [income addObject:[NSString stringWithFormat:@"%d", comp.lastIncome]];
        if ([comp isDragonBuy]) {
            [dragon addObject:[NSString stringWithFormat:@"Buy (%@,%d)", comp.dragonRow, [comp rank]]];
        } else if ([comp isDragonSell]) {
            [dragon addObject:[NSString stringWithFormat:@"Sell (%@,%d)", comp.dragonRow, [comp rank]]];
        } else {
            [dragon addObject:[NSString stringWithFormat:@"Keep (%@,%d)", comp.dragonRow, [comp rank]]];
        }
        [loans addObject:[NSString stringWithFormat:@"%d", comp.numLoans]];
    }
    self.overviewTableData = @{@"Company"    : compName,
                               @"Short"      : shortName,
                               @"President"  : president,
                               @"Money"      : money,
                               @"Trains"     : trains,
                               @"Capacity"   : capacity,
                               @"Traffic"    : traffic,
                               @"Stations"   : stations,
                               @"Markers"    : markers,
                               @"MComp"      : mComp,
                               @"Type"       : type,
                               @"Stockprice" : stockPrice,
                               @"Shares"     : shares,
                               @"Income"     : income,
                               @"Dragon"     : dragon,
                               @"Loans"      : loans
                               };
    [self.statusTable reloadData];
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    [self.statusTable deselectAll:self];
    if ([self.game.round isEqualToString:@"Stock Round"]) {
        NSUInteger i = 0;
        for (Company* comp in self.game.frozenTurnOrder) {
            if (self.game.currentPlayer == comp.president) {
                [indexSet addIndex:i];
            }
            i++;
        }
        [self.statusTable selectRowIndexes:indexSet byExtendingSelection:NO];
    } else  if ([self.game.round isEqualToString:@"Operating Round"]) {
        [indexSet addIndex:[self.game.frozenTurnOrder indexOfObject:[self.game.companyTurnOrder firstObject]]];
        [self.statusTable selectRowIndexes:indexSet byExtendingSelection:NO];
    }
}

- (void) loadNewGame:(Game *)aGame {
    self.game = aGame;
    [self updateTableData];
}

@end
