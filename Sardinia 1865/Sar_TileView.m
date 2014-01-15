//
//  Sar_TileView.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 15/01/14.
//  Copyright (c) 2014 Jan Uerpmann. All rights reserved.
//

#import "Sar_TileView.h"

@implementation Sar_TileView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.color = @"Lavender";
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];

//    NSArray *cLists = [NSColorList availableColorLists];
//    for (NSColorList *cList in cLists) {
//        NSLog(@"List '%@':", cList.name);
//        for (NSString *color in [cList allKeys]) {
//            NSLog(@"  %@", color);
//        }
//    }
    NSColor *color = [[NSColorList colorListNamed:@"Crayons"] colorWithKey:self.color];
    [color setFill];

    NSRect frame = self.frame;
    
    NSBezierPath *hex = [NSBezierPath bezierPath];
    [hex moveToPoint:NSMakePoint(frame.size.width * 0.5, frame.size.height * 0.0)];
    [hex lineToPoint:NSMakePoint(frame.size.width * 1.0, frame.size.height * 0.27)];
    [hex lineToPoint:NSMakePoint(frame.size.width * 1.0, frame.size.height * 0.73)];
    [hex lineToPoint:NSMakePoint(frame.size.width * 0.5, frame.size.height * 1.0)];
    [hex lineToPoint:NSMakePoint(frame.size.width * 0.0, frame.size.height * 0.73)];
    [hex lineToPoint:NSMakePoint(frame.size.width * 0.0, frame.size.height * 0.27)];
    [hex lineToPoint:NSMakePoint(frame.size.width * 0.5, frame.size.height * 0.0)];
    [hex fill];
    
    [context restoreGraphicsState];
}

- (void) setColorByPhase:(int)phase {
    if (phase > 6) {
        self.color = @"Nickel";
    } else if (phase > 4) {
        self.color = @"Mocha";
    } else if (phase > 2) {
        self.color = @"Moss";
    } else {
        self.color = @"Banana";
    }
    [self setNeedsDisplay:YES];
}

@end
