//
//  TabSettingViewController.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 15/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabSettingViewController.h"
#import "Foursquare2.h"


@implementation TabSettingViewController

@synthesize label, limitValue, lastCheckedInVenueId, tipCharged;

- (id)init{
    self = [super initWithNibName:nil bundle:nil];
    
    [self setTitle:@"Nova Comanda"];
    
    UIBarButtonItem *barBtnItem;
    
    //done btn
    barBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(create:)];
    
    [[self navigationItem] setRightBarButtonItem:barBtnItem];
    [barBtnItem release];
    
    //cancel btn
    barBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    [[self navigationItem] setLeftBarButtonItem:barBtnItem];
    
    [barBtnItem release];
    
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void)dealloc
{
    [textField release];
    [label release];
    [lastCheckedInVenueId release];
    [getLastCheckinButton release];
    [activityIndicator release];
    [switchTipOnOff release];
    [limitValue release];
    [limitValueField release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setLastCheckin:(NSDictionary *)result{
    NSDictionary *response = [result valueForKey:@"response"];
    NSDictionary *checkins = [response valueForKey:@"checkins"];
    NSArray *items = [checkins valueForKey:@"items"];
    NSDictionary *item = [items objectAtIndex:0];
    NSDictionary *venue = [item valueForKey:@"venue"];
    
    [self setLastCheckedInVenueId:[venue valueForKey:@"id"]];
    
    [textField setText:[venue valueForKey:@"name"]];
    
    [self startStopActivity:NO];

}

- (void)startStopActivity:(BOOL)start{
    if(start){
        [activityIndicator startAnimating];
    }else{
        [activityIndicator stopAnimating];
    }
    [textField setEnabled:!start];
    [getLastCheckinButton setEnabled:!start];
}

#pragma mark Action methods

- (IBAction)create:(id)sender{
    if([[textField text] length] > 0){
        [self setLabel:[textField text]];
        
        if([[limitValueField text] length] == 0){
            [limitValueField setText:@"0"];
        }
        
        [self setLimitValue:[NSDecimalNumber decimalNumberWithString:[limitValueField text] locale:[NSLocale currentLocale]]];
        [self setTipCharged:[switchTipOnOff isOn]];
        
        
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
        
        [[self navigationController] popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Erro" message:@"Você deve informar o nome do lugar!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        
    }
}

- (IBAction)cancel:(id)sender{
    [self clearFields:sender];
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)clearFields:(id)sender{
    [self setLabel:nil];
    [self setLimitValue:nil];
    [self setLastCheckedInVenueId:nil];
    [textField setText:nil];
    [limitValueField setText:nil];
    [switchTipOnOff setOn:NO];
    
}

- (IBAction)getLastCheckin:(id)sender{
    [Foursquare2  getCheckinsByUser:@"self" limit:@"1" offset:@"" afterTimestamp:@"" beforeTimestamp:@"" callback:^(BOOL success, id result){
                              if (success) {
                                  [self setLastCheckin:result];
                              }
                          }];
    [self startStopActivity:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [textField setText:label];
    
//    [limitValueField setText:[NSString localizedStringWithFormat:@"%.2f",[limitValue floatValue]] ];
    [switchTipOnOff setOn:tipCharged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [textField release];
    textField = nil;
    
    [limitValueField release];
    limitValueField = nil;
    
    [getLastCheckinButton release];
    getLastCheckinButton = nil;
    
    [activityIndicator release];
    activityIndicator = nil;
    
    [switchTipOnOff release];
    switchTipOnOff = nil;
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [textField becomeFirstResponder];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [getLastCheckinButton setHidden:[Foursquare2 isNeedToAuthorize]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
