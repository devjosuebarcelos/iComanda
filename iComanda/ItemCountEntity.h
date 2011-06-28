//
//  ItemCount.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 20/06/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Tab;

@interface ItemCountEntity : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) Tab *tab;
@property (nonatomic, retain) Item *item;

@end
