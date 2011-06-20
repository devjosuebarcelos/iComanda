//
//  VenueDetailViewController.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 19/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueDetailViewController : UIViewController{
    
    IBOutlet UILabel *venueNameLabel;
    IBOutlet UILabel *venueAddressLabel;
    IBOutlet UILabel *venuePhoneLabel;
    IBOutlet UILabel *peopleCountLabel;
    
    IBOutlet UISwitch *switchAddAsTab;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    IBOutlet UIButton *checkInButton;
    
    
    NSDictionary *venue;
    
}

@property (nonatomic, retain) NSDictionary *venue;


- (IBAction)checkInHere:(id)sender;


@end
