//
//  ResearchUtility.h
//  VAS002
//
//  Created by Melvin Manzano on 11/2/12.
//  Copyright (c) 2012 GDIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResearchUtility : NSObject

+ (void)logEvent:(int)duration inSection:(NSString *)section withItem:(NSString *)item withActivity:(NSString *)activity withValue:(NSString *)value;

@end
