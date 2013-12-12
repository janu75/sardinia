//
//  GameSettings.m
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import "GameSettings.h"

@implementation GameSettings

- (id) init {
    self = [super init];
    if (self) {
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath;
        plistPath = [[NSBundle mainBundle] pathForResource:@"1865-Settings" ofType:@"plist"];
//        plistPath = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
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

@end
