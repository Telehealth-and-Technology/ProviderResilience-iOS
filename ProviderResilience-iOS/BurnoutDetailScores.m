//
//  BurnoutDetailScores.m
//  ProviderResilience-iOS
//
//  Created by Brian Doherty on 7/25/12.
//  Copyright (c) 2012 T2. All rights reserved.
//

#import "BurnoutDetailScores.h"

@implementation BurnoutDetailScores
@synthesize nScoreHappy;
@synthesize nScoreCaring;
@synthesize nScoreOnedge;
@synthesize nScoreTrapped;
@synthesize nScoreWornout;
@synthesize nScoreValuable;
@synthesize nScoreConnected;
@synthesize nScoreSatisfied;
@synthesize nScorePreoccupied;
@synthesize nScoreTraumatized;



NSString *fileName;

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    fileName = kFilename2;
    fileName  = [fileName stringByAppendingString:@".plist"];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (void)initPlist {   
    
    // Read our data from the plist
    NSString *filePath = [self dataFilePath];
    
    // We first try to find it in our App directory (the updated version)
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // Doesn't exist in our App directory...use the original one in the bundle
        filePath = [[NSBundle mainBundle] pathForResource:kFilename2 ofType:@"plist"];
    }
    
    // Make sure we have a file     
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
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
        
        if (!temp) {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        
        // Only continue if we read the plist
        if (temp) {
            // OK...let's process what we got
            
            // Grab the values
            nScoreHappy = [temp objectForKey:kHappyScore];
            nScoreTrapped = [temp objectForKey:kTrappedScore];
            nScoreSatisfied = [temp objectForKey:kSatisfiedScore];
            nScorePreoccupied = [temp objectForKey:kPreoccupiedScore];
            nScoreConnected = [temp objectForKey:kConnectedScore];
            nScoreWornout = [temp objectForKey:kWornoutScore];
            nScoreCaring = [temp objectForKey:kCaringScore];
            nScoreOnedge = [temp objectForKey:kOnedgeScore];
            nScoreValuable = [temp objectForKey:kValuableScore];
            nScoreTraumatized = [temp objectForKey:kTraumatizedScore];
            
        }
        
    } 
}


- (void)writeToPlist {
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    // Set the values for each attribute
    [data setObject:nScoreHappy forKey:kHappyScore];
    [data setObject:nScoreTrapped forKey:kTrappedScore];
    [data setObject:nScoreSatisfied forKey:kSatisfiedScore];
    [data setObject:nScorePreoccupied forKey:kPreoccupiedScore];
    [data setObject:nScoreConnected forKey:kConnectedScore];
    [data setObject:nScoreWornout forKey:kWornoutScore];
    [data setObject:nScoreCaring forKey:kCaringScore];
    [data setObject:nScoreOnedge forKey:kOnedgeScore];
    [data setObject:nScoreValuable forKey:kValuableScore];
    [data setObject:nScoreTraumatized forKey:kTraumatizedScore];
    
    [data writeToFile:[self dataFilePath] atomically:YES];
}


- (void)dealloc {;
}



@end
