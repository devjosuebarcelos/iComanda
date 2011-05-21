//
//  ItemListViewController.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 16/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemListViewController.h"
#import "iComandaAppDelegate.h"
#import "ItemsListViewController.h"
#import "TabItemCountViewController.h"
#import "CloseTabViewController.h"

@implementation ItemListViewController

static NSString *ITEMCOUNT_ENTITY = @"ItemCount";
static NSString *LABEL_ATT = @"label";
static NSString *VALUE_ATT = @"value";
static NSString *COUNT_ATT = @"count";
static NSString *ITEM_ATT = @"item";
static NSString *TAB_ATT = @"tab";
//static NSString *LIMIT_ATT = @"limitValue";


- (id)init{
    [super initWithNibName:nil bundle:nil];
    
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewItem:)];
    
    [[self navigationItem] setRightBarButtonItem:item];
    [item release];

    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void)setTab:(NSManagedObject *)t{
    [t retain];
    [tab release];
    tab = t;
    
    [[iComandaAppDelegate sharedAppDelegate] setSelectedTabObject:tab];
    
    [self setTitle:[t valueForKey:LABEL_ATT]];
    
    NSArray *itemCounts = [t valueForKey:@"itemCounts"] ;
    tabItemCountList = [[NSMutableArray alloc] init];
    selectedItems = [[NSMutableArray alloc] init];
    for (NSManagedObject *itC in itemCounts){
        [tabItemCountList addObject:itC];
        [selectedItems addObject:[itC valueForKey:ITEM_ATT]];
    }

}

- (void)dealloc
{
    [tab release];
    [tabItemCountList release];
    [selectedItems release];
    [total release];
    [subTotal release];
    [tip release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Action methods

- (IBAction)closeTabAction:(id)sender{
    //CloseTabViewController
    closeTabViewController = [[CloseTabViewController alloc] init];
    
    //set tab values
    [closeTabViewController setTab:tab];
    
    NSManagedObject *item;
    NSDecimalNumber *currentItemTotal;
    
    float totalValue = 0.0f;
    
    for (NSManagedObject *tabItem in tabItemCountList) {
        item = [tabItem valueForKey:ITEM_ATT];
        NSNumber *count = [tabItem valueForKey:COUNT_ATT];
        currentItemTotal = [item valueForKey:VALUE_ATT];
        totalValue += ([count intValue] * [currentItemTotal floatValue]);        
    }
    
    NSDecimalNumber *tabSub = [[NSDecimalNumber alloc] initWithFloat:(totalValue)];
    
    NSDecimalNumber *tipTotal = [[NSDecimalNumber alloc] initWithFloat:(totalValue*0.1f)];
    
    NSDecimalNumber *tabTotal = [[NSDecimalNumber alloc] initWithFloat:totalValue+[tipTotal floatValue]];
    
    [closeTabViewController setTabSubTotal:tabSub];
    [closeTabViewController setTabTip:tipTotal];
    [closeTabViewController setTabTotal:tabTotal];
    
    
    
    [[self navigationController] pushViewController:closeTabViewController animated:YES];
    
}

- (void)createNewItem:(id)sender{
    //ItemSettingsViewController
    itemsListViewController = [[ItemsListViewController alloc] init];
    [itemsListViewController setTab:tab];
    [itemsListViewController setSelectedItems:selectedItems];
    UINavigationController *itemsListNavVC = [[UINavigationController alloc] initWithRootViewController:itemsListViewController];
    [self presentModalViewController:itemsListNavVC animated:YES];

//    [[self navigationController] pushViewController:itemsListViewController animated:YES];
}



- (void)updateInterface{
    
    NSManagedObject *item;
    NSDecimalNumber *currentItemTotal;
    
    float totalValue = 0.0f;
    
    for (NSManagedObject *tabItem in tabItemCountList) {
        item = [tabItem valueForKey:ITEM_ATT];
        NSNumber *count = [tabItem valueForKey:COUNT_ATT];
        currentItemTotal = [item valueForKey:VALUE_ATT];
        totalValue += ([count intValue] * [currentItemTotal floatValue]);        
    }
    
    float tipTotal = totalValue*0.1f;
    
    float tabTotal = totalValue+tipTotal;
    
    NSLog(@"%f",totalValue);
    NSLog(@"%f",tipTotal);
    NSLog(@"%f",tabTotal);
    
//    NSDecimalNumber *tabLimit = [tab valueForKey:LIMIT_ATT];
    
//    float percentage = (totalValue/[tabLimit floatValue])*100;
    
//    if(percentage > 75 && percentage < 90){
//        [[self view] setBackgroundColor:[UIColor yellowColor]];
//    }else if(percentage > 90){
//        [[self view] setBackgroundColor:[UIColor redColor]];
//    }else{
//        [[self view] setBackgroundColor:[UIColor clearColor]];
//    }
    
//    [[self view] setNeedsDisplay];
    
    [subTotal setText:[NSString stringWithFormat:@"R$%.2f",totalValue]];
    [tip setText:[NSString stringWithFormat:@"R$%.2f",tipTotal]];
    [total setText:[NSString stringWithFormat:@"R$%.2f",tabTotal]];
    
    [itemsTableView reloadData];
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
    
    [total release];
    total = nil;
    
    [subTotal release];
    total = nil;
    
    [tip release];
    tip = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *selectedPath = [itemsTableView indexPathForSelectedRow];
    
    if(itemsListViewController){
//        NSManagedObject *item = [itemsListViewController selectedItem];
        NSMutableArray *selectedItemsFromView = [itemsListViewController selectedItems];
                
        //NSLog(@"%@",item);
        iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];
        for (NSManagedObject *item in selectedItemsFromView){
            if(![selectedItems containsObject:item]){
                
                NSManagedObjectContext *moc = [appDel managedObjectContext];
                
                NSManagedObject *tabItem = [NSEntityDescription insertNewObjectForEntityForName:ITEMCOUNT_ENTITY inManagedObjectContext:moc];
                
                [tabItem setValue:tab forKey:TAB_ATT];
                [tabItem setValue:item forKey:ITEM_ATT];            
                [tabItem setValue:[NSNumber numberWithInt:0] forKey:COUNT_ATT];
                
                NSLog(@"%@",tabItem);
                [tabItemCountList addObject:tabItem];
                [selectedItems addObject:item];
                [appDel saveContext];
            }
        }
        
        [itemsListViewController release];
        itemsListViewController = nil;
    }
    if(tabItemCountViewController){
        int count = [tabItemCountViewController itemCountValue];
        iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];
            
        NSManagedObject *tabItemCount = [tabItemCountList objectAtIndex:[selectedPath row]];
            
        NSLog(@">>>>>>>>>>>>>>>>>> %@",tabItemCount);
          
        [tabItemCount setValue:[NSNumber numberWithInt:count] forKey:COUNT_ATT];
        [appDel saveContext];
            
        [tabItemCountViewController release];
        tabItemCountViewController = nil;
        

    }

    
    
    [self updateInterface];
    NSLog(@"selectedPath: %@",selectedPath);
    if(selectedPath){
        [itemsTableView deselectRowAtIndexPath:selectedPath animated:NO];
    }
}


