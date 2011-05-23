//
//  TabSettingViewController.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 15/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabSettingViewController.h"


@implementation TabSettingViewController

@synthesize label, limitValue;

- (id)init{
    [super initWithNibName:nil bundle:nil];
    
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

#pragma mark Action methods

- (IBAction)create:(id)sender{
    [self setLabel:[textField text]];
    [self setLimitValue:[NSDecimalNumber decimalNumberWithString:[limitValueField text] locale:[NSLocale currentLocale]]];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender{
    [self setLabel:nil];
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [textField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
