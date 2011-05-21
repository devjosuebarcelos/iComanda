//
//  TabItemCountViewController.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 20/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TabItemCountViewController : UIViewController {
    
    NSString *itemLabelValue;
    int itemCountValue;
    
    int oldItemCountValue;
    
    IBOutlet UILabel *itemLabelText;
    
}

@property (nonatomic, copy) NSString *itemLabelValue;
@property (nonatomic, assign) int itemCountValue;

- (IBAction)moreItems:(id)sender;
- (IBAction)lessItems:(id)sender;
- (IBAction)create:(id)sender;
- (IBAction)cancel:(id)sender;


@end
