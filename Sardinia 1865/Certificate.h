//
//  Certificate.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Shareholder.h"

@interface Certificate : NSObject

@property int share;
@property NSString *type;
@property id owner;

- (id) initWithType:(NSString*)type;

- (void) convertToMajor;

@end
