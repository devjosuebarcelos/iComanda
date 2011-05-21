//
//  ItemListViewController.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 16/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ItemsListViewController;
@class TabItemCountViewController;
@class CloseTabViewController;

@interface ItemListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *tabItemCountList;
    NSMutableArray *selectedItems;
    NSManagedObject *tab;
    
    IBOutlet UILabel *subTotal;
    IBOutlet UILabel *tip;
    IBOutlet UILabel *total;
    IBOutlet UITableView *itemsTableView;
    
    ItemsListViewController *itemsListViewController;
    TabItemCountViewController *tabItemCountViewController;
    CloseTabViewController *closeTabViewController;
}

- (void)setTab:(NSManagedObject *)t;
- (void)blankAllObjects;
- (IBAction)closeTabAction:(id)sender;


@end
