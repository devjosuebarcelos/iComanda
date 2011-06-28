//
//  Tab.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 20/06/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Tab : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDecimalNumber * limitValue;
@property (nonatomic, retain) NSString * venueId;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * isTipCharged;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSSet *itemCounts;

+ (NSString *)limitValueAtt;
+ (NSString *)venueIdAtt;
+ (NSString *)labelAtt;
+ (NSString *)dateAtt;
+ (NSString *)isTipChargedAtt;
+ (NSString *)itemsAtt;
+ (NSString *)itemCountsAtt;

@end

@interface Tab (CoreDataGeneratedAccessors)
- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;
- (void)addItemCountsObject:(NSManagedObject *)value;
- (void)removeItemCountsObject:(NSManagedObject *)value;
- (void)addItemCounts:(NSSet *)value;
- (void)removeItemCounts:(NSSet *)value;




@end
