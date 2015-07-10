//
//  KibeaconBlocks.h
//  iOS-Kibeacon-SDK
//
//  Created by thenopen on 2014. 10. 27..
//  Copyright (c) 2014년 KIES. All rights reserved.
//
#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface KibeaconRegion : CLBeaconRegion

/*!
 * Initialize Kibeeacon region with identifier, Major and minor values will be wildcarded
 *
 */

- (id)initWithIdentifier:(NSString *)identifier;

@end
