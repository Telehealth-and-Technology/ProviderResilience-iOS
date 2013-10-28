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
    
    
    // Research Study
    NSMutableString * txtFile = [NSMutableString string];
    NSDate *today = [NSDate date];
    NSString *participant = [defaults objectForKey:@"DEFAULTS_PARTICIPANTNUMBER"];
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    
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
    NSString *appVersion = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    NSString * logLine = [NSString stringWithFormat:@"%@,%@,%@,iOS,%f,PR,%@,%i,%@,%@,%@,%@", participant, today, device, ver, appVersion, duration, section, item, activity, value];
    
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


+ (void)logEvent:(NSString *)activityString
{
    // Add to text log
    
    // Research Study
    NSMutableString * txtFile = [NSMutableString string];
    NSDate *today = [NSDate date];
    NSString *fileName = @"/study.csv";
    NSString * logLine = [NSString stringWithFormat:@"%@,%@,,,", today, activityString];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *finalPath = [NSString stringWithFormat:@"%@%@",documentsDir, fileName];
    
    
    NSString* fileContents = [NSString stringWithContentsOfFile:finalPath
                                                       encoding:NSUTF8StringEncoding error:nil];
    [txtFile appendFormat:@"%@\n", fileContents];
    [txtFile appendFormat:@"%@\n", logLine];
    NSLog(@"ResearchUtility: %@", logLine);

    [txtFile writeToFile:finalPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (void)logEvent:(NSString *)activityString withData:(NSDictionary *)userData
{
    // Research Study
    NSMutableString * txtFile = [NSMutableString string];
    NSDate *today = [NSDate date];
    NSString *fileName = @"/study.csv";
    NSString * logLine = [NSString stringWithFormat:@"%@,%@,,,[%@]", today, activityString, userData];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *finalPath = [NSString stringWithFormat:@"%@%@",documentsDir, fileName];
    
    
    NSString* fileContents = [NSString stringWithContentsOfFile:finalPath
                                                       encoding:NSUTF8StringEncoding error:nil];
    [txtFile appendFormat:@"%@\n", fileContents];
    [txtFile appendFormat:@"%@\n", logLine];
    NSLog(@"ResearchUtility: %@", logLine);
    
    [txtFile writeToFile:finalPath atomically:YES encoding:NSUTF8StringEncoding error:nil];

}

+ (void)logEvent:(NSString *)activityString withDuration:(int)duration
{
    // Research Study
    NSMutableString * txtFile = [NSMutableString string];
    NSDate *today = [NSDate date];
    NSString *fileName = @"/study.csv";
    NSString * logLine = [NSString stringWithFormat:@"%@,%@,%i,,", today, activityString, duration];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *finalPath = [NSString stringWithFormat:@"%@%@",documentsDir, fileName];
    
    
    NSString* fileContents = [NSString stringWithContentsOfFile:finalPath
                                                       encoding:NSUTF8StringEncoding error:nil];
    [txtFile appendFormat:@"%@\n", fileContents];
    [txtFile appendFormat:@"%@\n", logLine];
    NSLog(@"ResearchUtility: %@", logLine);
    
    [txtFile writeToFile:finalPath atomically:YES encoding:NSUTF8StringEncoding error:nil];

}

+ (void)logEvent:(NSString *)activityString withDuration:(int)duration withItem:(NSString *)item
{
    // Research Study
    NSMutableString * txtFile = [NSMutableString string];
    NSDate *today = [NSDate date];
    NSString *fileName = @"/study.csv";
    NSString * logLine = [NSString stringWithFormat:@"%@,%@,%i,%@,", today, activityString, duration, item];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *finalPath = [NSString stringWithFormat:@"%@%@",documentsDir, fileName];
    
    
    NSString* fileContents = [NSString stringWithContentsOfFile:finalPath
                                                       encoding:NSUTF8StringEncoding error:nil];
    [txtFile appendFormat:@"%@\n", fileContents];
    [txtFile appendFormat:@"%@\n", logLine];
    NSLog(@"ResearchUtility: %@", logLine);
    
    [txtFile writeToFile:finalPath atomically:YES encoding:NSUTF8StringEncoding error:nil];

}

+ (void)logEvent:(NSString *)activityString withItem:(NSString *)item
{
    // Research Study
    NSMutableString * txtFile = [NSMutableString string];
    NSDate *today = [NSDate date];
    NSString *fileName = @"/study.csv";
    NSString * logLine = [NSString stringWithFormat:@"%@,%@,,%@,", today, activityString, item];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *finalPath = [NSString stringWithFormat:@"%@%@",documentsDir, fileName];
    
    
    NSString* fileContents = [NSString stringWithContentsOfFile:finalPath
                                                       encoding:NSUTF8StringEncoding error:nil];
    [txtFile appendFormat:@"%@\n", fileContents];
    [txtFile appendFormat:@"%@\n", logLine];
    NSLog(@"ResearchUtility: %@", logLine);
    
    [txtFile writeToFile:finalPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}


@end
