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
        
        //Format duration
        NSString* Duration = [self formatDuration:duration];
        
        //Cleanse the pass in data
        section = [self cleanseString:section];
        item = [self cleanseString:item];
        activity = [self cleanseString:activity];
        value = [self cleanseString:value];
        
        // File Name
        NSString *fileName = [NSString stringWithFormat:@"ProviderResilience_Participant_%@.csv",participant];
        
        // Device
        NSString *device = @"iPhone/iPod";
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            device = @"iPad";
        }
        
        //participant = Participant
        //today = Timestamp
        //device = Device
        //(manual entry) = OS
        //ver = OS Version
        //(manual entry) = App
        //(manual entry) = App Version
        //duration = Duration (sec)
        //section = Section
        //item = Item
        //activityString = Activity
        //value = Value
        
        // Change Hard Coded info for app version number when updating
        NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        NSString * logLine = [NSString stringWithFormat:@"%@,%@,%@,iOS,%@,PR,%@,%@,%@,%@,%@,%@", participant, today, device, ver, appVersion, Duration, section, item, activity, value];
        
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

+(NSString*)formatDuration:(long)duration
{
    if(duration && duration > 0)
    {
        //Get minutes and seconds
        int minutes = duration / 60;
        int seconds = duration % 60;
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    else
        return @"null";
}

+(NSString*)cleanseString:(NSString*)item
{
    return [[[item stringByReplacingOccurrencesOfString:@"," withString:@" "]
             stringByReplacingOccurrencesOfString:@"\n" withString:@""]
            stringByReplacingOccurrencesOfString:@"\t" withString:@""];
}

@end
