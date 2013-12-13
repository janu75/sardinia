//
//  GameSetupWindowController.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 13/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GameSettings.h"

@interface GameSetupWindowController : NSWindowController

@property (weak) IBOutlet NSMatrix *numPlayers;

@property (weak) IBOutlet NSTextField *playerAName;
@property (weak) IBOutlet NSTextField *playerBName;
@property (weak) IBOutlet NSTextField *playerCName;
@property (weak) IBOutlet NSTextField *playerDName;
@property (weak) IBOutlet NSButton *shortGameButton;

- (void) useSettings:(id)mainController;


@end
