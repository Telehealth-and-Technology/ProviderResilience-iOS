//
//  SettingsViewController.h
//  ProviderResilience-iOS
//
//  Created by Brian Doherty on 5/8/12.
//  Copyright (c) 2012 T2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DateTimePicker.h"
#import "SaveSettings.h"

@interface SettingsViewController : UIViewController <MFMailComposeViewControllerDelegate, DateTimePickerDelegate> {
    // Persistent data that we will store in Settings.plist  
    BOOL bWelcomeMsg;
    BOOL bDailyReminders;
    
    SaveSettings *currentSettings;
}
@property (nonatomic, strong) NSDate *startSession;


@property (strong, nonatomic) SaveSettings *currentSettings;

// Reset Application
- (IBAction)reset_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *labelReset;
@property (strong, nonatomic) IBOutlet UIButton *buttonReset;

// Welcome Message (display or not display)
- (IBAction)welcome_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *labelWelcome;
@property (strong, nonatomic) IBOutlet UIButton *buttonWelcome;
@property (strong, nonatomic) IBOutlet UIImageView *img_welcomeOnOff;

// Daily Reminders (yes/no)
- (IBAction)reminder_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *labelReminder;
@property (strong, nonatomic) IBOutlet UIButton *buttonReminder;
@property (strong, nonatomic) IBOutlet UIImageView *img_reminderOnOff;

// Remind me at:
- (IBAction)remindAt_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *labelRemindAt;
@property (strong, nonatomic) IBOutlet UIButton *buttonRemindAt;

// Reset Scores Time
- (IBAction)resetScores_clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *labelResetScores;
@property (strong, nonatomic) IBOutlet UIButton *buttonResetScores;

// Send Feedback
- (IBAction)feedback_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *labelFeedback;
@property (strong, nonatomic) IBOutlet UIButton *buttonFeedback;

// Study Enrollment
- (IBAction)sendResearchData_Clicked:(id)sender;
- (IBAction)disenrollFromStudy_Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *buttonSendResearchData;
@property (strong, nonatomic) IBOutlet UIButton *buttonDisenrollFromStudy;

// Email methods
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
-(void)shouldWeLaunchEmail;

// Helper Methods
- (void)setUpWelcomeButton:(BOOL)bOnOff;
- (void)setUpReminderButton:(BOOL)bOnOff;

@end
