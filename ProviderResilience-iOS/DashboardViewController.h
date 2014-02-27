//
//  DashboardViewController.h
//  ProviderResilience-iOS
//
//  Created by Brian Doherty on 5/8/12.
//  Copyright (c) 2012 T2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveSettings.h"
#import "DateTimePicker.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "LineChartDataSource.h"
#import "BurnoutDetailScores.h"

// ProQOL boundary scores
#define kQOLHighScoreCutoff     42
#define kQOLMedScoreCutoff      23
#define kQOLLowScoreCutoff      1

// VAS Burnout boundary scores
#define kVASHighBurnoutCutoff   85
#define kVASMedBurnoutCutoff    65
#define kVASLowBurnoutCutoff    0

// Resilience Rating boundary scores
#define kRESHighBurnoutCutoff   80
#define kRESMedBurnoutCutoff    40
#define kRESLowBurnoutCutoff    0

// Builder/Killer Button Tags
// Tags 21-29 are Builder Buttons
#define kBuilderButtonLowTag   21
#define kBuilderFirstCustomTag 26
#define kBuilderButtonHighTag  26
// Tags 31-35 are Killer Buttons
#define kKillerButtonLowTag     31
#define kKillerFirstCustomTag   36
#define kKillerButtonHighTag    36


@interface DashboardViewController : UIViewController <DateTimePickerDelegate, SChartDelegate, UITextFieldDelegate> {
    //  Charts/Graphs
    // Burnout
    ShinobiChart    *burnoutChart;
    LineChartDataSource *burnoutDatasource;
    
    
    // Quality Of Life Survey
    NSMutableArray *QOLItemArray;
    NSEnumerator *QOLItemEnumerator;
    NSUInteger currentQOLelement;
    
    // Scorekeeper for ProQOL  (Will change to SQL or other persistent store)
    NSInteger scoreCompassion, scoreBurnout, scoreTrauma;
    
    // Scores for resiliency builders/killers
    NSInteger scoreBuilders, scoreKillers, scoreBonus;
    
    // Timer to update the clock
    NSTimer *updateClockTimer;
    
    // Plist with our settings
    SaveSettings *currentSettings;
    
    // Remember if we are doing an Assessment
    BOOL bAssessmentMode;
    
    CGFloat keyBoardHeight;
    
    
    // Store information about the Meter pointer
    double meterHypotenuseL;  // TBD compute this based on the size of the meter!
    double meterHypotenuseR;
    double meterCenterPtX;
    double meterCenterPtY;
    CGRect meterFrame;
    
    NSDate *startSession;
    BOOL comingFromDialog;
}
@property (nonatomic, strong) NSDate *startSession;


@property (strong, nonatomic) SaveSettings *currentSettings;
@property (strong, nonatomic) NSMutableArray *QOLItemArray;
@property (strong, nonatomic) NSEnumerator *QOLItemEnumerator;
@property NSUInteger currentQOLelement;

@property (nonatomic, strong) NSTimer *updateClockTimer;


// Dashboard Views (and subviews!)
@property (strong, nonatomic) IBOutlet UIView *viewMainDashboard;
@property (strong, nonatomic) IBOutlet UIView *viewUpdateRRClock;
@property (strong, nonatomic) IBOutlet UIView *viewDigitalClock;
@property (strong, nonatomic) IBOutlet UIView *viewUpdateQuality;
@property (strong, nonatomic) IBOutlet UIView *viewSurveyQualityOfLife;
@property (strong, nonatomic) IBOutlet UIView *viewInstructionsQualityOfLife;
@property (strong, nonatomic) IBOutlet UIView *viewAssessments;
@property (strong, nonatomic) IBOutlet UIView *viewBurnoutChart;
@property (strong, nonatomic) IBOutlet UIView *viewBurnoutSurvey;
@property (strong, nonatomic) IBOutlet UIView *viewBuilders;
@property (strong, nonatomic) IBOutlet UIView *viewBuildersBonus;
@property (strong, nonatomic) IBOutlet UIView *viewKillers;

// R&R Clock Elements
@property (strong, nonatomic) IBOutlet UIImageView *imageClockBackground;
@property (strong, nonatomic) IBOutlet UILabel *digitLabelYear;
@property (strong, nonatomic) IBOutlet UILabel *digitLabelMonth;
@property (strong, nonatomic) IBOutlet UILabel *digitLabelDay;
@property (strong, nonatomic) IBOutlet UILabel *digitLabelHour;
@property (strong, nonatomic) IBOutlet UILabel *digitLabelMinute;
@property (strong, nonatomic) IBOutlet UILabel *charLabelYear;
@property (strong, nonatomic) IBOutlet UILabel *charLabelMonth;
@property (strong, nonatomic) IBOutlet UILabel *charLabelDay;
@property (strong, nonatomic) IBOutlet UILabel *charLabelHour;
@property (strong, nonatomic) IBOutlet UILabel *charLabelMinute;
@property (strong, nonatomic) IBOutlet UILabel *digitLabelVacation;

