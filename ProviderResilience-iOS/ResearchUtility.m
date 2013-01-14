//
//  ResearchUtility.m
//  VAS002
//
//  Created by Melvin Manzano on 11/2/12.
//  Copyright (c) 2012 GDIT. All rights reserved.
//

#import "ResearchUtility.h"

@implementation ResearchUtility

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
