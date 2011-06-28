//
//  Tab.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 20/06/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Tab.h"
#import "Item.h"


@implementation Tab
@dynamic limitValue;
@dynamic venueId;
@dynamic label;
@dynamic date;
@dynamic isTipCharged;
@dynamic items;
@dynamic itemCounts;

+ (NSString *)dateAtt{
    return @"date";
}

+ (NSString *)limitValueAtt{
    return @"limitValue";
}
+ (NSString *)venueIdAtt{
    return @"venueId";
}
+ (NSString *)labelAtt{
    return @"label";
}
+ (NSString *)isTipChargedAtt{
    return @"isTipCharged";
}
+ (NSString *)itemsAtt{
    return @"items";
}
+ (NSString *)itemCountsAtt{
    return @"itemCounts";
}


@end
