//
//  ResearchUtility.m
//  VAS002
//
//  Created by Melvin Manzano on 11/2/12.
//  Copyright (c) 2012 GDIT. All rights reserved.
//

#import "ResearchUtility.h"

@implementation ResearchUtility

+ (void)logEvent:(int)duration inSection:(NSString *)section withItem:(NSString *)item withActivity:(NSString *)activity withValue:(NSString *)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //If enrolled then log event
    BOOL useResearch = [defaults boolForKey:@"DEFAULTS_USE_RESEARCHSTUDY"];
    if (useResearch)
    {
        // Research Study
        NSMutableString * txtFile = [NSMutableString string];
        NSDate *today = [NSDate date];
        NSString *participant = [defaults objectForKey:@"DEFAULTS_PARTICIPANTNUMBER"];
        NSString* ver = [[UIDevice currentDevice] systemVersion];
        NSString *device = [[UIDevice currentDevice] model];
        
        //Cleanse the pass in data
        section = [self cleanseString:section];
        item = [self cleanseString:item];
        activity = [self cleanseString:activity];
        if([value isEqual: @"null"] && duration && duration > 0)
        {
            value = [self formatDuration:duration];
        }
        else
        {
            value = [self cleanseString:value];
        }

        
        // File Name
        NSString *fileName = [NSString stringWithFormat:@"Provider_Resilience_Participant_%@.csv",participant];
        
        // Change Hard Coded info for app version number when updating
        NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        NSString * logLine = [NSString stringWithFormat:@"%@,%@,%@,iOS,%@,PR,%@,%@,%@,%@,%@", participant, today, device, ver, appVersion, section, item, activity, value];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        NSString *finalPath = [NSString stringWithFormat:@"%@/%@",documentsDir, fileName];
        
        
        NSString* fileContents = [NSString stringWithContentsOfFile:finalPath
                                                           encoding:NSUTF8StringEncoding error:nil];
        [txtFile appendFormat:@"%@\n", fileContents];
        [txtFile appendFormat:@"%@ ", logLine];
        NSLog(@"ResearchUtility: %@", logLine);
        
        [txtFile writeToFile:finalPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

+(NSString*)formatDuration:(int)duration
{
    if(duration && duration > 0)
    {
        return [NSString stringWithFormat:@"%i", duration];
    }
    else
        return @"0";
}

+(NSString*)cleanseString:(NSString*)item
{
    return [[[item stringByReplacingOccurrencesOfString:@"," withString:@" "]
             stringByReplacingOccurrencesOfString:@"\n" withString:@" "]
            stringByReplacingOccurrencesOfString:@"\t" withString:@""];
}

@end
