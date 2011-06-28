//
//  CloseTabViewController.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 09/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CloseTabViewController.h"
#import "iComandaAppDelegate.h"
#import "Item.h"
#import "Tab.h"
#import "ItemCountEntity.h"

@implementation CloseTabViewController


@synthesize tabTotal, tabTip, tabSubTotal, tab;

- (id)init{
    self = [super initWithNibName:nil bundle:nil];
    
    [[self tabBarItem] setImage:[UIImage imageNamed:@"calculator"]];
    
    [[self tabBarItem] setTitle:NSLocalizedString(@"Split The Bill", @"CloseTabViewController:Title:CloseTab")];

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
    
    if(partyOf > 0){
        
        float perPersonTotalV = ([tabTotal floatValue]/partyOf) ;
        
        [perPersonTotal setText:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:perPersonTotalV ] numberStyle:NSNumberFormatterCurrencyStyle]];
        
        float perPersonSubV = [tabSubTotal floatValue]/partyOf;
        
        [perPersonSub setText:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:perPersonSubV ] numberStyle:NSNumberFormatterCurrencyStyle]];
    }else{
        [perPersonTotal setText:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:0] numberStyle:NSNumberFormatterCurrencyStyle]];
        
        [perPersonSub setText:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:0] numberStyle:NSNumberFormatterCurrencyStyle]];        
    }
    
}

- (IBAction)tipSlideValueChaged:(id)sender{
    [self updateInterface];
}

- (void)updateInterface{
    int tipPercentage = [tipPercentageSlider value]*100;
    
    [tipPercentageLabel setText:[NSString stringWithFormat:@"%d%%",  tipPercentage]];
    
    Item *item;
    NSDecimalNumber *currentItemTotal;
    
    float totalValue = 0.0f;
    
    for(ItemCountEntity *tabItem in [[tab itemCounts] allObjects]){
        item = [tabItem item];
        NSNumber *count = [tabItem valueForKey:@"count"];
        currentItemTotal = [item value];
        totalValue += ([count intValue] * [currentItemTotal floatValue]);        
    }
    
    
    [self setTabSubTotal:[[[NSDecimalNumber alloc] initWithFloat:(totalValue)] autorelease] ];
    
    [self setTabTip:[[[NSDecimalNumber alloc] initWithFloat:([[tab isTipCharged] boolValue] ?totalValue*(tipPercentage/100.0f):0)] autorelease] ];
    
    [self setTabTotal:[[[NSDecimalNumber alloc] initWithFloat:totalValue+[tabTip floatValue]] autorelease] ];
    
    //Internacionalizar label
    [tabTotalLabel setText:[NSNumberFormatter localizedStringFromNumber:tabTotal numberStyle:NSNumberFormatterCurrencyStyle]];
    
    //Internacionalizar label
    [tabSubTotalLabel setText:[NSNumberFormatter localizedStringFromNumber:tabSubTotal numberStyle:NSNumberFormatterCurrencyStyle]];
    
    //Internacionalizar label
    [tabTipLabel setText:[NSNumberFormatter localizedStringFromNumber:tabTip numberStyle:NSNumberFormatterCurrencyStyle]];
}

#pragma mark pickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}

#pragma mark pickerView delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0){
        partyOfDozen = row;
    }else if(component == 1){
        partyOfUnit = row;
    }
    
    partyOf = (partyOfDozen*10)+partyOfUnit;
    
    [self calculateValuePerPerson:nil];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [NSString stringWithFormat:@"%d",row];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [perPersonSub setText:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:0.0 ] numberStyle:NSNumberFormatterCurrencyStyle]];
    [perPersonTotal setText:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:0.0 ] numberStyle:NSNumberFormatterCurrencyStyle]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
        
    [partyOfLabel release];
    partyOfLabel = nil;
    
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
    
    [tipPercentageLabel release];
    tipPercentageLabel = nil;
    
    [tipPercentageSlider release];
    tipPercentageSlider = nil;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    tab = [[iComandaAppDelegate sharedAppDelegate] selectedTabObject];
    
    [tipPercentageSlider setEnabled:[[tab isTipCharged] boolValue]];
    
    [self tipSlideValueChaged:nil];
    
    [partyOfPicker selectRow:0 inComponent:0 animated:YES];
    [self pickerView:partyOfPicker didSelectRow:0 inComponent:0];
    [partyOfPicker selectRow:0 inComponent:1 animated:YES];
    [self pickerView:partyOfPicker didSelectRow:0 inComponent:1];
    
    [self updateInterface];
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
