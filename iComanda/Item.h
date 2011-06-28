//
//  Item.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 20/06/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tab, ItemCountEntity;

@interface Item : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSDecimalNumber * value;
@property (nonatomic, retain) Tab *tab;
@property (nonatomic, retain) ItemCountEntity *itemCounts;

+ (NSString *)valueAtt;
+ (NSString *)labelAtt;
+ (NSString *)tabAtt;
+ (NSString *)itemCountsAtt;


@end
