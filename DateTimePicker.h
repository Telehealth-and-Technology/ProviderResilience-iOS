//
//  DateTimePicker.h
//

@class DateTimePicker;

@protocol DateTimePickerDelegate < NSObject >

- (void)dateTimePickerOK:(DateTimePicker *)controller didPickDate:(NSDate *)date;
- (void)dateTimePickerCancel:(DateTimePicker *)controller;

@end

#import <UIKit/UIKit.h>

@interface DateTimePicker : UIViewController 
{
    IBOutlet UIDatePicker *datePicker;
    id < DateTimePickerDelegate > __weak delegate;
	NSDate *defaultDate;
    
    UIDatePickerMode ourMode;
}

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, weak) id < DateTimePickerDelegate > delegate;
@property (nonatomic, strong) NSDate *defaultDate;

- (IBAction)savePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

- (void)resetDatePickerMode:(UIDatePickerMode)newMode;

@end