- (void)blankAllObjects{
    
    [selectedItems release];
    selectedItems = nil;
    
    
    [tabItemCountList release];
    tabItemCountList = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSManagedObject *itemCount = [tabItemCountList objectAtIndex:[indexPath row]];
    NSManagedObject *item = [itemCount valueForKey:ITEM_ATT];
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@",[item valueForKey:LABEL_ATT], [itemCount valueForKey:@"count"]]];
    
    //set item value as subtitle
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"R$%@",[item valueForKey:VALUE_ATT]]];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tabItemCountList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push TabItemCountViewController
    tabItemCountViewController = [[TabItemCountViewController alloc] init];
    
    NSManagedObject *tabItemCount = [tabItemCountList objectAtIndex:[indexPath row]];
    NSManagedObject *it = [tabItemCount valueForKey:ITEM_ATT];
    
    [tabItemCountViewController setItemLabelValue:[it valueForKey:LABEL_ATT]];
    
    NSNumber *count = [tabItemCount valueForKey:COUNT_ATT];
    [tabItemCountViewController setItemCountValue:[count intValue]];
    
    NSLog(@"%@", tabItemCount);
    
    [[self navigationController] pushViewController:tabItemCountViewController animated:YES];

}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
//    //push TabItemCountViewController
//    tabItemCountViewController = [[TabItemCountViewController alloc] init];
//    NSManagedObject *tabItemCount = [tabItemCountList objectAtIndex:[indexPath row]];
//    NSManagedObject *it = [tabItemCount valueForKey:ITEM_ATT];
//    
//    [tabItemCountViewController setItemLabelValue:[it valueForKey:LABEL_ATT]];
//
//    NSNumber *count = [tabItemCount valueForKey:COUNT_ATT];
//    [tabItemCountViewController setItemCountValue:[count intValue]];
//    
//    NSLog(@"%@", tabItemCount);
//    
//    [itemsTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    
//    [[self navigationController] pushViewController:tabItemCountViewController animated:YES];
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        NSManagedObject *tabItemToDel = [tabItemCountList objectAtIndex:[indexPath row]];

        //remove item from selectedItems
        [selectedItems removeObject:[tabItemToDel valueForKey:ITEM_ATT] ];
        iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];
        NSManagedObjectContext *moc = [appDel managedObjectContext];
        [moc deleteObject:tabItemToDel];
        [appDel saveContext];
        
        
        [tabItemCountList removeObject:tabItemToDel];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self updateInterface];
    }
}

@end
