//
//  AppDelegate.m
//  iOS-Kibeacon-Sample
//
//  Created by thenopen on 2014. 12. 9..
//  Copyright (c) 2014년 thenopen. All rights reserved.
//

#import "AppDelegate.h"
#import "KibeaconManager.h"

@interface AppDelegate () {
    UIBackgroundTaskIdentifier bgTask;
}
@property (strong, nonatomic) KibeaconManager *beaconManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.beaconManager = [KibeaconManager kibeaconManager];
    [_beaconManager startMonitoringForBeacons:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access Missing"
                                                        message:@"Required Location Access(Always) missing. Click Settings to update Location Access."
                                                       delegate:self
                                              cancelButtonTitle:@"Settings"
                                              otherButtonTitles:@"Cancel", nil];
        [alert show];
    } Updated:^(BOOL isEnter, CLBeaconRegion *region) {
        UILocalNotification *notification = [UILocalNotification new];

        if (isEnter) {
            // Notification details
            notification.alertBody = [NSString stringWithFormat:@"Entered beacon region for UUID: %@",
                                      region.proximityUUID.UUIDString];
        } else {
            notification.alertBody = [NSString stringWithFormat:@"Exited beacon region for UUID: %@",
                                      region.proximityUUID.UUIDString];
        }
        
        notification.alertAction = NSLocalizedString(@"View Details", nil);
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [_beaconManager stopMonitoringForBeacons];
}

@end
