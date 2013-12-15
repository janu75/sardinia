//
//  PlayerOverviewTableController.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 15/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

@interface PlayerOverviewTableController : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) Game* game;

- (id) initWithGame:(Game*)aGame;

@end
