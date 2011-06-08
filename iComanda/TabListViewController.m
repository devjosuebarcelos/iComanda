//
//  TabListViewController.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 15/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabListViewController.h"
#import "iComandaAppDelegate.h"
#import "TabSettingViewController.h"
#import "ItemListViewController.h"

@implementation TabListViewController

static NSString *TAB_ENTITY = @"Tab";
static NSString *TAB_LABEL = @"label";
static NSString *LIMIT_ATT = @"limitValue";
static NSString *DATE_ATT = @"date";
static NSString *VENUEID_ATT = @"venueId";
static NSString *TIPCHARGED_ATT = @"isTipCharged";

- (id)init{
    self = [super initWithStyle:UITableViewStylePlain];
    
    iComandaAppDelegate *ac = [iComandaAppDelegate sharedAppDelegate];
    
    tabList = [[ac allInstancesOf:TAB_ENTITY orderedBy:DATE_ATT ascending:NO] mutableCopy];
    
    [self setTitle:@"Comandas"];
    [[self tabBarItem] setImage:[UIImage imageNamed:@"page"]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewTab:)];
    [[self navigationItem] setRightBarButtonItem:item];
    [item release];
    
    return  self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)dealloc
{
    [tabList release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark Action methods
- (void)createNewTab:(id)sender{
    tabSettingViewController = [[TabSettingViewController alloc] init];
    
    UINavigationController *tabSettingNavC = [[[UINavigationController alloc] initWithRootViewController:tabSettingViewController] autorelease];
    
    [self presentModalViewController:tabSettingNavC animated:YES];
    
    //tabSettingViewController will be released in viewWillAppear:
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //clear closeTabVC badge
    [[[[[self tabBarController] viewControllers] objectAtIndex:1] tabBarItem] setBadgeValue:nil];
    
    iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];
    [appDel setSelectedTabObject:nil];
    if(tabSettingViewController){
        NSString *label = [tabSettingViewController label];
        NSDecimalNumber *limitValue = [tabSettingViewController limitValue];
        NSString *lastCheckedInVenueId = [tabSettingViewController lastCheckedInVenueId];
        BOOL tipCharged = [tabSettingViewController isTipCharged];
        NSLog(@"lastCheckedInVenueId: %@",lastCheckedInVenueId);
        
        if([label length] > 0){
            
            NSManagedObjectContext *moc = [appDel managedObjectContext];
            
            NSManagedObject *tab;
            
            if(!selectedPath){
                tab = [NSEntityDescription insertNewObjectForEntityForName:TAB_ENTITY inManagedObjectContext:moc];
                [tab setValue:[NSDate date] forKey:DATE_ATT];
                
                [tabList addObject:tab];
                
            }else{
                tab = [tabList objectAtIndex:[selectedPath row]];
            }
            
            [tab setValue:label forKey:TAB_LABEL];
            [tab setValue:limitValue forKey:LIMIT_ATT];
            
            [tab setValue:lastCheckedInVenueId forKey:VENUEID_ATT];
            [tab setValue:[NSNumber numberWithBool:tipCharged ] forKey:TIPCHARGED_ATT];
            
            
            NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:DATE_ATT ascending:NO];
            NSArray *sds = [NSArray arrayWithObject:sd];
            [sd release];
            [tabList sortUsingDescriptors:sds];
            [[self tableView] reloadData];
            [appDel saveContext];
        }
        [tabSettingViewController release];
        tabSettingViewController = nil;
        [[self tableView] reloadData];
    }
    
    if(selectedPath){
        [[self tableView] deselectRowAtIndexPath:selectedPath animated:NO];
        [selectedPath release];
        selectedPath = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tabList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TabCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSManagedObject *tab = [tabList objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[tab valueForKey:TAB_LABEL]];
    
    [[cell detailTextLabel] setText:[NSNumberFormatter localizedStringFromNumber:[tab valueForKey:LIMIT_ATT] numberStyle:NSNumberFormatterCurrencyStyle]];
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push ItemListViewController;
    ItemListViewController *itemListVC = [[ItemListViewController alloc] init];
    
    NSManagedObject *tab = [tabList objectAtIndex:[indexPath row]];
    
    [itemListVC setTab:tab];
    
    [[self navigationController] pushViewController:itemListVC animated:YES];
    [itemListVC release];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSManagedObject *tab = [tabList objectAtIndex:[indexPath row]];
    
    tabSettingViewController = [[TabSettingViewController alloc] init];
    
    [tabSettingViewController setLabel:[tab valueForKey:@"label"]];
    [tabSettingViewController setLimitValue:[tab valueForKey:@"limitValue"]];
    [tabSettingViewController setLastCheckedInVenueId:[tab valueForKey:@"venueId"]];
    [tabSettingViewController setTipCharged:[[tab valueForKey:@"isTipCharged"] boolValue]];
    
    selectedPath = indexPath;

    
    [[self navigationController] pushViewController:tabSettingViewController animated:YES];
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];
        NSManagedObjectContext *moc = [appDel managedObjectContext];
        
        [moc deleteObject:[tabList objectAtIndex:[indexPath row]]];
        
        [tabList removeObjectAtIndex:[indexPath row]];
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:DATE_ATT ascending:YES];
        NSArray *sds = [NSArray arrayWithObject:sd];
        [sd release];
        [tabList sortUsingDescriptors:sds];
        
        [appDel saveContext];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    
    [tableView reloadData];
}

@end
