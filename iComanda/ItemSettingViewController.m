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
    [super initWithNibName:nil bundle:nil];
    
    [self setTitle:@"Novo Item"];
    
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
    [self setLabel:[labelTextField text]];
    [self setValue:[NSDecimalNumber decimalNumberWithString:[valueTextField text] locale:[NSLocale currentLocale]]];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender{
    [self setLabel:nil];
    [self setValue:nil];
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([label length] > 0) {
        [self setTitle:label];
        [labelTextField setText:label];
        [valueTextField setText:[value stringValue]];
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
