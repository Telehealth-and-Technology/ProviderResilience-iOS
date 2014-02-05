//
//  ToolsViewController.h
//  ProviderResilience-iOS
//
//  Created by Brian Doherty on 5/8/12.
//  Copyright (c) 2012 T2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VirtueCardDeck.h"
#import "SaveSettings.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "LineChartDataSource.h"
#import "ViewBCVideoController.h"

@interface ToolsViewController : UIViewController <SChartDelegate, ViewBCDelegate, 
                            UIWebViewDelegate, NSURLConnectionDelegate, UIAlertViewDelegate> {
    IBOutlet UIImageView *viewStretchCard;
    // Definition of the Stretch Card Deck
    VirtueCardDeck  *stretchCards;
    
    // RSS Feed
    NSMutableArray *_allEntries;
    int nCurrentEntry;
    NSMutableData *receivedData;
    
    //  Charts/Graphs
    ShinobiChart    *qolChart;
    LineChartDataSource *qolDatasource;
    
    // Determine which video menu to return to
    int videoReturn;            // 0->Video Menu, 1->Remind Me..Menu
    NSDate* startSession;
}

@property (nonatomic, strong) NSDate *startSession;


// This is the default view (menu items)
@property (strong, nonatomic) IBOutlet UIView *viewToolsMenu;

// These are the buttons that take us to the other (non-default) views
// Videos
@property (strong, nonatomic) IBOutlet UIButton *videoButton;
@property (strong, nonatomic) IBOutlet UIView *viewVideos;
@property (strong, nonatomic) IBOutlet UIScrollView *viewScrollVideos;

// Physical Exercise (Stretching)
@property (strong, nonatomic) IBOutlet UIButton *physicalButton;
@property (strong, nonatomic) IBOutlet UIView *viewExercise;
@property (copy, nonatomic) VirtueCardDeck *stretchCards;

// Remind (videos)
@property (strong, nonatomic) IBOutlet UIButton *remindButton;
@property (strong, nonatomic) IBOutlet UIView *viewRemindVideos;
@property (strong, nonatomic) IBOutlet UIScrollView *viewRemindScrollVideos;

// Laugh (Dilbert RSS)
@property (strong, nonatomic) IBOutlet UIButton *laughButton;
@property (strong, nonatomic) IBOutlet UIView *viewRSSFeed;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong) NSMutableArray *allEntries;
@property (strong) NSMutableData *receivedData;
@property (strong, nonatomic) IBOutlet UIButton *prevButton_Dilbert;
@property (strong, nonatomic) IBOutlet UIButton *nextButton_Dilbert;
@property (strong, nonatomic) IBOutlet UILabel *nameDateDiblert;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *dilbertActivityIndicator;
- (IBAction)prevDilbert:(id)sender;
- (IBAction)nextDilbert:(id)sender;

// ProQOL Pocket Helper Card
@property (strong, nonatomic) IBOutlet UIButton *proqolButton;
@property (strong, nonatomic) IBOutlet UIView *viewProQOLHelper;

// ProQOL Graph
@property (strong, nonatomic) IBOutlet UIButton *graphButton;
@property (strong, nonatomic) IBOutlet UIView *viewProQOLGraph;

// Burnout Graph
@property (strong, nonatomic) IBOutlet UIButton *burnoutButton;

// ...and the Actions that initiate the above
- (IBAction)videoButton_Clicked:(id)sender;
- (IBAction)physicalButton_Clicked:(id)sender;
- (IBAction)remindButton_Clicked:(id)sender;
- (IBAction)laughButton_Clicked:(id)sender;
- (IBAction)proqolButton_Clicked:(id)sender;
- (IBAction)graphButton_Clicked:(id)sender;
- (IBAction)burnoutButton_Clicked:(id)sender;

// Select a video to play (based on the tag value)
- (IBAction)videoSelection_Clicked:(id)sender;

//Helps record view durations
-(void)switchView:(UIView*)view;

@end
