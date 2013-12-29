//
//  PlayerRankingController.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 29/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "PlayerRankingController.h"

@implementation PlayerRankingController

- (id) initWithGame:(Game *)aGame {
    self = [super init];
    if (self) {
        self.game = aGame;
    }
    return self;
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.game.player count] + 1;
}

- (NSView*) tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = [tableColumn identifier];
    NSArray *rowData = self.tableData[identifier];

    if (rowData && [rowData count] > row) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        cellView.textField.stringValue = rowData[row];
        return cellView;
    } else {
        NSTextField *cellView = [[NSTextField alloc] initWithFrame:tableView.frame];
        cellView.stringValue = [NSString stringWithFormat:@"??%@-%ld??", identifier, (long) row];
        return cellView;
    }
    return nil;
}

- (void) updateTableData {
    NSMutableArray *name         = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *cash         = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *certificates = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *shares       = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *loans        = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *wealth       = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *shareholders = [[NSMutableArray alloc] initWithCapacity:5];
    [shareholders addObject:self.game.dragon];
    [shareholders addObjectsFromArray:self.game.player];
    NSMutableDictionary *wealthByShareholder = [[NSMutableDictionary alloc] initWithCapacity:5];
    for (Shareholder *guy in shareholders) {
        int wealth = guy.money - guy.numLoans*500;
        for (Company *comp in self.game.companies) {
            if (comp.isMajor) {
                wealth += [comp getShareByOwner:guy] * (comp.stockPrice - comp.numLoans*50) / 10;
            } else {
                wealth += [comp getShareByOwner:guy] * (comp.stockPrice - comp.numLoans*50) / 20;
            }
        }
        wealthByShareholder[guy.name] = [NSNumber numberWithInt:wealth];
    }
    NSArray *order = [shareholders sortedArrayUsingComparator:^(id obj1, id obj2) {
        Shareholder *sh1 = (Shareholder*) obj1;
        Shareholder *sh2 = (Shareholder*) obj2;
        if (wealthByShareholder[sh1.name] > wealthByShareholder[sh2.name]) {
            return (NSComparisonResult) NSOrderedAscending;
        }
        if (wealthByShareholder[sh1.name] < wealthByShareholder[sh2.name]) {
            return (NSComparisonResult) NSOrderedDescending;
        }
        return (NSComparisonResult) NSOrderedSame;
    }];
    for (Shareholder *guy in order) {
        [name addObject:guy.name];
        [cash addObject:[NSNumber numberWithInt:guy.money]];
        [loans addObject:[NSNumber numberWithInt:guy.numLoans]];
        [wealth addObject:wealthByShareholder[guy.name]];
        int certs = 0;
        int shrs = 0;
        for (Company *comp in self.game.companies) {
            certs += [comp getCertificatesByOwner:guy];
            shrs  += [comp getShareByOwner:guy];
        }
        [certificates addObject:[NSNumber numberWithInt:certs]];
        [shares addObject:[NSNumber numberWithInt:shrs]];
    }
    self.tableData = @{@"Name"         : name,
                       @"Cash"         : cash,
                       @"Certificates" : certificates,
                       @"Shares"       : shares,
                       @"Loans"        : loans,
                       @"Wealth"       : wealth};
    [self.rankTableView reloadData];
}

- (void) loadNewGame:(Game *)aGame {
    self.game = aGame;
    [self updateTableData];
}

@end
