//
//  AboutViewController.h
//  ProviderResilience-iOS
//
//  Created by Brian Doherty on 5/8/12.
//  Copyright (c) 2012 T2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController <UIWebViewDelegate> {
    
    IBOutlet UIWebView *myWebView;
    
    IBOutlet UIButton *buttonProceed;
    BOOL bStartupMode;
    NSDate *startSession;

    
}

@property (nonatomic, strong) NSDate *startSession;

@property (strong, nonatomic) IBOutlet UIView *viewAbout;
@property (strong, nonatomic) IBOutlet UIButton *buttonAboutNext;

@property (strong, nonatomic) IBOutlet UIView *viewHintDash;
@property (strong, nonatomic) IBOutlet UIImageView *viewImageDash;
@property (strong, nonatomic) IBOutlet UIButton *buttonDashPrev;
@property (strong, nonatomic) IBOutlet UIButton *buttonDashNext;

@property (strong, nonatomic) IBOutlet UIView *viewHintCards;
@property (strong, nonatomic) IBOutlet UIImageView *viewImageCard;
@property (strong, nonatomic) IBOutlet UIButton *buttonCardPrev;
@property (strong, nonatomic) IBOutlet UIButton *buttonCardNext;


@property (nonatomic, strong) UIWebView *myWebView;
@property (strong, nonatomic) UIButton *buttonProceed;

- (void)loadHTML:(NSString *)fileName;
- (void)adjustPosition;


- (IBAction)buttonProceed_Clicked:(id)sender;
- (IBAction)buttonHintDash_Clicked:(id)sender;
- (IBAction)buttonHintCards_Clicked:(id)sender;
- (IBAction)buttonAbout_Clicked:(id)sender;

- (void)StartupMode;
@end
