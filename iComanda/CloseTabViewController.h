//
//  CloseTabViewController.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 09/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CloseTabViewController : UIViewController<UITextFieldDelegate> {
    
    NSDecimalNumber *tabTotal;
    NSDecimalNumber *tabSubTotal;
    NSDecimalNumber *tabTip;
    
    NSManagedObject *tab;
    
    int partyOf;
    
    IBOutlet UILabel *partyOfLabel;
    IBOutlet UITextField *partyOfTextField;
    
    IBOutlet UILabel *tabTotalLabel;
    IBOutlet UILabel *tabSubTotalLabel;
    IBOutlet UILabel *tabTipLabel;
    
    IBOutlet UILabel *perPersonTotal;
    IBOutlet UILabel *perPersonSub;
    
    IBOutlet UIButton *calculateButton;
    
}

@property (nonatomic, retain) NSDecimalNumber *tabTotal;
@property (nonatomic, retain) NSDecimalNumber *tabTip;
@property (nonatomic, retain) NSDecimalNumber *tabSubTotal;
@property (nonatomic, retain) NSManagedObject *tab;

- (IBAction) calculateValuePerPerson:(id)sender;

@end
