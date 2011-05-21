//
//  iComandaAppDelegate.h
//  iComanda
//
//  Created by Josue Barcelos Pereira on 15/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iComandaAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController *navigationController;
    
    NSManagedObject *selectedTabObject;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSManagedObject *selectedTabObject;

+ (iComandaAppDelegate *)sharedAppDelegate;

- (NSArray *)allInstancesOf:(NSString *)entityName
                  orderedBy:(NSString *)attName;

- (NSArray *)allInstancesOf:(NSString *)entityName 
                      where:(NSString *)condition 
                  orderedBy:(NSString *)attName;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
