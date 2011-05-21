//
//  TabSettingViewController.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 15/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TabSettingViewController : UIViewController {
    NSString *label;
    NSDecimalNumber *limitValue;
    
    IBOutlet UITextField *textField;
    IBOutlet UITextField *limitValueField;
}

@property (nonatomic, copy) NSString *label;
@property (nonatomic, retain) NSDecimalNumber *limitValue;

- (IBAction)create:(id)sender;
- (IBAction)cancel:(id)sender;

@end
