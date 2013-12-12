//
//  GameSettings.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "GameSettings.h"

@implementation GameSettings

// Tested
- (id) init {
    self = [super init];
    if (self) {
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath;
        plistPath = [[NSBundle mainBundle] pathForResource:@"1865-settings" ofType:@"plist"];
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        self.pref = (NSDictionary*) [NSPropertyListSerialization propertyListFromData:plistXML
                                                                     mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                               format:&format
                                                                     errorDescription:&errorDesc];
        if (!self.pref) {
            NSLog(@"Error reading plist: %@, format: %ld", errorDesc, format);
        }
    }
    return self;
}

- (NSString*) companyLongName:(NSString *)shortName {
	NSDictionary *names = [self.pref objectForKey:@"Company Names"];
    return [names objectForKey:shortName];
}

- (NSNumber*) increasedStockPrice:(NSNumber *)current {
    NSArray *table = [self.pref objectForKey:@"Stock Price Table"];
    NSUInteger index = [table indexOfObject:current];
    if (index+1 < [table count]) {
        index++;
    }
    return [table objectAtIndex:index];
}

- (NSNumber*) decreasedStockPrice:(NSNumber *)current {
    NSArray *table = [self.pref objectForKey:@"Stock Price Table"];
    NSInteger index = [table indexOfObject:current];
    if (index > 0) {
        index--;
    }
    return [table objectAtIndex:index];
}

@end
