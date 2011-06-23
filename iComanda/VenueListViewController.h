//
//  VenueListViewController.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 13/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface VenueListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, CLLocationManagerDelegate>{
    
    IBOutlet UITableView *venueTableView;
    IBOutlet UIActivityIndicatorView *activityIndicator;

    
    
    NSMutableDictionary *venueList;
    NSMutableDictionary *filteredVenueList;
    
    CLLocationManager *locationManager;
    
    BOOL searchIsActive;
    
}

@property (nonatomic, retain) NSMutableDictionary *venueList;
@property (nonatomic, retain) NSMutableDictionary *filteredVenueList;
@property (nonatomic) BOOL searchIsActive;

- (void)verifyLocationStatus;
- (void)callSearchVenueWithQuery:(NSString *)query intent:(NSString *)intent;
- (void)refreshList:(id)sender;

@end
