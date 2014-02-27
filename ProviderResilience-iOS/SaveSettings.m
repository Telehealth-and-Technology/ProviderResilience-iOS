//
//  SaveSettings.m
//  ProviderResilience-iOS
//
//  Created by Brian Doherty on 5/18/12.
//  Copyright (c) 2012 T2. All rights reserved.
//

#import "SaveSettings.h"

@implementation SaveSettings 
@synthesize bWelcomeMessage;
@synthesize bDailyReminders;
@synthesize bVacationOnOff;
@synthesize dateTimeLastReset;
@synthesize dateTimeScoresReset;
@synthesize dateTimeDailyReminders;
@synthesize dateTimeLastVacation;
@synthesize dateTimeLastProQOL;
@synthesize dateTimeLastBurnout;
@synthesize dateTimeBuilderKiller;
@synthesize nScoreCompassion;
@synthesize nScoreBurnout;
@synthesize nScoreTrauma;
@synthesize nScoreKillers;
@synthesize nScoreBonus;
@synthesize nScoreBuilders;
@synthesize nScoreFunStuff;
@synthesize txtBonus1;
@synthesize txtBonus2;

NSString *fileName;

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    fileName = kFilename;
    fileName  = [fileName stringByAppendingString:@".plist"];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (void)initPlist
{
    // First, set default values in case the file does not exist yet
    // If the file doesn't exist yet,  set default values
    bWelcomeMessage = [NSNumber numberWithBool:NO];
    bDailyReminders = [NSNumber numberWithBool:NO];
    bVacationOnOff = [NSNumber numberWithBool:NO];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
    
    dateTimeLastReset = [dateFormat dateFromString:@"07/11/2000 12:00"];
    dateTimeLastProQOL = [dateFormat dateFromString:@"07/11/2000 12:00"];
    dateTimeLastBurnout = [dateFormat dateFromString:@"07/11/2000 12:00"];
    dateTimeBuilderKiller = [dateFormat dateFromString:@"07/11/2000 12:00"];
    dateTimeLastVacation = [dateFormat dateFromString:@"07/11/1962 12:00"];    // Needs to be at least 50 years ago
    dateTimeDailyReminders = [dateFormat dateFromString:@"07/11/2012 08:00"];
    dateTimeScoresReset = [dateFormat dateFromString:@"07/11/2012 02:00"];
    
    nScoreCompassion = [NSNumber numberWithInteger:0];
    nScoreBurnout = [NSNumber numberWithInteger:0];
    nScoreTrauma = [NSNumber numberWithInteger:0];
    nScoreBuilders = [NSNumber numberWithInteger:0];
    nScoreBonus = [NSNumber numberWithInteger:0];
    nScoreKillers = [NSNumber numberWithInteger:0];
    nScoreFunStuff = [NSNumber numberWithInteger:0];
    
    txtBonus1 = [NSString stringWithFormat:@""];
    txtBonus2 = [NSString stringWithFormat:@""];
    
    // Read our data from the plist
    NSString *filePath = [self dataFilePath];
    
    // We first try to find it in our App directory (the updated version)
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        // Doesn't exist in our App directory...use the original one in the bundle
        filePath = [[NSBundle mainBundle] pathForResource:kFilename ofType:@"plist"];
    }
    
    // Make sure we have a file     
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        
        // Create a dictionary where we will load the data from the plist
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:filePath];
        
        // Read it in
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
        
        if (!temp)
        {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        
        // Only continue if we read the plist
        if (temp)
        {
            // OK...let's process what we got
            
            // Grab the values
            bWelcomeMessage = [temp objectForKey:kWelcomeMessage] ; 
            bDailyReminders = [temp objectForKey:kDailyReminders];
            bVacationOnOff = [temp objectForKey:kVacationOnOff];
            dateTimeLastReset = [temp objectForKey:kLastResetDateTime];
            dateTimeScoresReset = [temp objectForKey:kDailyScoresResetTime];
            dateTimeDailyReminders = [temp objectForKey:kDailyReminderTime];
            dateTimeLastVacation = [temp objectForKey:kLastVacationDateTime];
            dateTimeLastProQOL = [temp objectForKey:kLastProQOLDateTime];
            dateTimeLastBurnout = [temp objectForKey:kLastBurnoutDateTime];
            dateTimeBuilderKiller = [temp objectForKey:kBuilderKillerDateTime];
            nScoreCompassion = [temp objectForKey:kLastProQOLScoreCompasson];
            nScoreBurnout = [temp objectForKey:kLastProQOLScoreBurnout];
            nScoreTrauma = [temp objectForKey:kLastProQOLScoreTrauma];
            nScoreBuilders = [temp objectForKey:kLastProQOLScoreBuilders];
            nScoreBonus = [temp objectForKey:kLastProQOLScoreBonus];
            nScoreKillers = [temp objectForKey:kLastProQOLScoreKillers];
            nScoreFunStuff = [temp objectForKey:kLastScoreFunStuff];
            txtBonus1 = [temp objectForKey:kTextBonus1];
            txtBonus2 = [temp objectForKey:kTextBonus2];
                                   
        }
        
    }
    else
    {
        [self writeToPlist];            // Make sure the file does exist        
    }
}

