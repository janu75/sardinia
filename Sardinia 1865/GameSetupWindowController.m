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

- (void) windowDidLoad {
}

- (void) useSettings:(id)mainController {
    myController = mainController;

}

- (void) loadSounds {
    if (!self.soundSelect4) return;
    self.soundSelectors = @[self.soundSelect1,
                            self.soundSelect2,
                            self.SoundSelect3,
                            self.soundSelect4];
    // Get system sounds
    NSMutableArray *returnArr = [[NSMutableArray alloc] init];
    NSEnumerator *librarySources = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSAllDomainsMask, YES) objectEnumerator];
    NSString *sourcePath;
    while (sourcePath = [librarySources nextObject]) {
        NSEnumerator *soundSource = [[NSFileManager defaultManager] enumeratorAtPath:[sourcePath stringByAppendingPathComponent:@"Sounds"]];
        NSString *soundFile;
        while (soundFile = [soundSource nextObject]) {
            if ([NSSound soundNamed:[soundFile stringByDeletingPathExtension]]) {
                [returnArr addObject:[soundFile stringByDeletingPathExtension]];
            }
        }
    }
    self.systemSounds = [NSArray arrayWithArray:returnArr];
    NSInteger select = 0;
    for (NSPopUpButton *pop in self.soundSelectors) {
        [pop removeAllItems];
        [pop addItemsWithTitles:self.systemSounds];
        [pop selectItemAtIndex:select++];
    }    
}

- (IBAction)playerNumButton:(NSMatrix *)sender {
    [self loadSounds];
    if (sender.selectedRow == 2) {
        [self.shortGameButton setEnabled:NO];
        [self.shortGameButton setState:NSOffState];
        [self.playerCName setEnabled:YES];
        [self.playerDName setEnabled:YES];
        [self.SoundSelect3 setEnabled:YES];
        [self.soundSelect4 setEnabled:YES];
    } else if (sender.selectedRow == 1) {
        [self.shortGameButton setEnabled:YES];
        [self.playerCName setEnabled:YES];
        [self.playerDName setEnabled:NO];
        [self.SoundSelect3 setEnabled:YES];
        [self.soundSelect4 setEnabled:NO];
    } else {
        [self.shortGameButton setEnabled:YES];
        [self.playerCName setEnabled:NO];
        [self.playerDName setEnabled:NO];
        [self.SoundSelect3 setEnabled:NO];
        [self.soundSelect4 setEnabled:NO];
    }
}

- (IBAction)doneButtonPressed:(NSButton *)sender {
    [self loadSounds];
    NSArray *players = @[self.playerAName.stringValue, self.playerBName.stringValue,
                         self.playerCName.stringValue, self.playerDName.stringValue];
    NSInteger numPlayers = self.numPlayers.selectedRow + 2;
    BOOL isShortGame = (self.shortGameButton.state==NSOnState)?YES:NO;
    if (numPlayers == 4) {
        isShortGame = NO;
    }
    NSMutableArray *playerNames = [[NSMutableArray alloc] initWithCapacity:4];
    NSMutableArray *sounds = [[NSMutableArray alloc] initWithCapacity:4];
    NSInteger i = 0;
    for (NSString* name in players) {
        if (i<numPlayers) [playerNames addObject:name];
        i++;
    }
    for (NSInteger i=0; i<numPlayers; i++) {
        NSPopUpButton *pop = self.soundSelectors[i];
        NSInteger index = [pop indexOfSelectedItem];
        [sounds addObject:self.systemSounds[index]];
    }
    NSLog(@"Players: %@\nShort game:%d", playerNames, isShortGame);
    [myController setPlayers:playerNames AndGameMode:isShortGame AndSounds:sounds];
}

- (IBAction)loadGame:(NSButton *)sender {
    NSURL *myUrl = [NSURL URLWithString:@"Documents/1865 Sardinia/"];
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setDirectoryURL:myUrl];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setCanCreateDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    [panel setResolvesAliases:YES];
    
    NSInteger clicked = [panel runModal];
    if (clicked == NSFileHandlingPanelOKButton) {
        NSURL *dir = [[panel URLs] firstObject];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *files = [fm contentsOfDirectoryAtURL:dir includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
//        for (NSString *file in files) {
//            NSLog(@"Found file '%@'", file);
//        }
        [myController loadSavedGameWithFile:[files lastObject]];
    }
}

- (IBAction)playSound:(NSPopUpButton *)sender {
    NSInteger index = [sender indexOfSelectedItem];
    NSString *sound = self.systemSounds[index];
    [[NSSound soundNamed:sound] play];
}

@end
