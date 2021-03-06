//
//  PlayerRankingController.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 29/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

@interface PlayerRankingController : NSObject<NSTableViewDataSource,NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *rankTableView;

@property (weak) Game *game;
@property (strong) NSDictionary* tableData;

- (id) initWithGame:(Game*)aGame;

- (void) updateTableData;

- (void) loadNewGame:(Game*)aGame;


@end
