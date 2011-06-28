//
//  ItemCount.m
//  iComanda
//
//  Created by Josue Barcelos Pereira on 20/06/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemCountEntity.h"
#import "Item.h"
#import "Tab.h"


@implementation ItemCountEntity
@dynamic count;
@dynamic tab;
@dynamic item;

+ (NSString *)description{
    return @"ItemCount";
}

@end
