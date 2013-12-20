//
//  MaritimeCompany.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaritimeCompany : NSObject<NSCoding>

@property BOOL isPrivate;
@property BOOL isConnected;
@property int  identifier;

- (id) initWithIdentifier:(int)ident;

@end
