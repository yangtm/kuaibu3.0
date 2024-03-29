//
//  AppDelegate.h
//  kuaibu
//
//  Created by yangtm on 15/8/20.
//  Copyright (c) 2015年 yangtm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MainTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic) MainTabBarController *tabBarVC;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

/**
 *  登陆成功的token
 */
@property (nonatomic,strong)NSString *token;

@property (nonatomic,assign)BOOL isLoginedIn;

@end

