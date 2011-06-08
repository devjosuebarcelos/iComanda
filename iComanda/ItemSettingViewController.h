//
//  ItemSettingViewController.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 17/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ItemSettingViewController : UIViewController {
    IBOutlet UITextField *labelTextField;
    IBOutlet UITextField *valueTextField;
    IBOutlet UIButton *clearFieldsButton;
    
    NSString *label;
    NSDecimalNumber *value;
    
}

@property (nonatomic, copy) NSString *label;
@property (nonatomic, retain) NSDecimalNumber *value;

- (IBAction)create:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)clearFields:(id)sender;

@end