// Assessments Actions
- (IBAction)presentBurnout_Clicked:(id)sender;
- (IBAction)presentBuildersKillers_Clicked:(id)sender;

// Resilience (res) Elements
@property (strong, nonatomic) IBOutlet UILabel *lblBonusBuilder;
@property (strong, nonatomic) IBOutlet UITextField *txtBonusBuilder1;
@property (strong, nonatomic) IBOutlet UITextField *txtBonusKiller1;

// Turn off Assessment mode everytime this view is selected
// Assessment must be proactively selected by the user
- (void)NoAssessment;           

// Resilience (res) Actions
- (IBAction)resBuilder_Clicked:(id)sender;
- (IBAction)presentKillers_Clicked:(id)sender;
- (IBAction)doneBuildersKillers_Clicked:(id)sender;

- (IBAction)changeTestScore_Clicked:(id)sender;


// Main Dashboard (md) QOL Elements
//@property (retain, nonatomic) IBOutlet UILabel *mdRateCompassionLabel;
//@property (retain, nonatomic) IBOutlet UIImageView *mdRateCompassionImage;
//@property (retain, nonatomic) IBOutlet UILabel *mdRateBurnoutLabel;
//@property (retain, nonatomic) IBOutlet UIImageView *mdRateBurnoutImage;
//@property (retain, nonatomic) IBOutlet UILabel *mdRateTraumaLabel;
//@property (retain, nonatomic) IBOutlet UIImageView *mdRateTraumaImage;

// Main Dashboard (bo) Burnout Elements
@property (strong, nonatomic) IBOutlet UILabel *boLabelScore;
@property (strong, nonatomic) IBOutlet UIImageView *boImageGauge;
@property (strong, nonatomic) IBOutlet UILabel *boLabelGauge;

// Main Dashboard (res) Resiliency Elements
@property (strong, nonatomic) IBOutlet UILabel *resLabelScore;
@property (strong, nonatomic) IBOutlet UIImageView *resMeterPointer;
@property (strong, nonatomic) IBOutlet UIStepper *testScoreStepper;
//@property (retain, nonatomic) IBOutlet UIImageView *resImageGauge;
//@property (retain, nonatomic) IBOutlet UILabel *resLabelGauge;

// Burnout Survey Elements
@property (strong, nonatomic) IBOutlet UIScrollView *boScrollView;

@property (strong, nonatomic) IBOutlet UISlider *boSliderHappy;
@property (strong, nonatomic) IBOutlet UISlider *boSliderTrapped;
@property (strong, nonatomic) IBOutlet UISlider *boSliderSatisfied;
@property (strong, nonatomic) IBOutlet UISlider *boSliderPreoccupied;
@property (strong, nonatomic) IBOutlet UISlider *boSliderConnected;
@property (strong, nonatomic) IBOutlet UISlider *boSliderWornout;
@property (strong, nonatomic) IBOutlet UISlider *boSliderCaring;
@property (strong, nonatomic) IBOutlet UISlider *boSliderOnedge;
@property (strong, nonatomic) IBOutlet UISlider *boSliderValuable;
@property (strong, nonatomic) IBOutlet UISlider *boSliderTraumatized;

// Action method to track the slider movement
- (void)boSliderAction:(id)sender;

// Burnout item Labels
@property (strong, nonatomic) IBOutlet UILabel *boLabelHappy;
@property (strong, nonatomic) IBOutlet UILabel *boLabelTrapped;
@property (strong, nonatomic) IBOutlet UILabel *boLabelSatisfied;
@property (strong, nonatomic) IBOutlet UILabel *boLabelPreoccupied;
@property (strong, nonatomic) IBOutlet UILabel *boLabelConnected;
@property (strong, nonatomic) IBOutlet UILabel *boLabelWornout;
@property (strong, nonatomic) IBOutlet UILabel *boLabelCaring;
@property (strong, nonatomic) IBOutlet UILabel *boLabelOnedge;
@property (strong, nonatomic) IBOutlet UILabel *boLabelValuable;
@property (strong, nonatomic) IBOutlet UILabel *boLabelTraumatized;

