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
#import "Item.h"
#import "Tab.h"
#import "ItemCountEntity.h"

@implementation ItemListViewController


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

- (void)setTab:(Tab *)t{
    [t retain];
    [tab release];
    tab = t;
    
    [[iComandaAppDelegate sharedAppDelegate] setSelectedTabObject:tab];
    
    [self setTitle:[t label]];
    
    NSArray *itemCounts = [[t itemCounts] allObjects];
    selectedItems = [[NSMutableArray alloc] init];
    for(ItemCountEntity *itC in itemCounts){
        [selectedItems addObject:[itC item]];
    }
    
}


- (void)dealloc
{
    [tab release];
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

}



- (void)updateInterface{
    
    Item *item;
    NSDecimalNumber *currentItemTotal;
    
    float totalValue = 0.0f;
    
    for(ItemCountEntity *tabItem in [tab itemCounts]){
        item = [tabItem item];
        NSNumber *count = [tabItem count];
        currentItemTotal = [item value];
        totalValue += ([count intValue] * [currentItemTotal floatValue]);        
    }
    
    float tipTotal = [[tab isTipCharged] boolValue] ?totalValue*0.1f:0;
    
    float tabTotal = totalValue+tipTotal;
    
    NSLog(@"%f",totalValue);
    NSLog(@"%f",tipTotal);
    NSLog(@"%f",tabTotal);
    
    NSDecimalNumber *tabLimit = [tab limitValue];
    
    
    float percentage = (totalValue/[tabLimit floatValue])*100;
    NSString *difference = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:([tabLimit floatValue] - totalValue)] numberStyle:NSNumberFormatterCurrencyStyle];
    
    if(percentage < 75){
        [[[[[self tabBarController] viewControllers] objectAtIndex:1] tabBarItem] setBadgeValue:nil];
    }else if(percentage >= 75){
        [[[[[self tabBarController] viewControllers] objectAtIndex:1] tabBarItem] setBadgeValue:difference];
    }
    
    [[self view] setNeedsDisplay];
    
    
    //Internationalize it
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
        NSMutableArray *selectedItemsFromView = [itemsListViewController selectedItems];
                
        iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];
        for (Item *item in selectedItemsFromView){
            if(![selectedItems containsObject:item]){
                
                NSManagedObjectContext *moc = [appDel managedObjectContext];
                
                ItemCountEntity *tabItem = [NSEntityDescription insertNewObjectForEntityForName:[[ItemCountEntity class] description] inManagedObjectContext:moc];
                
                [tabItem setTab:tab];
                [tabItem setItem:item];
                [tabItem setCount:[NSNumber numberWithInt:1]];
                
                [selectedItems addObject:item];
                [appDel saveContext];
            }
        }
        //verify an item was deselected from prev view
        NSMutableArray *tabItemsToDel = [[[NSMutableArray alloc] init] autorelease];
        for(Item *item in selectedItems){
            if(![selectedItemsFromView containsObject:item]){
                [tabItemsToDel addObject:[item itemCounts]];
            }
        }
        
        for(ItemCountEntity *tabItemToDel in tabItemsToDel){
            [self removeTabItemCount:tabItemToDel];
        }
        
        
        [itemsListViewController release];
        itemsListViewController = nil;
    }
    if(tabItemCountViewController){
        int count = [tabItemCountViewController itemCountValue];
        iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];
            
        ItemCountEntity *tabItemCount = [[[tab itemCounts] allObjects] objectAtIndex:[selectedPath row]];
            
        [tabItemCount setCount:[NSNumber numberWithInt:count]];
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
    //it will be released after setting accessory view of the cells
    return countsImgs;
}

#pragma mark table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    ItemCountEntity *itemCount = [[[tab itemCounts] allObjects] objectAtIndex:[indexPath row]];
    
    Item *item = [itemCount item];
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@",[item label]]];
    
    //set item value as subtitle
    [[cell detailTextLabel] setText:[NSNumberFormatter localizedStringFromNumber:[item value] numberStyle:NSNumberFormatterCurrencyStyle]];
    
    UIImageView *countImages = [self createImagesForCount:[[itemCount count] intValue] inView:cell];
    
    [cell setAccessoryView:countImages];

    //object allocated in createImagesForCount: and not released
    [countImages release];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[tab itemCounts] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push TabItemCountViewController
    tabItemCountViewController = [[TabItemCountViewController alloc] init];
    
    ItemCountEntity *tabItemCount = [[[tab itemCounts] allObjects] objectAtIndex:[indexPath row]];
    Item *it = [tabItemCount item];
    
    [tabItemCountViewController setItemLabelValue:[it label]];
    
    [tabItemCountViewController setItemCountValue:[[tabItemCount count] intValue]];
    
    
    [[self navigationController] pushViewController:tabItemCountViewController animated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        ItemCountEntity *tabItemToDel = [ [[tab itemCounts] allObjects] objectAtIndex:[indexPath row]];

        //remove item from selectedItems
        [self removeTabItemCount:tabItemToDel];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self updateInterface];
    }
}

- (void)removeTabItemCount:(ItemCountEntity *)tabItemToDel{
    [selectedItems removeObject:[tabItemToDel item] ];
    iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];
    NSManagedObjectContext *moc = [appDel managedObjectContext];
    [moc deleteObject:tabItemToDel];
    [appDel saveContext];
}

@end
