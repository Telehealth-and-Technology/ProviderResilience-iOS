//
//  EulaViewController.m
//  ProviderResilience-iOS
//
//  Created by Brian Doherty on 6/21/12.
//  Copyright (c) 2012 T2. All rights reserved.
//

#import "EulaViewController.h"
#import "ProviderResilienceAppDelegate.h"
#import "ResearchUtility.h"

@implementation EulaViewController

#pragma mark - Properties

@synthesize textView = textView_;

#pragma mark - Lifecycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_image.png"]];
    
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Software License Agreement", @"");
    
    NSStringEncoding encoding;
    NSError *error;
    NSString *EULAPath = [[NSBundle mainBundle] pathForResource:@"EULA" ofType:@"txt"];  
    NSString *EULAText = [NSString stringWithContentsOfFile:EULAPath usedEncoding:&encoding error:&error];
    
    self.textView.text = EULAText;
}

- (void)viewDidUnload
{
    self.textView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated  {
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    //NSLog(@"EulaViewController Did Receive Memory Warning");
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


/**
 *  dealloc
 */

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
#pragma mark - IBActions

/**
 *  handleAcceptedButtonTapped
 */
- (IBAction)handleAcceptedButtonTapped:(id)sender
{
    // Application preference keys
    NSString *kEULAdone					= @"eulaDONE";
    // Indicate the user has agreed to the EULA
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:kEULAdone];
    
    [defaults synchronize];
    
    // Refer back to the delegate to keep going with any start up stuff  
    ProviderResilienceAppDelegate *appDelegate = (ProviderResilienceAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate eulaStartUp];
}

/**
 *  handleDeclinedButtonTapped
 */
- (IBAction)handleDeclinedButtonTapped:(id)sender
{
    /*
    NSString *alertTitle = NSLocalizedString(@"Quit Provider Resilience App?", @"");
    NSString *alertMessage = NSLocalizedString(@"Are you sure you want to quit Provider Resilience Application?", @"");
    NSString *okTitle = NSLocalizedString(@"YES", @"");
    NSString *cancelTitle = NSLocalizedString(@"NO", @"");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle 
                                                        message:alertMessage 
                                                       delegate:self 
                                              cancelButtonTitle:cancelTitle 
                                              otherButtonTitles:okTitle, nil];
    [alertView show];
    [alertView release];
     */
}

#pragma mark - UIAlertViewDelegate Methods

/**
 *  alertView:clickedButtonAtIndex
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // buttonIndex 0 is the Cancel button. buttonIndex 1 is the "Yes" button.
    if (buttonIndex == 1)
    {
        // Quit the application. Note that per Apple's own documentation, we aren't supposed to quit. 
        // http://developer.apple.com/library/ios/#qa/qa1561/_index.html
        
        // Exiting the main thread will quit the app, but it might cause App Store rejection.
        //exit(0);
    }
}


@end
