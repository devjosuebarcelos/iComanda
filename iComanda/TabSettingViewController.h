//
//  TabSettingViewController.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 15/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TabSettingViewController : UIViewController {
    NSString *label;
    NSDecimalNumber *limitValue;
    NSString *lastCheckedInVenueId;
    BOOL tipCharged;
    
    IBOutlet UITextField *textField;
    IBOutlet UITextField *limitValueField;
    IBOutlet UIButton *getLastCheckinButton;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UISwitch *switchTipOnOff;
    IBOutlet UIButton *clearFieldsButton;
    
    
}

@property (nonatomic, copy) NSString *label;
@property (nonatomic, retain) NSDecimalNumber *limitValue;
@property (nonatomic, copy) NSString *lastCheckedInVenueId;
@property (nonatomic, getter = isTipCharged) BOOL tipCharged;

- (IBAction)create:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)clearFields:(id)sender;
- (IBAction)getLastCheckin:(id)sender;

- (void)startStopActivity:(BOOL)start;

@end
