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
    IBOutlet UITableView *itemsTableView;
    
    ItemsListViewController *itemsListViewController;
    TabItemCountViewController *tabItemCountViewController;
    CloseTabViewController *closeTabViewController;
}

- (void)setTab:(NSManagedObject *)t;
- (void)blankAllObjects;
- (void)removeTabItemCount:(NSManagedObject *)tabItemToDel;

@end