// Helper method to retreive BOOL from a NSNumber
- (BOOL)boolFromNumber: (NSNumber *)numItem {
    BOOL bValue = NO;
    if ([numItem intValue] != 0)
        bValue = YES;
    
    return bValue;
}

// Helper method to set BOOL into an NSNumber
- (void)boolToNumber:(BOOL)YesNo numItem:(NSNumber *)numItem {
    
    // We will be changing this
    numItem = nil;
    
    // Set the value
    if (YesNo)
    {
        numItem = [[NSNumber alloc] initWithInteger:1];
    } else {
        numItem = [[NSNumber alloc] initWithInteger:0];
    }
         
}

- (void)uWelcome: (BOOL)bYesNo{
    bWelcomeMessage = nil;
    
    // Set the value
    if (bYesNo) 
    {
        bWelcomeMessage = [[NSNumber alloc] initWithInteger:1];
    } else {
        bWelcomeMessage = [[NSNumber alloc] initWithInteger:0];
    }
}

- (void)uDaily: (BOOL)bYesNo{
    bDailyReminders = nil;
    
    // Set the value
    if (bYesNo) 
    {
        bDailyReminders = [[NSNumber alloc] initWithInteger:1];
    } else {
        bDailyReminders = [[NSNumber alloc] initWithInteger:0];
    }
    
}

- (void)uScoreCompassion:(NSInteger *)myNewScoreCompassion {
    
    nScoreCompassion = nil;
    
    // Set the value
    nScoreCompassion = [[NSNumber alloc] initWithInteger:*myNewScoreCompassion];    
}

- (void)uScoreBurnout:(NSInteger *)myNewScoreBurnout {
    
    nScoreBurnout = nil;
    
    // Set the value
    nScoreBurnout = [[NSNumber alloc] initWithInteger:*myNewScoreBurnout];    
}

- (void)uScoreTrauma:(NSInteger *)myNewScoreTrauma {
    
    nScoreTrauma = nil;
    
    // Set the value
    nScoreTrauma = [[NSNumber alloc] initWithInteger:*myNewScoreTrauma];
}

- (void)uScoreBuilders:(NSInteger *)myNewScoreBuilders {
    
    nScoreBuilders = nil;
    
    // Set the value
    nScoreBuilders = [[NSNumber alloc] initWithInteger:*myNewScoreBuilders];
}

- (void)uScoreBonus:(NSInteger *)myNewScoreBonus {
    
    nScoreBonus = nil;
    
    // Set the value
    nScoreBonus = [[NSNumber alloc] initWithInteger:*myNewScoreBonus];
}

- (void)uScoreKillers:(NSInteger *)myNewScoreKillers {
    
    nScoreKillers = nil;
    
    // Set the value
    nScoreKillers = [[NSNumber alloc] initWithInteger:*myNewScoreKillers];
}

- (void)uScoreFunStuff:(NSInteger *)myNewScoreFunStuff {
    
    nScoreFunStuff = nil;
    
    // Set the value
    nScoreFunStuff = [[NSNumber alloc] initWithInteger:*myNewScoreFunStuff];
}