// Labels to describe the status of each one of the above
@property (strong, nonatomic) IBOutlet UILabel *boLabelHappyNot;
@property (strong, nonatomic) IBOutlet UILabel *boLabelHappyMuch;
@property (strong, nonatomic) IBOutlet UILabel *boLabelTrappedNot;
@property (strong, nonatomic) IBOutlet UILabel *boLabelTrappedMuch;
@property (strong, nonatomic) IBOutlet UILabel *boLabelSatisfiedNot;
@property (strong, nonatomic) IBOutlet UILabel *boLabelSatisfiedMuch;
@property (strong, nonatomic) IBOutlet UILabel *boLabelPreoccupiedNot;
@property (strong, nonatomic) IBOutlet UILabel *boLabelPreoccupiedMuch;
@property (strong, nonatomic) IBOutlet UILabel *boLabelConnectedNot;
@property (strong, nonatomic) IBOutlet UILabel *boLabelConnectedMuch;
@property (strong, nonatomic) IBOutlet UILabel *boLabelWornoutNot;
@property (strong, nonatomic) IBOutlet UILabel *boLabelWornoutMuch;
@property (strong, nonatomic) IBOutlet UILabel *boLabelCaringNot;
@property (strong, nonatomic) IBOutlet UILabel *boLabelCaringMuch;
@property (strong, nonatomic) IBOutlet UILabel *boLabelOnedgeNot;
@property (strong, nonatomic) IBOutlet UILabel *boLabelOnedgeMuch;
@property (strong, nonatomic) IBOutlet UILabel *boLabelValuableNot;
@property (strong, nonatomic) IBOutlet UILabel *boLabelValuableMuch;
@property (strong, nonatomic) IBOutlet UILabel *boLabelTraumatizedNot;
@property (strong, nonatomic) IBOutlet UILabel *boLabelTraumatizedMuch;

// Burnout (bo) Buttons
@property (strong, nonatomic) IBOutlet UIButton *boButtonSubmit;

// Burnout (bo) Chart Actions
- (IBAction)updateBurnoutScore:(id)sender;
- (IBAction)computeBurnoutScore:(id)sender;

// Main View Actions
- (IBAction)updateClock_Clicked:(id)sender;
- (IBAction)updateResilience_Clicked:(id)sender;
- (IBAction)updateQuality_Clicked:(id)sender;

// Update R&R Clock Elements
@property (strong, nonatomic) IBOutlet UIButton *buttonToggleRR;
@property (strong, nonatomic) IBOutlet UIImageView *img_toggleRR;
@property (strong, nonatomic) IBOutlet UIButton *buttonReturnToAssessment;
@property (strong, nonatomic) IBOutlet UILabel *labelReturnToAssessment;

// Update R&R Clock Actions
- (IBAction)changeClock_Clicked:(id)sender;
- (IBAction)toggleRR_Clicked:(id)sender;
- (IBAction)returnToAssessment_Clicked:(id)sender;

- (void)attachDigitalClockView:(UIView *)viewForClock;

// Update Quality of Life Elements  (Shows Updated Status)
@property (strong, nonatomic) IBOutlet UILabel *qlDaysSinceLabel;
@property (strong, nonatomic) IBOutlet UILabel *qlDaysTilNextUpdateLabel;
@property (strong, nonatomic) IBOutlet UILabel *boDaysTilNextUpdateLabel;

@property (strong, nonatomic) IBOutlet UILabel *rateCompassionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *rateCompassionImage;
@property (strong, nonatomic) IBOutlet UILabel *rateCompassionExplainLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateCompassionScoreDescLabel;

@property (strong, nonatomic) IBOutlet UILabel *rateBurnoutLabel;
@property (strong, nonatomic) IBOutlet UIImageView *rateBurnoutImage;
@property (strong, nonatomic) IBOutlet UILabel *rateBurnoutExplainLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateBurnoutScoreDescLabel;

@property (strong, nonatomic) IBOutlet UILabel *rateTraumaLabel;
@property (strong, nonatomic) IBOutlet UIImageView *rateTraumaImage;
@property (strong, nonatomic) IBOutlet UILabel *rateTraumaExplainLabel;
@property (strong, nonatomic) IBOutlet UILabel *rateTraumaScoreDescLabel;

@property (strong, nonatomic) IBOutlet UIButton *continueQOLButton;
@property (strong, nonatomic) IBOutlet UIButton *surveyQOLButton1;
@property (strong, nonatomic) IBOutlet UIButton *surveyQOLButton2;
@property (strong, nonatomic) IBOutlet UIButton *surveyQOLButton3;
@property (strong, nonatomic) IBOutlet UIButton *surveyQOLButton4;
@property (strong, nonatomic) IBOutlet UIButton *surveyQOLButton5;



// Update Quality of Life Actions   (Shows Updated Status)
- (IBAction)updateProQOL_Clicked:(id)sender;
- (IBAction)rateCompassionExplain_Clicked:(id)sender;
- (IBAction)rateBurnoutExplain_Clicked:(id)sender;
- (IBAction)rateTraumaExplain_Clicked:(id)sender;

// Move from QOL Instructions page to the actual survey page
- (IBAction)surveyQOLContinue_Clicked:(id)sender;


// Survey Quality of Life Elements   (Survey to change Status)
@property (strong, nonatomic) IBOutlet UILabel *surveyQOLxxOfxxLabel;
@property (strong, nonatomic) IBOutlet UILabel *surveyQolStatementLabel;

// Survey Quality of Life Actions   (Survey to change Status)
- (IBAction)surveyAnswerButton_Clicked:(id)sender;

// Change the view we present
- (void)changeViewToBurnoutChart;

//Helps record view durations
-(void)switchView:(UIView*)view;

// Helper Methods
- (void)toggleVacationButton:(BOOL)bOnOff;
- (NSString *)dataFilePath:(NSString *)plistFileName;
@end
