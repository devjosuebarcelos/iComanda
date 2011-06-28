//
//  Item.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 20/06/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Item.h"


@implementation Item
@dynamic label;
@dynamic value;
@dynamic tab;
@dynamic itemCounts;

+ (NSString *)valueAtt{
    return @"value";
}
+ (NSString *)labelAtt{
    return @"label";
}
+ (NSString *)tabAtt{
    return @"tab";
}
+ (NSString *)itemCountsAtt{
    return @"itemCounts";
}



@end
