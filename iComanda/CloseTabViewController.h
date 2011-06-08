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
    int partyOfDozen;
    int partyOfUnit;
    
    IBOutlet UILabel *partyOfLabel;
    
    IBOutlet UISlider *tipPercentageSlider;
    IBOutlet UILabel *tipPercentageLabel;
    
    IBOutlet UILabel *tabTotalLabel;
    IBOutlet UILabel *tabSubTotalLabel;
    IBOutlet UILabel *tabTipLabel;
    
    IBOutlet UILabel *perPersonTotal;
    IBOutlet UILabel *perPersonSub;
    
    IBOutlet UIPickerView *partyOfPicker;
}

@property (nonatomic, retain) NSDecimalNumber *tabTotal;
@property (nonatomic, retain) NSDecimalNumber *tabTip;
@property (nonatomic, retain) NSDecimalNumber *tabSubTotal;
@property (nonatomic, retain) NSManagedObject *tab;

- (IBAction) calculateValuePerPerson:(id)sender;
- (IBAction) tipSlideValueChaged:(id)sender;
- (void)updateInterface;

@end
