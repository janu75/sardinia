//
//  GameSetupWindowController.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 13/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "GameSetupWindowController.h"
#import "SarAppDelegate.h"

@implementation GameSetupWindowController

SarAppDelegate *myController;

- (void) useSettings:(id)mainController {
    myController = mainController;
}

- (IBAction)playerNumButton:(NSMatrix *)sender {
    if (sender.selectedRow == 2) {
        [self.shortGameButton setEnabled:NO];
    } else {
        [self.shortGameButton setEnabled:YES];
    }
}

- (IBAction)doneButtonPressed:(NSButton *)sender {
    NSArray *players = @[self.playerAName.stringValue, self.playerBName.stringValue,
                         self.playerCName.stringValue, self.playerDName.stringValue];
    NSInteger numPlayers = self.numPlayers.selectedRow + 2;
    BOOL isShortGame = (self.shortGameButton.state==NSOnState)?YES:NO;
    NSMutableArray *playerNames = [[NSMutableArray alloc] initWithCapacity:4];
    NSInteger i = 0;
    for (NSString* name in players) {
        if (i<numPlayers) [playerNames addObject:name];
        i++;
    }
    NSLog(@"Players: %@\nShort game:%d", playerNames, isShortGame);
    [myController setPlayers:playerNames AndGameMode:isShortGame];
}


@end
