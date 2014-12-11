//
//  Kibeacon-iOS.h
//  iOS-Kibeacon-Sample
//
//  Created by thenopen on 2014. 12. 11..
//  Copyright (c) 2014년 thenopen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "KibeaconBlocks.h"

@interface KibeaconManager : NSObject <CLLocationManagerDelegate>

/*!
 *  Get instance of KibeaconManager that implemented with the singleton pattern.
 */
+ (id)kibeaconManager;

/*!
 *  Start ranging for the Kibeacon
 *
 *  @param complete callback
 */
- (void)startRangingForBeacons:(KBDidRangeBeacons)complete;
/*!
 *  Stop ranging for the Kibeacon
 */
- (void)stopRangingForBeacons;
/*!
 *  Make a Details Kibeacon String from CLBeacon
 *
 *  @param beacon a specific beacon want to display
 *
 *  @return Major, Minor, Proximity, Accuracy, RSSI String value
 */
- (NSString *)detailsStringForBeacon:(CLBeacon *)beacon;

@end
