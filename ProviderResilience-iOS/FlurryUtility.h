//
//  FlurryUtility.h
//  VAS002
//
//  Created by Hasan Edain on 1/26/11.
//  Copyright 2011 GDIT. All rights reserved.
//

@interface FlurryUtility : NSObject {

}

+ (void)report:(NSString *)activityString;
+ (void)report:(NSString *)activityString withData:(NSDictionary *)userData;
+ (void)startTimed:(NSString *)activityString;
+ (void)endTimed:(NSString *)activityString;
+ (void)report:(NSString *)activityString withDuration:(int)duration withItem:(NSString *)item;
+ (void)report:(NSString *)activityString withDuration:(int)duration;
+ (void)report:(NSString *)activityString withItem:(NSString *)item;


@end
