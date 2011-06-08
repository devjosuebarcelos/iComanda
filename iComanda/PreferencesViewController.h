//
//  PreferencesViewController.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Foursquare2.h"
#import "FoursquareWebLogin.h"


@interface PreferencesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *preferencesTableView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    FoursquareWebLogin *loginCon;
    
    NSDictionary *optionsDict;
    
}

-(void)authorizeWithViewController:(UIViewController*)controller
						  Callback:(Foursquare2Callback)callback;
-(void)setCode:(NSString*)code;


@end
