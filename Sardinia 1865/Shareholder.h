//
//  Shareholder.h
//  Sardinia 1865
//
//  Created by Jan Uerpmann on 10/12/13.
//  Copyright (c) 2013 Jan Uerpmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Certificate.h"

@protocol Shareholder <NSObject>

@property int money;
@property (strong, nonatomic) NSMutableArray *certificates; // of Certificate


@end
