//
//  iComandaAppDelegate.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 15/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CloseTabViewController;
@class Tab;

@interface iComandaAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController *navigationController;
    UITabBarController *tabBarController;
    Tab *selectedTabObject;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) Tab *selectedTabObject;

+ (iComandaAppDelegate *)sharedAppDelegate;

- (NSArray *)allInstancesOf:(NSString *)entityName
                  orderedBy:(NSString *)attName
                  ascending:(BOOL)ascending;

- (NSArray *)allInstancesOf:(NSString *)entityName 
                      where:(NSString *)condition 
                  orderedBy:(NSString *)attName
                  ascending:(BOOL)ascending;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
