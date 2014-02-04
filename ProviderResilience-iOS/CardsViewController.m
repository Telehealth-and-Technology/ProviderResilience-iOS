//
//  CardsViewController.m
//  ProviderResilience-iOS
//
//  Created by Brian Doherty on 5/8/12.
//  Copyright (c) 2012 T2. All rights reserved.
//

#import "CardsViewController.h"
#import "ProviderResilienceAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#import "ResearchUtility.h"
#import "PRAnalytics.h"

@interface CardsViewController ()

@end

@implementation CardsViewController
@synthesize virtueCards;
@synthesize labelTitle;
@synthesize labelCopyright;
@synthesize labelSwipeHorz;
@synthesize viewVirtueCard;
@synthesize buttonProceed;
@synthesize startSession;

#pragma mark View Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bStartupMode = FALSE;           // Not in Startup Mode unless told so
    }
    return self;
}

#pragma mark View Life Cycle
- (void)viewDidLoad
{
    // Handle Swipe Gestures
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestures:)];
    [swipeLeft setDirection:(UISwipeGestureRecognizerDirectionLeft )];
    [self.view addGestureRecognizer:swipeLeft];
    [swipeLeft release];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestures:)];
    [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight )];
    [self.view addGestureRecognizer:swipeRight];
    [swipeRight release];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestures:)];
    [swipeUp setDirection:(UISwipeGestureRecognizerDirectionUp )];
    [self.view addGestureRecognizer:swipeUp];
    [swipeUp release];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestures:)];
    [swipeDown setDirection:( UISwipeGestureRecognizerDirectionDown )];
    [self.view addGestureRecognizer:swipeDown];
    [swipeDown release];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Get our Virtues
    virtueCards = [VirtueCardDeck alloc];
    virtueCards.pListFileName = [NSString stringWithFormat:@"VirtueCards"];
    [virtueCards initPlist];
    
    // Customize the Proceed button
    self.buttonProceed.layer.cornerRadius = 8;
        
    // If we are in Startup mode, then select a random card to display...and give ourselves a way out
    if (bStartupMode) {
        buttonProceed.enabled = YES;
        buttonProceed.hidden = NO;
        [virtueCards getRandomVirtue];
    } else {
        buttonProceed.enabled = FALSE;
        buttonProceed.hidden = YES;
    }
    
    // Display the currently selected Virtue Card
    NSBundle* myBundle = [NSBundle mainBundle];
    NSString* myImage = [myBundle pathForResource:[virtueCards fileForVirtue:[[virtueCards CurrentVirtue] intValue]] ofType:@"jpg"];
    viewVirtueCard.image = [UIImage imageWithContentsOfFile:myImage];
    //NSLog(@"Image name: %@",myImage);
}

- (void)viewWillAppear:(BOOL)animated  {
    
    [super viewWillAppear:animated];
    
    startSession = [[NSDate date] retain];

}

- (void)viewWillDisappear:(BOOL)animated
{
    int myDuration = 0;
    NSDate *endSession = [NSDate date];
    
    NSTimeInterval timeDifference = [endSession timeIntervalSinceDate:startSession];
    NSInteger time = round(timeDifference);
    myDuration = time;
    [ResearchUtility logEvent:myDuration inSection:EVENT_SECTION_CARDSVIEW  withItem:EVENT_ITEM_NONE  withActivity:EVENT_ACTIVITY_CLOSEWITHDURATION withValue:@"null"];
    
    NSLog(@"timeDifference: %i seconds", myDuration);
    startSession = nil;
    [startSession release];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [viewVirtueCard release];
    viewVirtueCard = nil;
    [labelTitle release];
    labelTitle = nil;
    [labelCopyright release];
    labelCopyright = nil;
    [virtueCards release];
    virtueCards = nil;
    [buttonProceed release];
    buttonProceed = nil;
    [labelSwipeHorz release];
    labelSwipeHorz = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    //NSLog(@"CardsViewController Did Receive Memory Warning");
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [viewVirtueCard release];
    [labelTitle release];
    [labelCopyright release];
    [virtueCards release];
    [buttonProceed release];
    [labelSwipeHorz release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL biPhoneOrientation = (interfaceOrientation== UIInterfaceOrientationPortrait);
    BOOL bOrientation = biPhoneOrientation;
    
    // Customize for iPad (orientation and other)
    /*
     BOOL biPadOrientation = biPhoneOrientation || (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) ||
     (interfaceOrientation==UIInterfaceOrientationLandscapeRight);
     
     //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) bOrientation = biPadOrientation;
     */
    return bOrientation;
}

#pragma mark Startup Mode
// Indicate that we are in Startup Mode
// Display a random card and only let user exit to normal operations
- (IBAction)buttonProceed_Clicked:(id)sender {
    // Refer back to the delegate to keep going with the normal stuff  
    bStartupMode = FALSE;
    [virtueCards initPlist];            // Get the original card back (not the random card)
    ProviderResilienceAppDelegate *appDelegate = (ProviderResilienceAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate normalStartUp];
}

-(void)StartupMode {
    bStartupMode = TRUE;
}

#pragma mark Gestures

// Move through the Array of Virtue Cards (based on the swipe gesture from the user)
-(void)handleSwipeGestures:(UISwipeGestureRecognizer *)recognizer {
    BOOL bDoTransition = NO;
    
    // If the user swipes Up or Down, 'flip' the card between the Front and the Reverse
    if (recognizer.direction & (UISwipeGestureRecognizerDirectionUp |UISwipeGestureRecognizerDirectionDown)) {
        [virtueCards bToggleFront:!bStartupMode];                 // Flip the card...save the change if we are NOT in startup mode
        bDoTransition = YES;
    }
    
    // Only allow selection of a new card if we are NOT in Startup Mode
    if (!bStartupMode) {
        // Swipe Right...we want to go BACK a card
        if (recognizer.direction & UISwipeGestureRecognizerDirectionRight) { 
            [virtueCards getPrevVirtue];
        }
        
        // Swipe Left...we want to go FORWARD a card
        if (recognizer.direction & UISwipeGestureRecognizerDirectionLeft) { 
            [virtueCards getNextVirtue];
        }
        
        bDoTransition = YES;
    }
        
    if (bDoTransition) {
        // Select the new Virtue Card
        NSBundle* myBundle = [NSBundle mainBundle];
        NSString* myImage = [myBundle pathForResource:[virtueCards fileForVirtue:[[virtueCards CurrentVirtue] intValue]] ofType:@"jpg"];
        viewVirtueCard.image = [UIImage imageWithContentsOfFile:myImage];
        //NSLog(@"Image name: %@",myImage);
    }
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // Only allow selection of a new card if we are NOT in Startup Mode
    if (!bStartupMode) {
        // Swipe Left...push the Next Card in
        if (recognizer.direction & UISwipeGestureRecognizerDirectionLeft) {
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
        }
        
        // Swipe Right...push the Previous Card in
        if (recognizer.direction & UISwipeGestureRecognizerDirectionRight) {
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
        }
    }
        
    // Swipe Up or Down...fade between the Front and Back of the card
    if (recognizer.direction & (UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown)) {        
        transition.type = kCATransitionFade;
    }

    if (bDoTransition)
        [viewVirtueCard.layer addAnimation:transition forKey:nil];
}

@end
