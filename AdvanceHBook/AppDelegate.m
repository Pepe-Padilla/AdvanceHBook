//
//  AppDelegate.m
//  AdvanceHBook
//
//  Created by Pepe Padilla on 15/11/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "AppDelegate.h"
#import "MXWLibraryMng.h"
#import "MXWLibraryViewController.h"
#import "MXWBookViewController.h"
#import "Header.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    MXWLibraryViewController *lVC = [[MXWLibraryViewController alloc]
                                     initWithStyle:UITableViewStylePlain];
    [lVC manageStart];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MXWBook * aBook = nil;
    
    id anId=[defaults objectForKey:@"MXWbook_selected"];
    if (anId) {
        aBook = [MXWBook objectWithArchivedURIRepresentation:anId
                                                     context:[lVC librayContext]];
    }
    
    if (!aBook) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        aBook = [lVC fetchedObjectAtIndexPath:indexPath];
    }
    
    
    
    
    
    MXWBookViewController * bVC = [[MXWBookViewController alloc] initWithModel:aBook];
    
    
    
    // Creo el combinador
    UINavigationController * lNav = [UINavigationController new];
    [lNav pushViewController:lVC animated:NO];
    
    UINavigationController * bNav = [UINavigationController new];
    [bNav pushViewController:bVC animated:NO];
    
    UISplitViewController * spVC = [UISplitViewController new];
    spVC.viewControllers = @[lNav,bNav];
    
    spVC.delegate=bVC;
    lVC.delegate=bVC;
    
    
    self.window = [[UIWindow alloc] initWithFrame:
                   [[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = spVC;
    
    [self.window makeKeyAndVisible];
    
    
    //[self autoSave];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