- (void)uTextBonus1:(NSString *)myNewTextBonus1 {
    if (myNewTextBonus1 != nil) {
        txtBonus1 = nil;
        
        txtBonus1 = [[NSString alloc] initWithString:myNewTextBonus1];
    }
}

- (void)uTextBonus2:(NSString *)myNewTextBonus2 {
    if (myNewTextBonus2 != nil) {
        txtBonus2 = nil;
        
        txtBonus2 = [[NSString alloc] initWithString:myNewTextBonus2];
    }
}

- (void)uVacation:(BOOL)bYesNo{
    bVacationOnOff = nil;
    
    // Set the value
    if (bYesNo) 
    {
        bVacationOnOff = [[NSNumber alloc] initWithInteger:1];
    } else {
        bVacationOnOff = [[NSNumber alloc] initWithInteger:0];
    }
    
}


- (void)uDateTimeLastReset:(NSDate *)myNewDateTime {
    dateTimeLastReset = nil;
    
    dateTimeLastReset = myNewDateTime;
}

- (void)uDateTimeScoresReset:(NSDate *)myNewDateTime {
    dateTimeScoresReset = nil;
    
    dateTimeScoresReset = myNewDateTime;
}

- (void)uDateTimeDailyReminders:(NSDate *)myNewDateTime {
    dateTimeDailyReminders = nil;
    
    dateTimeDailyReminders = myNewDateTime;
}


- (void)uDateTimeLastVacation:(NSDate *)myNewDateTime {
    dateTimeLastVacation = nil;
    
    dateTimeLastVacation = myNewDateTime;
}

- (void)uDateTimeLastProQOL:(NSDate *)myNewDateTime {
    dateTimeLastProQOL = nil;
    
    dateTimeLastProQOL = myNewDateTime;
}

- (void)uDateTimeLastBurnout:(NSDate *)myNewDateTime {
    dateTimeLastBurnout = nil;
    
    dateTimeLastBurnout = myNewDateTime;
}

- (void)uDateTimeBuilderKiller:(NSDate *)myNewDateTime {
    dateTimeBuilderKiller = nil;
    
    dateTimeBuilderKiller = myNewDateTime;
}

/*
[myElement setObject:(id)kCFBooleanTrue forKey:kFrontKey];
else
[myElement setObject:(id)kCFBooleanFalse forKey:kFrontKey];
*/


- (void)writeToPlist {
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    // Set the values for each attribute
    [data setObject:bWelcomeMessage    forKey:kWelcomeMessage];
    [data setObject:bDailyReminders    forKey:kDailyReminders];
    [data setObject:bVacationOnOff    forKey:kVacationOnOff];
    [data setObject:dateTimeScoresReset forKey:kDailyScoresResetTime];
    [data setObject:dateTimeDailyReminders forKey:kDailyReminderTime];
    [data setObject:dateTimeLastVacation forKey:kLastVacationDateTime];
    [data setObject:dateTimeLastReset forKey:kLastResetDateTime];
    [data setObject:dateTimeLastBurnout forKey:kLastBurnoutDateTime];
    [data setObject:dateTimeLastProQOL forKey:kLastProQOLDateTime];
    [data setObject:dateTimeBuilderKiller forKey:kBuilderKillerDateTime];
    [data setObject:nScoreCompassion forKey:kLastProQOLScoreCompasson];
    [data setObject:nScoreBurnout forKey:kLastProQOLScoreBurnout];
    [data setObject:nScoreTrauma forKey:kLastProQOLScoreTrauma];
    [data setObject:nScoreBuilders forKey:kLastProQOLScoreBuilders];
    [data setObject:nScoreBonus forKey:kLastProQOLScoreBonus];
    [data setObject:nScoreKillers forKey:kLastProQOLScoreKillers];
    [data setObject:nScoreFunStuff forKey:kLastScoreFunStuff];
    if (txtBonus1 != nil) [data setObject:txtBonus1 forKey:kTextBonus1];
    if (txtBonus2 != nil) [data setObject:txtBonus2 forKey:kTextBonus2];
    
    
    [data writeToFile:[self dataFilePath] atomically:YES];
}


@end
