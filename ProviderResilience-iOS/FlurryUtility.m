//
//  FlurryUtility.m
//  VAS002
//
//  Created by Hasan Edain on 1/26/11.
//  Copyright 2011 GDIT. All rights reserved.
//

#import "FlurryUtility.h"
#import "Flurry.h"
#import "ResearchUtility.h"

@implementation FlurryUtility

+ (void)report:(NSString *)activityString {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL useFlurry = [defaults boolForKey:@"DEFAULTS_USE_FLURRY"];
	if (useFlurry == YES) {
		[Flurry logEvent:activityString];
	}
    // Research Study
    BOOL useResearch = [defaults boolForKey:@"DEFAULTS_USE_RESEARCHSTUDY"];
    if (useResearch == YES) {
		[ResearchUtility logEvent:activityString];
	}
}

+ (void)report:(NSString *)activityString withDuration:(int)duration
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL useFlurry = [defaults boolForKey:@"DEFAULTS_USE_FLURRY"];
	if (useFlurry == YES) {
		[Flurry logEvent:activityString];
	}
    // Research Study
    BOOL useResearch = [defaults boolForKey:@"DEFAULTS_USE_RESEARCHSTUDY"];
    if (useResearch == YES) {
		[ResearchUtility logEvent:activityString withDuration:duration];
	}
}

+ (void)report:(NSString *)activityString withDuration:(int)duration withItem:(NSString *)item
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL useFlurry = [defaults boolForKey:@"DEFAULTS_USE_FLURRY"];
	if (useFlurry == YES) {
		[Flurry logEvent:activityString];
	}
    // Research Study
    BOOL useResearch = [defaults boolForKey:@"DEFAULTS_USE_RESEARCHSTUDY"];
    if (useResearch == YES) {
		[ResearchUtility logEvent:activityString withDuration:duration withItem:item];
	}
}

+ (void)report:(NSString *)activityString withItem:(NSString *)item
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL useFlurry = [defaults boolForKey:@"DEFAULTS_USE_FLURRY"];
	if (useFlurry == YES) {
		[Flurry logEvent:activityString];
	}
    // Research Study
    BOOL useResearch = [defaults boolForKey:@"DEFAULTS_USE_RESEARCHSTUDY"];
    if (useResearch == YES) {
		[ResearchUtility logEvent:activityString withItem:item];
	}
}

+ (void)report:(NSString *)activityString withData:(NSDictionary *)userData {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL useFlurry = [defaults boolForKey:@"DEFAULTS_USE_FLURRY"];
	if (useFlurry == YES) {
		[Flurry logEvent:activityString withParameters:userData];
	}
    // Research Study
    BOOL useResearch = [defaults boolForKey:@"DEFAULTS_USE_RESEARCHSTUDY"];
    if (useResearch == YES) {
		[ResearchUtility logEvent:activityString withData:userData];
	}
}

+ (void)startTimed:(NSString *)activityString {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL useFlurry = [defaults boolForKey:@"DEFAULTS_USE_FLURRY"];
	if (useFlurry == YES) {
		[Flurry logEvent:activityString timed:YES];
	}
}

+ (void)endTimed:(NSString *)activityString {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL useFlurry = [defaults boolForKey:@"DEFAULTS_USE_FLURRY"];
	if (useFlurry == YES) {
		[Flurry endTimedEvent:activityString withParameters:nil];
	}
}



@end
