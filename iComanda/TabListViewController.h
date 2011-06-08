//
//  TabListViewController.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 15/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabSettingViewController;

@interface TabListViewController : UITableViewController {

    NSIndexPath *selectedPath;
    NSMutableArray *tabList;
    TabSettingViewController *tabSettingViewController;
    
}



@end
