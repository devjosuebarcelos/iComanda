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



@implementation ItemsListViewController
@synthesize selectedItem, selectedItems, tab;

- (id)init{
    self = [super initWithNibName:nil bundle:nil];
    //before separate tab/item
    //iComandaAppDelegate *ac = [iComandaAppDelegate sharedAppDelegate];
    
    //itemList = [[ac allInstancesOf:ITEM_ENTITY where:@"" orderedBy:LABEL_ATT] mutableCopy];
    
    [self setTitle:@"Cardápio"];
        
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
    [itemList release];
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
//    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)setSelectedItems:(NSMutableArray *)selItems{
    [selectedItems release];
    selectedItems = [[NSMutableArray alloc] initWithArray:selItems];
    
}

- (void)setTab:(NSManagedObject *)t{
    [t retain];
    [tab release];
    tab = t;
    
    NSArray *availableItems = [tab valueForKey:ITEMS_ATT];
    
    itemList = [[NSMutableArray alloc] init];
    for (NSManagedObject *it in availableItems){
        [itemList addObject:it];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //NSIndexPath *selectedPath = [[self tableView] indexPathForSelectedRow];
    NSLog(@"selectedPath %@",selectedPath);
    
    if(itemSettingViewController){
        

        iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];

        NSString *label = [itemSettingViewController label];
        NSDecimalNumber *value = [itemSettingViewController value];
        
        if(label && value){
            NSManagedObject *item;
            if(!selectedPath){
                NSManagedObjectContext *moc = [appDel managedObjectContext];
                item = [NSEntityDescription insertNewObjectForEntityForName:ITEM_ENTITY inManagedObjectContext:moc];
                [item setValue:tab forKey:TAB_ATT];
                [itemList addObject:item];
                
                
            }else{
                item = [itemList objectAtIndex:[selectedPath row]];
                
            }
            
            
            [item setValue:label forKey:LABEL_ATT];
            [item setValue:value forKey:VALUE_ATT];
            
            
            NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:LABEL_ATT ascending:YES];
            NSArray *sds = [NSArray arrayWithObject:sd];
            [sd release];
            [itemList sortUsingDescriptors:sds];
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
    
    NSManagedObject *item = [itemList objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@",[item valueForKey:LABEL_ATT], [NSNumberFormatter localizedStringFromNumber:[item valueForKey:VALUE_ATT] numberStyle:NSNumberFormatterCurrencyStyle]   ]];
    
    
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
    return [itemList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *item = [itemList objectAtIndex:[indexPath row]];
    
    if(![selectedItems containsObject:item]){
        
        [self setSelectedItem:item];
        [selectedItems addObject:item];
        //[item release];
        //[[self navigationController] popViewControllerAnimated:YES];
        [tableView reloadData];
    }else{
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Aviso!" message:@"Desmarcar esse item irá excluir a contagem do mesmo na comanda! Deseja prosseguir?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"OK", nil] autorelease];
        [alert show];
        
        //[selectedItems removeObject:item];
        //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
//    [tableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSManagedObject *item = [itemList objectAtIndex:[[[self tableView] indexPathForSelectedRow] row]];
        [selectedItems removeObject:item];
        [[self tableView] reloadData];
    }
}

- (void)tableView:(UITableView *)tv accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    //push ItemSettingViewController
    itemSettingViewController = [[ItemSettingViewController alloc] init];
    NSManagedObject *item = [itemList objectAtIndex:[indexPath row]];
    
    [itemSettingViewController setLabel:[item valueForKey:LABEL_ATT]];
    [itemSettingViewController setValue:[item valueForKey:VALUE_ATT]];
    
    selectedPath = indexPath;
        
    NSLog(@"%@",selectedPath);
    
    [[self navigationController] pushViewController:itemSettingViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        NSManagedObject *itemToDel = [itemList objectAtIndex:[indexPath row]];
        if(![selectedItems containsObject:itemToDel]){
            iComandaAppDelegate *appDel = [iComandaAppDelegate sharedAppDelegate];
            NSManagedObjectContext *moc = [appDel managedObjectContext];
            [moc deleteObject:itemToDel];
            [appDel saveContext];
            
            
            [itemList removeObject:itemToDel];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }else{
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Erro!" message:@"Não é possível excluir este item!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
}

@end
