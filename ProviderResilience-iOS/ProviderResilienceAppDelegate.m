//
//  ProviderResilienceAppDelegate.m
//  ProviderResilience-iOS
//
//  Created by Brian Doherty on 5/8/12.
//  Copyright (c) 2012 T2. All rights reserved.
//

#import "ProviderResilienceAppDelegate.h"
#import "ToolsViewController.h"
#import "DashboardViewController.h"
#import "CardsViewController.h"
#import "PRdatabaseSQL.h"
#import "EulaViewController.h"
#import "AboutViewController.h"
#import "PRAnalytics.h"
#import "ResearchUtility.h"

@implementation ProviderResilienceAppDelegate

@synthesize rootController = __rootController;;
@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize networkStatus;
@synthesize connectionRequired;
@synthesize bcServices;
@synthesize previousTabNibName;

void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"Error Logged: %@", exception.description);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"welcome");

    // Grab the current settings
    SaveSettings *currentSettings = [SaveSettings alloc];
    [currentSettings initPlist];
    
    // Remove any badges
	application.applicationIconBadgeNumber = 0;
	
    // Make sure we get our Brightcove connection (can be removed if we implement the stuff that follows!)
    [self checkBCConnection];
    
    
    
    NSString *reachablityURL = [self getAppSetting:@"URLs" withKey: @"reachablityCheckBC"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    
    hostReach = [Reachability reachabilityWithHostName: reachablityURL];
	[hostReach startNotifier];
	
    internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
    
    wifiReach = [Reachability reachabilityForLocalWiFi];
	[wifiReach startNotifier];

    // Make sure we have a database before we go too far
    PRdatabaseSQL *mySQL = [PRdatabaseSQL alloc];
    [mySQL createDbTables];
    // [mySQL release];
    
    //Set the default ShowingWelcome value to NO to achieve a normal launch and event tracking
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"ShowingWelcome"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    //[self.window addSubview:rootController.view];
    
    // Check NSUserDefaults to make sure we have read the EULA
    // Note...we will not create the KEY if the user says NO...
    // So if the KEY is missing, they have not agreed to the EULA yet
    NSString *kEULAdone					= @"eulaDONE";
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kEULAdone];
    if (testValue == nil)
    {
        // User needs to agree to the EULA before continuing...
        EulaViewController *viewController = [EulaViewController alloc];
        self.window.rootViewController = viewController;
    } else {        
        // Check if they want the welcome screen
        
        // Set up the On/Off buttons 
        BOOL bShowWelcome = [currentSettings boolFromNumber:[currentSettings bWelcomeMessage]];
        if (bShowWelcome) {
            //Record the ShowWelcome to help with event tracking
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"ShowingWelcome"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //Record the help open event
            [ResearchUtility logEvent:0 inSection:EVENT_SECTION_HELPVIEW  withItem:EVENT_ITEM_NONE  withActivity:EVENT_ACTIVITY_OPEN withValue:@"null"];
            
            // Display the welcome
            AboutViewController *viewController = [AboutViewController alloc];
            [viewController StartupMode];
            self.window.rootViewController = viewController;
                        
        } else {
            // Show a random card
            // 01-07-2013 Don't show these on start up anymore
            /*
            CardsViewController *viewController = [CardsViewController alloc];
            [viewController StartupMode];
            self.window.rootViewController = viewController;
            [viewController release];
             */
            [self normalStartUp];
        }
        
    }
    
    return YES;
}

- (void)eulaStartUp {
    //Record the ShowWelcome to help with event tracking
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"ShowingWelcome"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Record the help open event
    [ResearchUtility logEvent:0 inSection:EVENT_SECTION_HELPVIEW  withItem:EVENT_ITEM_NONE  withActivity:EVENT_ACTIVITY_OPEN withValue:@"null"];
    
    // Display the welcome
    AboutViewController *viewController = [AboutViewController alloc];
    [viewController StartupMode];
    self.window.rootViewController = viewController;
    
    // Grab the current settings
    SaveSettings *currentSettings = [SaveSettings alloc];
    [currentSettings initPlist];
    [currentSettings uWelcome:NO];
    [currentSettings writeToPlist];     // Turn off the welcome message after the first showing
}

- (void)normalStartUp {
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"ShowingWelcome"] isEqual: @"NO"]) {
        //Record dashboard startup
        [ResearchUtility logEvent:0 inSection:EVENT_SECTION_DASHBOARD  withItem:EVENT_ITEM_NONE  withActivity:EVENT_ACTIVITY_OPEN withValue:[NSString stringWithFormat:@"%i", [self computeResilienceRating]]];
    }
    
    //Assign DashboardViewController to previousTabNibName
    previousTabNibName = @"DashboardViewController";
    
    // Hand off to the tab bar controller
    self.window.rootViewController = __rootController;
    self.window.rootViewController.tabBarController.selectedIndex = 2;   // Display the cards first
    self.window.rootViewController.tabBarController.delegate = self;
    [self.window makeKeyAndVisible];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    // Remove any badges
	application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark local notifications
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

