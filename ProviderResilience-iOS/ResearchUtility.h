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
+ (void)logEvent:(NSString *)activityString;
+ (void)logEvent:(NSString *)activityString withData:(NSDictionary *)userData;
+ (void)logEvent:(NSString *)activityString withDuration:(int)duration;
+ (void)logEvent:(NSString *)activityString withDuration:(int)duration withItem:(NSString *)item;
+ (void)logEvent:(NSString *)activityString withItem:(NSString *)item;

@end
