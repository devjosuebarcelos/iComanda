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
@class Tab;
@class ItemCountEntity;

@interface ItemListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *selectedItems;
    Tab *tab;
    
    IBOutlet UILabel *subTotal;
    IBOutlet UITableView *itemsTableView;
    
    ItemsListViewController *itemsListViewController;
    TabItemCountViewController *tabItemCountViewController;
    CloseTabViewController *closeTabViewController;
}

- (void)setTab:(Tab *)t;
- (void)blankAllObjects;
- (void)removeTabItemCount:(ItemCountEntity *)tabItemToDel;

@end