// UIApplicationState state = [application applicationState];
// if (state == UIApplicationStateInactive) {

// Application was in the background when notification
// was delivered.
// }

// Remove the badges
application.applicationIconBadgeNumber = 0;
    
    /*
    if ([@"YES" isEqualToString:[notification.userInfo valueForKey:kNotifyDailyReminder]]) NSLog(@"Daily Reminder received");
    else NSLog(@"Other local notification received");
    */
    
    if ([@"YES" isEqualToString:[notification.userInfo valueForKey:kNotifyDailyReminder]]) {
        
        NSString *alertTitle = NSLocalizedString(@"Reminder", nil);
        NSString *alertMessage = NSLocalizedString(@"Please remember to update your Provider Resilience Score!", nil);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle 
                                                            message:alertMessage 
                                                           delegate:nil 
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark TabBarController Delegate Methods
/*
- (void)tabBar:(UITabBar *)theTabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger indexOfTab = [[theTabBar items] indexOfObject:item];
    NSLog(@"Tab index = %u", indexOfTab);
}
 */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //Depending on where we came from record an open event
    if([viewController.nibName isEqualToString:@"AboutViewController"])
    {
        if([previousTabNibName isEqualToString:viewController.nibName])
            return;
        
        [ResearchUtility logEvent:0 inSection:EVENT_SECTION_HELPVIEW withItem:EVENT_ITEM_NONE  withActivity:EVENT_ACTIVITY_OPEN withValue:@"null"];
    }
    else if([viewController.nibName isEqualToString:@"DashboardViewController"])
    {
        if([previousTabNibName isEqualToString:viewController.nibName])
            [viewController viewWillDisappear:NO];
        
        [ResearchUtility logEvent:0 inSection:EVENT_SECTION_DASHBOARD  withItem:EVENT_ITEM_NONE  withActivity:EVENT_ACTIVITY_OPEN withValue:[NSString stringWithFormat:@"%i", [self computeResilienceRating]]];
    }
    else if([viewController.nibName isEqualToString:@"CardsViewController"])
    {
        if([previousTabNibName isEqualToString:viewController.nibName])
            return;
        
        [ResearchUtility logEvent:0 inSection:EVENT_SECTION_CARDSVIEW withItem:EVENT_ITEM_NONE  withActivity:EVENT_ACTIVITY_OPEN withValue:@"null"];
    }
    
    //NSLog(@"tabBarController delegate called: %@",viewController.nibName);
    // The user has tapped a Tab Bar item
    // Return this controller to its default view (well, the ones that have more than one view)
    if ([viewController.nibName isEqualToString:@"ToolsViewController"])
    {
        if([previousTabNibName isEqualToString:viewController.nibName])
            [viewController viewWillDisappear:NO];
        
        ToolsViewController *ourView = (ToolsViewController *)viewController;
        viewController.view = ourView.viewToolsMenu;
    }
    
    if ([viewController.nibName isEqualToString:@"DashboardViewController"])
    {
        DashboardViewController *ourView = (DashboardViewController *)viewController;
        [ourView NoAssessment];         // Turn off Assessment mode
        viewController.view = ourView.viewMainDashboard;
        [ourView attachDigitalClockView:viewController.view];   // Make sure we have the digital clock
    }
    
    previousTabNibName = viewController.nibName;
}

