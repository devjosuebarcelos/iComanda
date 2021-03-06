//
//  ItemsListViewController.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 27/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ItemSettingViewController;
@class TabItemCountViewController;
@class Tab;


@interface ItemsListViewController : UITableViewController<UIAlertViewDelegate> {
    NSMutableArray *selectedItems;
    
    NSManagedObject *selectedItem;
    
    Tab *tab;
    
    NSIndexPath *selectedPath;
    
    ItemSettingViewController *itemSettingViewController;
}
@property (nonatomic, retain) NSManagedObject *selectedItem;
@property (nonatomic, retain) NSMutableArray *selectedItems;
@property (nonatomic, retain) Tab *tab;

@end
