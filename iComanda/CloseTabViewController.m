//
//  CloseTabViewController.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 09/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CloseTabViewController.h"
#import "iComandaAppDelegate.h"

@implementation CloseTabViewController

@synthesize tabTotal, tabTip, tabSubTotal, tab;

- (id)init{
    [super initWithNibName:nil bundle:nil];
//    UIBarButtonItem *barBtnItem;
//    
//    //cancel btn
//    barBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
//    
//    [[self navigationItem] setLeftBarButtonItem:barBtnItem];
//    
//    [barBtnItem release];
    
    [[self tabBarItem] setImage:[UIImage imageNamed:@"calculator"]];
    [[self tabBarItem] setTitle:@"Fecha Conta"];

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void)dealloc
{
    [tabSubTotal release];
    [tabTip release];
    [tabTotal release];
    [tab release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Action methods;

- (IBAction) calculateValuePerPerson:(id)sender{
    
    [partyOfTextField resignFirstResponder];
    
    if([[partyOfTextField text] length] > 0){
        
        partyOf = [[partyOfTextField text] intValue];
        
        float perPersonTotalV = ([tabTotal floatValue]/partyOf) ;
        
        [perPersonTotal setText:[NSString stringWithFormat:@"R$%.2f",perPersonTotalV]];
        
        float perPersonSubV = [tabSubTotal floatValue]/partyOf;
        
        [perPersonSub setText:[NSString stringWithFormat:@"R$%.2f",perPersonSubV]];
    }else{
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Erro!" message:@"Você deve informar o número de pessoas!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
    }
    
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
    
    [calculateButton release];
    calculateButton = nil;
    
    [partyOfLabel release];
    partyOfLabel = nil;
    
    [partyOfTextField release];
    partyOfTextField = nil;
    
    [tabTotalLabel release];
    tabTotalLabel = nil;
    
    [tabSubTotalLabel release];
    tabSubTotalLabel = nil;
    
    [tabTipLabel release];
    tabTipLabel = nil;
    
    [perPersonSub release];
    perPersonSub = nil;
    
    [perPersonTotal release];
    perPersonTotal = nil;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    tab = [[iComandaAppDelegate sharedAppDelegate] selectedTabObject];
    
    NSArray *itemCounts = [tab valueForKey:@"itemCounts"] ;
    NSMutableArray *tabItemCountList = [[NSMutableArray alloc] init];
    for (NSManagedObject *itC in itemCounts){
        [tabItemCountList addObject:itC];
    }
    
    NSManagedObject *item;
    NSDecimalNumber *currentItemTotal;
    
    float totalValue = 0.0f;
    
    for (NSManagedObject *tabItem in tabItemCountList) {
        item = [tabItem valueForKey:@"item"];
        NSNumber *count = [tabItem valueForKey:@"count"];
        currentItemTotal = [item valueForKey:@"value"];
        totalValue += ([count intValue] * [currentItemTotal floatValue]);        
    }
    
    tabSubTotal = [[NSDecimalNumber alloc] initWithFloat:(totalValue)];
    
    tabTip = [[NSDecimalNumber alloc] initWithFloat:(totalValue*0.1f)];
    
    tabTotal = [[NSDecimalNumber alloc] initWithFloat:totalValue+[tabTip floatValue]];
    
    
    [tabTotalLabel setText:[NSString stringWithFormat:@"R$%.2f", [tabTotal floatValue]]];
    [tabSubTotalLabel setText:[NSString stringWithFormat:@"R$%.2f", [tabSubTotal floatValue]]];
    [tabTipLabel setText:[NSString stringWithFormat:@"R$%.2f", [tabTip floatValue]]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