#pragma openURL Delegate Methods
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"%s", __FUNCTION__);
    
    if(!url) { return NO; }
    
    NSString *filePath = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:filePath];//Using nsdata category base64 to decode string to nsdata
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];//Convert data to nstring
    NSData *myData = [decodedString dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([decodedString length] > 0) {
        /* JSON Parsing */
        
        NSError *e = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: myData options: NSJSONReadingMutableContainers error: &e];
        
//        NSString *action = [jsonDict objectForKey:@"action"];
        NSString *participantID = [jsonDict objectForKey:@"participantId"];
        NSString *recipientEmail = [jsonDict objectForKey:@"recipientEmail"];
        
        // You could prompt user as this point whether they want to participate with this email address
       // NSString *msgText = [NSString stringWithFormat:@"You have enrolled in a study: %@ | %@ | %@", action, participantID, recipientEmail];
        NSString *msgText = [NSString stringWithFormat:@"Study enrollment successful"];
        UIAlertView *alertBarInfo = [[UIAlertView alloc] initWithTitle:@"Successfully Enrolled" message:msgText delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertBarInfo show];
        
        // Save something for test.
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DEFAULTS_USE_RESEARCHSTUDY"];
        [[NSUserDefaults standardUserDefaults] setObject:participantID forKey:@"DEFAULTS_PARTICIPANTNUMBER"];
        [[NSUserDefaults standardUserDefaults] setObject:recipientEmail forKey:@"DEFAULTS_STUDYEMAIL"];
        
        // Create new text log
        NSMutableString * txtFile = [NSMutableString string];
       // NSString *fileName = @"/study.csv";
        NSString *fileName = [NSString stringWithFormat:@"Provider_Resilience_Participant_%@.csv",participantID];
        //NSString * headerLine = [NSString stringWithFormat:@"Participant#: %@",participantID];
        NSString * topRows = [NSString stringWithFormat:@"Participant,Timestamp,Device,OS,OS Version,App,App Version,View,Item,Action,Value"];
        
      //  [txtFile appendFormat:@"%@\n", headerLine];
        [txtFile appendFormat:@"%@", topRows];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        NSString *finalPath = [NSString stringWithFormat:@"%@/%@",documentsDir, fileName];
        [txtFile writeToFile:finalPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return YES;
    
}
-(NSInteger)computeResilienceRating
{
    // NOTE:  I did not use constants to define the scoring cutoff points, unless they were already defined elsewhere
    // At this time, the other #'s are only used here, so it is easier to see the numbers instead of a 'name'.
    // If these numbers are used somewhere else in the future, then that developer can make the decision to use #defines
    
    NSInteger newRating = 0;
    
    // Add each component (a 'perfect' score will be 100 points)
    
    // Grab the current scores...we'll need this a couple of times below
    
    SaveSettings* currentSettings = [[SaveSettings alloc] init];
    [currentSettings initPlist];
    
    //***** Leave Clock (20% of total score)
    // How many days has it been since the last Leave
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yy hh:mma"];
    
    // Score based on how long it has been since the last vacation
    NSTimeInterval myInterval = [[NSDate date] timeIntervalSinceDate:[currentSettings dateTimeLastVacation]];
    if (myInterval > 60*60*24*152)                  // >5 months -- 0 pts
        newRating += 0;
    else if (myInterval >= 60*60*24*122)            // >4 months -- 5 pts
        newRating += 5;
    else if (myInterval >= 60*60*24*91)         // >3 months -- 10 pts
        newRating += 10;
    else if (myInterval >= 60*60*24*61)     // >2 months -- 15 pts
        newRating += 15;
    else
        newRating += 20;                // <2 months -- 20 pts
    
    //NSLog(@"Rating after Leave Clock: %d",newRating);
    
    //***** Daily Burnout VAS (15% of total score)
    // Use the last Burnout score
    // Initialise the data source
    LineChartDataSource* burnoutDatasource = [[LineChartDataSource alloc] initWithFileName:LineChartSource_Burnout seriesCount:1];
    NSInteger boScore = [burnoutDatasource reReadData];
    if (boScore >= 85)
        newRating += 15;
    else if (boScore >= 70)
        newRating += 10;
    else if (boScore >= 50)
        newRating += 5;
    
    //NSLog(@"Rating after Burnout VAS: %d",newRating);
    
    //***** Professional QOL scale (45% of total) // 08/16/2012 NOTE:  See NOTE Below
    NSInteger myCompassion, myBurnout, myTrauma;
    myCompassion = [currentSettings.nScoreCompassion integerValue];
    myBurnout = [currentSettings.nScoreBurnout integerValue];
    myTrauma = [currentSettings.nScoreTrauma integerValue];
    
    // Score each of these seperately
    CGFloat fRating = 0.0;
    if (myCompassion >= kQOLHighScoreCutoff)
        fRating += 7;
    else
        if (myCompassion >= kQOLMedScoreCutoff)
            fRating += 3;
        else
            if (myCompassion >= kQOLLowScoreCutoff)
                fRating += 0;
    
    if (myBurnout >= kQOLHighScoreCutoff)
        fRating += 0;
    else
        if (myBurnout >= kQOLMedScoreCutoff)
            fRating += 3;
        else
            if (myBurnout >= kQOLLowScoreCutoff)
                fRating += 7;
    
    if (myTrauma >= kQOLHighScoreCutoff)
        fRating += 0;
    else
        if (myTrauma >= kQOLMedScoreCutoff)
            fRating += 2;
        else
            if (myTrauma >= kQOLLowScoreCutoff)
                fRating += 6;
    
    // 08/16/2012 NOTE: The original ratings had Pro QOL at 20% of total...that has been increased to 45%
    //  Rather than change the original, individual ratings, we will multiply the sum by 2.25 (45%/20%)
    
    // Add to our cumulative rating (with appropriate round-off)
    newRating += (fRating * 2.25);
    //NSLog(@"ProQOL Score: %0.2f",(fRating*2.25));
    //NSLog(@"Rating after ProQOL: %d",newRating);
    
    
    //***** Builders/Bonus/Killers (10% of total)
    NSInteger myBuilders, myKillers, myBonus, myFun;
    NSInteger myBuilderScore = 0;
    myBuilders = [currentSettings.nScoreBuilders integerValue];
    // Needs to have happened in the past 24 hours...taken care of by a timer that resets these!
    if (myBuilders > 0) {
        myBuilderScore = 6 + (myBuilders - 1);  // 6 pts for having any Builder, plus 1 more point for each additional one
    }
    newRating += myBuilderScore;
    //NSLog(@"Rating after Builders: %d",newRating);
    
    // Bonus will be reset everyday
    myBonus = [currentSettings.nScoreBonus integerValue];
    if ((myBonus > 0) && (myBuilderScore < 10))     // 1 more point possible for the Bonus, but only if we don't already have 10 pts
        newRating += myBonus;                       // 1 or 0 points added, depending on whether they selected a Bonus
    //NSLog(@"Rating after Bonus: %d",newRating);
    
    // Killers need to be reset everyday
    myKillers = [currentSettings.nScoreKillers integerValue];
    //myInterval = [[NSDate date] timeIntervalSinceDate:[self.currentSettings dateTimeBuilderKiller]];
    if (myKillers > 0)   // Needs to have happened in the past 24 hours
        newRating -= myKillers;
    //NSLog(@"Rating after Killers: %d",newRating);
    
    //***** Fun Stuff (10% of total)
    myFun = [currentSettings.nScoreFunStuff integerValue];
    if (myFun > 0)                  // If it is here, it happened in the past 24 hours, count it
        newRating += 10;
    //NSLog(@"Rating after Fun Stuff: %d",newRating);
    
    return newRating;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ProviderResilience_iOS" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ProviderResilience_iOS.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -
#pragma mark Checking Internet Connection

-(BOOL)checkInternet{
    
    NSString *reachablityURL = [self getAppSetting:@"URLs" withKey:@"reachablityCheckBC"];
	Reachability *r = [Reachability reachabilityWithHostName:reachablityURL];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if(internetStatus == ReachableViaWiFi || internetStatus == ReachableViaWWAN) {
		internet = YES;
	}else {
        NSLog(@"Internet is not available");
		internet = NO;
	}
	return internet;
     
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
     
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach {
    if(curReach == hostReach) {
        self.networkStatus = [curReach currentReachabilityStatus];
        self.connectionRequired= [curReach connectionRequired];
        if (self.networkStatus == NotReachable) {
            self.connectionRequired = NO;
        }
    }
    if (!self.bcServices) {
        BOOL hasInternet = NO;
        switch (self.networkStatus) {
            case NotReachable:
                hasInternet = NO;
                break;
            default:
                if (!self.connectionRequired) {
                    hasInternet = YES;
                }
                break;
        }
        [self checkBCConnection];
    }
}


- (void)checkBCConnection
{
    // init Brightcove Media API
    NSString *apiKey = [self getAppSetting:@"Brightcove" withKey:@"apikey1"];
    BCMediaAPI *bcServ = [[BCMediaAPI alloc] initWithReadToken:apiKey];
    [bcServ setMediaDeliveryType:BCMediaDeliveryTypeHTTP];
    
    bcServices = bcServ;
}

- (void)resetBCConnection:(NSString *)key
{
    // init Brightcove Media API
    NSString *apiKey = [self getAppSetting:@"Brightcove" withKey:key];
    BCMediaAPI *bcServ = [[BCMediaAPI alloc] initWithReadToken:apiKey];
    [bcServ setMediaDeliveryType:BCMediaDeliveryTypeHTTP];
    
    bcServices = bcServ;
}

#pragma mark -
#pragma mark Utilities
-(NSString *)getAppSetting:(NSString *)group withKey:(NSString *)key {
    NSDictionary *ps = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"app" ofType:@"plist"]] 
                                                        mutabilityOption:NSPropertyListImmutable 
                                                                  format:nil errorDescription:nil];
    NSDictionary *grp = (NSDictionary *)[ps objectForKey:group];
    return (NSString *)[grp objectForKey:key];
}

@end
