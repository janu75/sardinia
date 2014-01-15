//
//  Sar_TileView.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 15/01/14.
//  Copyright (c) 2014 Jan Uerpmann. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Sar_TileView : NSView

@property (strong) NSString *color;

- (void) setColorByPhase:(int)phase;

@end
