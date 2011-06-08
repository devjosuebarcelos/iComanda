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
static NSString *ITEMCOUNT_ATT = @"itemCounts";
static NSString *TAB_ATT = @"tab";
static NSString *LIMIT_ATT = @"limitValue";
static NSString *TIPCHARGED_ATT = @"isTipCharged";


- (id)init{
    self = [super initWithNibName:nil bundle:nil];
    
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(createNewItem:)];
    
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
    [subTotal release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Action methods

- (void)createNewItem:(id)sender{
    //ItemSettingsViewController
    itemsListViewController = [[ItemsListViewController alloc] init];
    [itemsListViewController setTab:tab];
    [itemsListViewController setSelectedItems:selectedItems];
    UINavigationController *itemsListNavVC = [[[UINavigationController alloc] initWithRootViewController:itemsListViewController] autorelease];
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
    
    float tipTotal = [[tab valueForKey:TIPCHARGED_ATT] boolValue] ?totalValue*0.1f:0;
    
    float tabTotal = totalValue+tipTotal;
    
    NSLog(@"%f",totalValue);
    NSLog(@"%f",tipTotal);
    NSLog(@"%f",tabTotal);
    
    NSDecimalNumber *tabLimit = [tab valueForKey:LIMIT_ATT];
    
    
    float percentage = (totalValue/[tabLimit floatValue])*100;
    NSString *difference = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:([tabLimit floatValue] - totalValue)] numberStyle:NSNumberFormatterCurrencyStyle];
    
    if(percentage > 75 && percentage <= 90){
//       [[[[[self tabBarController] viewControllers] objectAtIndex:1] tabBarItem] setBadgeValue:difference];
    }else if(percentage > 90 && percentage <= 100){
//        [[[[[self tabBarController] viewControllers] objectAtIndex:1] tabBarItem] setBadgeValue:difference];
    }else if(percentage > 100){
        [[[[[self tabBarController] viewControllers] objectAtIndex:1] tabBarItem] setBadgeValue:difference];
    }else{
        [[[[[self tabBarController] viewControllers] objectAtIndex:1] tabBarItem] setBadgeValue:nil];
    }
    
    [[self view] setNeedsDisplay];
    
    
    //Internacionalizar label
    [subTotal setText:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:totalValue] numberStyle:NSNumberFormatterCurrencyStyle]];
    
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
    
    [subTotal release];
    subTotal = nil;
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
                [tabItem setValue:[NSNumber numberWithInt:1] forKey:COUNT_ATT];
                
                NSLog(@"%@",tabItem);
                [tabItemCountList addObject:tabItem];
                [selectedItems addObject:item];
                [appDel saveContext];
            }
        }
        //verify an item was deselected from prev view
        NSMutableArray *tabItemsToDel = [[[NSMutableArray alloc] init] autorelease];
        for(NSManagedObject *item in selectedItems){
            if(![selectedItemsFromView containsObject:item]){
                [tabItemsToDel addObject:[item valueForKey:ITEMCOUNT_ATT]];
            }
        }
        
        for (NSManagedObject *tabItemToDel in tabItemsToDel){
            [self removeTabItemCount:tabItemToDel];
        }
        
        
        [itemsListViewController release];
        itemsListViewController = nil;
    }
    if(tabItemCountViewController){
        int count = [tabItemCountViewController itemCountValue];
        iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];
            
        NSManagedObject *tabItemCount = [tabItemCountList objectAtIndex:[selectedPath row]];
            
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

- (UIImageView *)createImagesForCount:(int)count inView:(UIView *)view{
    
    //setting how many imageView will be placed
    int imgViewsCount = ((count+4)/5);
    
    //creating frame where the imgs will be placed
    CGRect frame = CGRectMake(0, 0, (imgViewsCount*36)+8, view.bounds.size.height-10);
    
    //alloc main UIImageView
    //potential leak = released after setting in cell accessoryView
    UIImageView *countsImgs = [[UIImageView alloc] initWithFrame:frame];
    
    UIImageView *countSubView;
    
    //make innerFrame
    CGRect innerFrame = CGRectMake(0,0, 36, frame.size.height);
    
    for (int index = 0; index < imgViewsCount; index++){
        //alloc sub UIImageView
        countSubView = [[UIImageView alloc] initWithFrame:innerFrame];
        //setting the image name
        NSString *imageName;
        if(imgViewsCount - index > 1){
            imageName = @"count_5";
        }else{
            imageName = [NSString stringWithFormat:@"count_%d", count-((imgViewsCount-1)*5)];
        }
        
        //setting proper count image
        [countSubView setImage:[UIImage imageNamed:imageName]];
        [countsImgs addSubview:countSubView];
        
        //release this subview
        [countSubView release];
        
        //moving frame.origin.x to the right for the next image
        innerFrame.origin.x += 36;
    }
    
    return countsImgs;
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
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@",[item valueForKey:LABEL_ATT]]];
    
    //set item value as subtitle
    [[cell detailTextLabel] setText:[NSNumberFormatter localizedStringFromNumber:[item valueForKey:VALUE_ATT] numberStyle:NSNumberFormatterCurrencyStyle]];
    
    UIImageView *countImages = [self createImagesForCount:[[itemCount valueForKey:COUNT_ATT] intValue] inView:cell];
    
    [cell setAccessoryView:countImages];

    [countImages release];
    
//    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
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
    
    
    [[self navigationController] pushViewController:tabItemCountViewController animated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        NSManagedObject *tabItemToDel = [tabItemCountList objectAtIndex:[indexPath row]];

        //remove item from selectedItems
        [self removeTabItemCount:tabItemToDel];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self updateInterface];
    }
}

- (void)removeTabItemCount:(NSManagedObject *)tabItemToDel{
    [selectedItems removeObject:[tabItemToDel valueForKey:ITEM_ATT] ];
    iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];
    NSManagedObjectContext *moc = [appDel managedObjectContext];
    [moc deleteObject:tabItemToDel];
    [appDel saveContext];
    [tabItemCountList removeObject:tabItemToDel];
}

@end
