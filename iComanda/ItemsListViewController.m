//
//  ItemsListViewController.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 27/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemsListViewController.h"
#import "iComandaAppDelegate.h"
#import "ItemSettingViewController.h"
#import "Item.h"
#import "Tab.h"


@implementation ItemsListViewController
@synthesize selectedItem, selectedItems, tab;

- (id)init{
    self = [super initWithNibName:nil bundle:nil];
    //before separate tab/item
    
    [self setTitle:NSLocalizedString(@"Menu", @"ItemsListViewController:Title:Menu")];
        
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewItem:)];
    [[self navigationItem] setRightBarButtonItem:item];
    [item release];
    
    item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancel:)];
    [[self navigationItem] setLeftBarButtonItem:item];
    [item release];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void)dealloc
{
    [selectedItem release];
    [selectedItems release];
    [selectedPath release];
    [tab release];
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
    itemSettingViewController = [[ItemSettingViewController alloc] init];
    [[self navigationController] pushViewController:itemSettingViewController animated:YES];
}

- (void)cancel:(id)sender{
    [self setSelectedItem:nil];
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)setSelectedItems:(NSMutableArray *)selItems{
    [selectedItems release];
    selectedItems = [[NSMutableArray alloc] initWithArray:selItems];
    
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(itemSettingViewController){
        

        iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];

        NSString *label = [itemSettingViewController label];
        NSDecimalNumber *value = [itemSettingViewController value];
        
        if(label && value){
            Item *item;
            if(!selectedPath){
                NSManagedObjectContext *moc = [appDel managedObjectContext];
                
                item = [NSEntityDescription insertNewObjectForEntityForName:[[Item class] description] inManagedObjectContext:moc];

                [item setTab:tab];
                
                
            }else{
                item = [[[tab items] allObjects] objectAtIndex:[selectedPath row]];
                
            }
            
            
            
            [item setLabel:label];
            [item setValue:value];
            
            
            NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:[Item labelAtt] ascending:YES];
            NSArray *sds = [NSArray arrayWithObject:sd];
            [sd release];
            [[tab items] sortedArrayUsingDescriptors:sds];
            [appDel saveContext];

        }
        [itemSettingViewController release];
        itemSettingViewController = nil;
        [[self tableView] reloadData];
        
    }
    
    
    
    if(selectedPath){
        [[self tableView] deselectRowAtIndexPath:selectedPath animated:NO];
        [selectedPath release];
        selectedPath = nil;
    }
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Item *item = [[[tab items] allObjects] objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@",[item label], [NSNumberFormatter localizedStringFromNumber:[item value] numberStyle:NSNumberFormatterCurrencyStyle]   ]];
    
    
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    
    //verify if the item for this cell already exists in selectedItems
    if([selectedItems containsObject:item]){
        [[cell textLabel] setAlpha:0.5];
        [[cell imageView] setImage:[UIImage imageNamed:@"selected"]];
    }else{
        [[cell textLabel] setAlpha:1];
        [[cell imageView] setImage:[UIImage imageNamed:@"unselected"]];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[tab items] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [[[tab items] allObjects] objectAtIndex:[indexPath row]];
    
    if(![selectedItems containsObject:item]){
        
        [selectedItems addObject:item];
        [tableView reloadData];
    }else{
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning!", @"Alerts:Warning:Title:Warning!")
                                                         message:NSLocalizedString(@"Whether you uncheck this item its counting information will also be deleted! Would you like to proceed?", @"ItemSettingViewController:Alerts:Warning:Messages:Uncheck item deletes its count") 
                                                        delegate:self 
                                               cancelButtonTitle:@"Cancelar"
                                               otherButtonTitles:@"OK", nil] autorelease];
        [alert show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        Item *item = [[[tab items] allObjects] objectAtIndex:[[[self tableView] indexPathForSelectedRow] row]];
        [selectedItems removeObject:item];
        [[self tableView] reloadData];
    }
}

- (void)tableView:(UITableView *)tv accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    //push ItemSettingViewController
    itemSettingViewController = [[ItemSettingViewController alloc] init];
    Item *item = [[[tab items] allObjects] objectAtIndex:[indexPath row]];
    
    
    [itemSettingViewController setLabel:[item label]];
    [itemSettingViewController setValue:[item value]];
    
    selectedPath = indexPath;
        
    NSLog(@"%@",selectedPath);
    
    [[self navigationController] pushViewController:itemSettingViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        Item *itemToDel = [[[tab items] allObjects] objectAtIndex:[indexPath row]];
        if(![selectedItems containsObject:itemToDel]){
            iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];
            NSManagedObjectContext *moc = [appDel managedObjectContext];
            [moc deleteObject:itemToDel];
            [appDel saveContext];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }else{
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!", @"Alerts:Error:Title:Error!")
                                                             message:NSLocalizedString(@"Couldn't delete this item!", @"Alerts:Error:Messages:CouldntDelete")
                                                            delegate:self 
                                                   cancelButtonTitle:@"OK" 
                                                   otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
}

@end
