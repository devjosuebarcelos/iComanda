//
//  VenueListViewController.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 13/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface VenueListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, CLLocationManagerDelegate>{
    
    IBOutlet UITableView *venueTableView;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    NSMutableDictionary *venueList;
    NSMutableDictionary *filteredVenueList;
    
    CLLocationManager *locationManager;
    
    BOOL searchIsActive;
    
    
    //refresh view
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
}

@property (nonatomic, retain) NSMutableDictionary *venueList;
@property (nonatomic, retain) NSMutableDictionary *filteredVenueList;
@property (nonatomic) BOOL searchIsActive;

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;


- (void)verifyLocationStatus;
- (void)callSearchVenueWithQuery:(NSString *)query intent:(NSString *)intent;
- (void)refreshList:(id)sender;

@end
