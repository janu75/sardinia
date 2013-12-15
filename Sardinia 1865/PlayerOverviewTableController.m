//
//  PlayerOverviewTableController.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 15/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "PlayerOverviewTableController.h"

@implementation PlayerOverviewTableController : NSObject 

- (id) initWithGame:(Game *)aGame {
    self = [super self];
    if (self) {
        self.game = aGame;
    }
    return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return (NSInteger) [self.game.player count] + 2;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    // get an existing cell with the MyView identifier if it exists
    NSTextField *result = [tableView makeViewWithIdentifier:@"PlayerOverview" owner:self];
    
    // There is no existing cell to reuse so we will create a new one
    if (result == nil) {
        
        // create the new NSTextField with a frame of the {0,0} with the width of the table
        // note that the height of the frame is not really relevant, the row-height will modify the height
        // the new text field is then returned as an autoreleased object
        result = [[[NSTextField alloc] initWithFrame:...] autorelease];
        
        // the identifier of the NSTextField instance is set to MyView. This
        // allows it to be re-used
        result.identifier = @"PlayerOverview";
    }
    
    // result is now guaranteed to be valid, either as a re-used cell
    // or as a new cell, so set the stringValue of the cell to the
    // nameArray value at row
    result.stringValue = [self.nameArray objectAtIndex:row];
    
    // return the result.
    return result;
    
}

@end
