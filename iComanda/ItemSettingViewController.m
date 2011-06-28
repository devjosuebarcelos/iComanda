//
//  ItemSettingViewController.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 17/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemSettingViewController.h"


@implementation ItemSettingViewController

@synthesize label, value;

- (id)init{
    self = [super initWithNibName:nil bundle:nil];
    
    [self setTitle:NSLocalizedString(@"New Item", @"ItemSettingViewController:Title:New Item")];
    
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
    [labelTextField release];
    [label release];
    [value release];
    [valueTextField release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark Action methods

- (IBAction)create:(id)sender{
    
    if([[labelTextField text] length] > 0 && [[valueTextField text] length] > 0 && (![[valueTextField text] isEqualToString:[NSString localizedStringWithFormat:@"%.2f",0]])){
        [self setLabel:[labelTextField text]];
        [self setValue:[NSDecimalNumber decimalNumberWithString:[valueTextField text] locale:[NSLocale currentLocale]]];
        [[self navigationController] popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!", @"Alerts:Error:Title:Error!")
                                                         message:NSLocalizedString(@"You must set item's name and a value", @"ItemSettingViewController:Alerts:Error:Messages:Should set name and value") 
                                                        delegate:self 
                                               cancelButtonTitle:NSLocalizedString(@"OK", @"Alerts:Buttons:OK")
                                               otherButtonTitles:nil] autorelease];
        [alert show];
    }
    
}

- (IBAction)cancel:(id)sender{
    [self clearFields:sender];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)clearFields:(id)sender{
    [self setLabel:nil];
    [self setValue:nil];
    [labelTextField setText:nil];
    [valueTextField setText:nil];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([label length] > 0) {
        [self setTitle:label];
        [labelTextField setText:label];
        [valueTextField setText:[NSString localizedStringWithFormat:@"%.2f",[value floatValue]]];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [labelTextField release];
    labelTextField = nil;
    
    [valueTextField release];
    valueTextField = nil;
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [labelTextField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
