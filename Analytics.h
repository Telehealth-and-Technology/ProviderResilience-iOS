//
//  Analytics.h
//  T2TB
//
//  Created by robbiev on 11/3/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Flurry.h"


@interface Analytics : NSObject {

}

+ (void)init:(NSString *)apiKey isEnabled:(BOOL)enabled;
+ (void)setEnabled:(BOOL)enabled;

+ (void)logEvent:(NSString *)eventName;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;
+ (void)logError:(NSString *)errorID message:(NSString *)message exception:(NSException *)exception;
+ (void)logError:(NSString *)errorID message:(NSString *)message error:(NSError *)error;

+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed;
+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters timed:(BOOL)timed;
+ (void)endTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters;

+ (void)countPageViews:(id)target;
+ (void)countPageView;
+ (void)logEvent:(int)duration inSection:(NSString *)section withItem:(NSString *)item withActivity:(NSString *)activity withValue:(NSString *)value;


@end
