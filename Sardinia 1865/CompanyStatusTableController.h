//
//  CompanyStatusTableController.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 16/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

@interface CompanyStatusTableController : NSObject<NSTableViewDataSource,NSTableViewDelegate>

@property (strong) Game* game;
@property (strong) NSDictionary *overviewTableData;
@property (weak) IBOutlet NSTableView *statusTable;

- (id) initWithGame:(Game*)aGame;

- (void) updateTableData;

@end
